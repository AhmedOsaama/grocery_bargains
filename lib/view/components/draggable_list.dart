import 'dart:convert';
import 'dart:developer';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/models/list_item.dart';
import 'package:bargainb/models/product.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/services/network_services.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/product_detail_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

final itemsState = new ValueNotifier([]);

class DraggableList extends StatefulWidget {
  DraggableList(
      {Key? key,
      required this.items,
      required this.listId,
      required this.inChatView})
      : super(key: key);
  final List<QueryDocumentSnapshot<Object?>> items;
  final String listId;
  final bool inChatView;
  @override
  _DraggableListState createState() => _DraggableListState();
}

class ItemData {
  ItemData(
    this.text,
    this.key,
    this.name,
    this.img,
    this.size,
    this.price,
    this.isChecked,
    this.id,
    this.parentId,
    this.owner,
    this.storeName,
  );

  final String text;
  final String name;
  final String img;
  final String size;

  final String price;
  final String storeName;

  final String owner;

  bool isChecked;
  final String id;
  final String? parentId;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

enum DraggingMode {
  iOS,
  android,
}

class _DraggableListState extends State<DraggableList> {
  List<ItemData> _items = [];

  @override
  void initState() {
    super.initState();

    widget.items.forEach((element) {
      if (element["text"].toString().isNotEmpty) {
        _items.add(ItemData(
            element["text"],
            ValueKey(element),
            "",
            "",
            "",
            "",
            element["item_isChecked"] ?? false,
            element.id,
            element.reference.parent.parent?.id ?? "",
            element["owner"],
            ""));
      } else {
        String price = "0.0";
        if (element['item_price'] != "" &&
            element['item_price'] != null &&
            element['item_price'] != "null") {
          price = element['item_price'];
        }

        _items.add(ItemData(
            element["text"] ?? "",
            ValueKey(element),
            element["item_name"] ?? "",
            element["item_image"] ?? "",
            element["item_size"] ?? "",
            price,
            element["item_isChecked"] ?? false,
            element.id,
            element.reference.parent.parent?.id ?? "",
            element["owner"] ?? "",
            element.data().toString().contains("store_name")
                ? element["store_name"]
                : ""));
      }
    });
    if (!widget.inChatView) {
      _items.add(ItemData(
          "ç", ValueKey("ç"), "", "", "", "0.0", false, "", "", "", ""));
    }
    itemsState.value = _items;
    itemsState.notifyListeners();
  }

  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];

    _items.removeAt(draggingIndex);
    itemsState.value = _items;
    itemsState.notifyListeners();
    _items.insert(newPositionIndex, draggedItem);
    itemsState.value = _items;
    itemsState.notifyListeners();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableList(
        onReorderDone: (draggedItem) async {
          final instance = FirebaseFirestore.instance;
          final batch = instance.batch();
          var collection = instance
              .collection('lists')
              .doc(widget.listId)
              .collection("items");
          var snapshots = await collection.get();
          try {
            List<DocumentReference<Map<String, dynamic>>> refs = [];

            for (var doc in snapshots.docs) {
              refs.add(doc.reference);
              batch.delete(doc.reference);
            }
            int i = 0;

            for (var item in _items) {
              if (item.text != "ç") {
                batch.set(
                  refs.elementAt(i),
                  {
                    "item_name": item.name,
                    "item_size": item.size,
                    "item_price": item.price,
                    "item_image": item.img,
                    "item_isChecked": false,
                    "text": item.text,
                    "owner": item.owner,
                    "time": Timestamp.now(),
                  },
                );
                i++;
              }
            }

            await batch.commit();
          } catch (e) {
            log(e.toString());
          }
        },
        onReorder: _reorderCallback,
        child: ValueListenableBuilder(
            valueListenable: itemsState,
            builder: (context, value, menu) {
              return ListView.separated(
                  itemBuilder: (c, i) {
                    return Item(
                      inChatView: widget.inChatView,
                      data: itemsState.value[i],
                      isFirst: i == 0,
                      isLast: i == itemsState.value.length - 1,
                      listId: widget.listId,
                    );
                  },
                  separatorBuilder: (ctx, _) => const Divider(),
                  itemCount: itemsState.value.length);
            }));
  }
}

class Item extends StatefulWidget {
  Item({
    Key? key,
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.listId,
    required this.inChatView,
  }) : super(key: key);

  ItemData data;

  final bool isFirst;
  final bool isLast;
  final bool inChatView;
  final String listId;
  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool isAdding = false;
  String newItem = "";
  bool formisEmpty = true;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = const BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: widget.isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: widget.isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.white);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = ReorderableListener(
      child: Container(
        padding: EdgeInsets.only(left: widget.inChatView ? 0 : 18.0),
        child: const Center(
          child: Icon(Icons.drag_indicator, color: purple30),
        ),
      ),
    );

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: widget.data.text.isNotEmpty
                  ? ((widget.data.text == "ç")
                      ? ((GestureDetector(
                          onTap: () async {
                            if (isAdding) {
                              if (!formisEmpty) {
                                try {
                                  await Provider.of<ChatlistsProvider>(context,
                                          listen: false)
                                      .addItemToList(
                                          ListItem(
                                              storeName: "",
                                              imageURL: '',
                                              isChecked: false,
                                              name: '',
                                              price: "0.0",
                                              quantity: 0,
                                              size: '',
                                              text: newItem),
                                          widget.listId);
                                  var r = itemsState.value.last;
                                  itemsState.value.last = (ItemData(
                                      newItem,
                                      ValueKey(newItem),
                                      "",
                                      "",
                                      "",
                                      "0.0",
                                      false,
                                      "",
                                      "",
                                      "",
                                      ""));
                                  itemsState.value.add(r);

                                  itemsState.notifyListeners();
                                } catch (e) {
                                  log(e.toString());
                                }
                                setState(() {
                                  isAdding = !isAdding;
                                });
                              } else {
                                setState(() {
                                  isAdding = !isAdding;
                                });
                              }
                            } else {
                              setState(() {
                                isAdding = !isAdding;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              40.pw,
                              Container(
                                height: 20.h,
                                width: 20.w,
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(5, 55, 84, 0.5),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 17.sp,
                                    color: Color.fromRGBO(5, 55, 84, 0.5),
                                  ),
                                ),
                              ),
                              isAdding
                                  ? SizedBox(
                                      width: ScreenUtil().screenWidth * 0.7,
                                      child: TextFormField(
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: formisEmpty
                                                    ? darkGrey
                                                    : grey),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: formisEmpty
                                                    ? darkGrey
                                                    : grey),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            setState(() {
                                              formisEmpty = true;
                                            });
                                          } else {
                                            setState(() {
                                              newItem = value;
                                              formisEmpty = false;
                                            });
                                          }
                                        },
                                      ),
                                    )
                                  : Text(
                                      "QuickAdd".tr(),
                                      style: TextStyles.textViewSemiBold16
                                          .copyWith(
                                              color: Color.fromRGBO(
                                                  5, 55, 84, 0.5)),
                                    ),
                            ],
                          ),
                        )))
                      : Opacity(
                          opacity: widget.data.isChecked ? 0.6 : 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              dragHandle,
                              Checkbox(
                                value: widget.data.isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    widget.data.isChecked =
                                        !widget.data.isChecked;
                                  });
                                  FirebaseFirestore.instance
                                      .collection(
                                          "/lists/${widget.data.parentId}/items")
                                      .doc(widget.data.id)
                                      .update({
                                    "item_isChecked": widget.data.isChecked,
                                  }).catchError((e) {
                                    print(e);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("OperationNotDone".tr())));
                                  });
                                  // updateList();
                                },
                              ),
                              Text(
                                widget.data.text,
                                style: TextStylesInter.textViewRegular16
                                    .copyWith(color: black2),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    try {
                                      await Provider.of<ChatlistsProvider>(
                                              context,
                                              listen: false)
                                          .deleteItemFromChatlist(
                                              widget.data.parentId!,
                                              widget.data.id,
                                              widget.data.price);
                                      itemsState.value.remove(widget.data);
                                      var listItems = FirebaseFirestore.instance
                                          .collection(
                                              '/lists/${widget.listId}/items')
                                          .get();
                                      itemsState.notifyListeners();
                                    } catch (e) {
                                      print(e);
                                    }

                                    //TODO: check if the item has a chat reference before deleting and if it has then mark the item as un added
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Opacity(
                            opacity: widget.data.isChecked ? 0.6 : 1,
                            child: Row(
                              children: [
                                dragHandle,
                                Checkbox(
                                  value: widget.data.isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.data.isChecked =
                                          !widget.data.isChecked;
                                    });
                                    FirebaseFirestore.instance
                                        .collection(
                                            "/lists/${widget.data.parentId}/items")
                                        .doc(widget.data.id)
                                        .update({
                                      "item_isChecked": widget.data.isChecked,
                                    }).catchError((e) {
                                      print(e);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "OperationNotDone".tr())));
                                    });
                                    // updateList();
                                  },
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    late Product product;

                                    switch (widget.data.storeName) {
                                      case 'Hoogvliet':
                                        var response = await NetworkServices
                                            .searchHoogvlietProducts(
                                                widget.data.name);
                                        product = Provider.of<ProductsProvider>(
                                                context,
                                                listen: false)
                                            .convertToProductListFromJson(
                                                jsonDecode(response.body))
                                            .first;

                                        break;
                                      case 'Jumbo':
                                        var response = await NetworkServices
                                            .searchJumboProducts(
                                                widget.data.name);
                                        product = Provider.of<ProductsProvider>(
                                                context,
                                                listen: false)
                                            .convertToProductListFromJson(
                                                jsonDecode(response.body))
                                            .first;

                                        break;
                                      case 'Albert':
                                        var response = await NetworkServices
                                            .searchAlbertProducts(
                                                widget.data.name);

                                        product = Provider.of<ProductsProvider>(
                                                context,
                                                listen: false)
                                            .convertToProductListFromJson(
                                                jsonDecode(response.body))
                                            .first;

                                        break;
                                    }

                                    AppNavigator.push(
                                        context: context,
                                        screen: ProductDetailScreen(
                                          comparisonId: -1,
                                          productId: product.id,
                                          oldPrice: product.oldPrice,
                                          storeName: product.storeName,
                                          productName: product.name,
                                          imageURL: product.imageURL,
                                          description: product.description,
                                          size1: product.size,
                                          size2: product.size2 ?? "",
                                          price1: double.tryParse(
                                                  product.price ?? "") ??
                                              0.0,
                                          price2: double.tryParse(
                                                  product.price2 ?? "") ??
                                              0.0,
                                        ));
                                  },
                                  child: Image.network(
                                    widget.data.img,
                                    width: 55,
                                    height: 55,
                                  ),
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Flexible(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.data.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyles.textViewSemiBold14
                                              .copyWith(
                                                  color: prussian,
                                                  decoration:
                                                      widget.data.isChecked
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null),
                                        ),
                                        Container(
                                          width: 150.w,
                                          child: Text(
                                            "${widget.data.size}",
                                            style: TextStyles.textViewLight12
                                                .copyWith(
                                                    color: prussian,
                                                    decoration:
                                                        widget.data.isChecked
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : null),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "€ ${widget.data.price}",
                                  style: TextStyles.textViewMedium13.copyWith(
                                    color: prussian,
                                    decoration: widget.data.isChecked
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              try {
                                await Provider.of<ChatlistsProvider>(context,
                                        listen: false)
                                    .deleteItemFromChatlist(
                                        widget.data.parentId!,
                                        widget.data.id,
                                        widget.data.price);
                                var res = await FirebaseFirestore.instance
                                    .collection('/lists/${widget.listId}/items')
                                    .get();
                                var storeItems = res.docs;
                                itemsState.value.remove(widget.data);

                                itemsState.notifyListeners();
                                updateStoreImages(storeItems);
                              } catch (e) {
                                print(e);
                              }

                              //TODO: check if the item has a chat reference before deleting and if it has then mark the item as un added
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
            ),
          )),
    );

    return content;
  }

  void updateStoreImages(var storeItems) {
    var storeImages = {"jumbo": false, "hoogvliet": false, "albert": false};
    if (storeItems.isNotEmpty) {
      storeItems.forEach((element) {
        if (element["text"] == "") {
          if (element["item_image"].toString().contains("jumbo")) {
            storeImages["jumbo"] = true;
          } else if (element["item_image"].toString().contains(".ah.")) {
            storeImages["albert"] = true;
          } else if (element["item_image"].toString().contains("hoogvliet")) {
            storeImages["hoogvliet"] = true;
          }
        }
      });
      List<Widget> newImages = [];
      storeImages.forEach((key, value) {
        if (value) {
          switch (key) {
            case "jumbo":
              newImages.add(SizedBox(
                  height: 30.h, width: 30.w, child: Image.asset(jumbo)));
              break;
            case "albert":
              newImages.add(SizedBox(
                  height: 30.h, width: 30.w, child: Image.asset(albert)));

              break;
            case "hoogvliet":
              newImages.add(SizedBox(
                  height: 30.h, width: 30.w, child: Image.asset(hoogLogo)));
              break;
          }
          newImages.add(10.pw);
        }
      });
      imagesWidgets.value = newImages;
    } else {
      imagesWidgets.value = [];
    }
    imagesWidgets.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: widget.data.key, //
        childBuilder: _buildChild);
  }
}
