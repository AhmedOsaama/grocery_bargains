import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/fonts_utils.dart';
import 'package:swaav/view/components/generic_appbar.dart';
import 'package:swaav/view/components/my_scaffold.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/category_items_screen.dart';
import 'package:swaav/view/screens/chat_view_screen.dart';
import 'package:swaav/view/screens/profile_screen.dart';
import 'package:swaav/view/widgets/chat_view_widget.dart';

import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';
import '../components/dotted_container.dart';

class ChatListViewScreen extends StatefulWidget {
  final String listId;
  String listName;
  final String? storeName;
  final String? storeImage;
  final bool isUsingDynamicLink;
  bool isListView;
  final Function? updateList;
  ChatListViewScreen(
      {Key? key,
      required this.listId,
      required this.listName,
      this.isUsingDynamicLink = false,
      this.storeName,
      this.storeImage,
      this.updateList,
        this.isListView = false     //The screen opens on a Chat View by default
      })
      : super(key: key);

  @override
  State<ChatListViewScreen> createState() => _ChatListViewScreenState();
}

class _ChatListViewScreenState extends State<ChatListViewScreen> {
  bool isDeleting = false;
  late Future<Widget> getUserImagesFuture;
  bool isEditingName = false;

  @override
  void initState() {
    if (widget.isUsingDynamicLink) {
      var currentUserId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore.instance
          .collection('/lists')
          .doc(widget.listId)
          .get()
          .then((listSnapshot) {
        final List userIds = listSnapshot.data()!['userIds'];
        if (!userIds.contains(currentUserId)) {
          userIds.add(currentUserId);
          FirebaseFirestore.instance
              .collection('/lists')
              .doc(widget.listId)
              .update({"userIds": userIds});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("User added successfully to list ${widget.listName}")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User Already Exists in the list")));
        }
      });
    }
    getUserImagesFuture = getUserImages();
    super.initState();
  }

  Future<Widget> getUserImages() async {
    List<Widget> imageWidgets = [];
    imageWidgets.clear();
    List userIds = [];
    try {
      final list = await FirebaseFirestore.instance
          .collection('/lists')
          .doc(widget.listId)
          .get()
          .timeout(Duration(seconds: 10));
      userIds = list['userIds'];
    } catch (e) {
      print(e);
      return SvgPicture.asset(peopleIcon);
    }
    if (userIds.isEmpty) return SvgPicture.asset(peopleIcon);
    String imageUrl = "";
    for (var userId in userIds) {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('/users')
          .doc(userId)
          .get();
      imageUrl = userSnapshot.data()!['imageURL'];
      imageWidgets.add(CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
        radius: 20,
      ));
    }

    return GestureDetector(
      onTap: (){

      },
      child: SizedBox(
        // width: 100.w,
        height: 50.h,
        child: Stack(
          alignment: Alignment.center,
          children: imageWidgets
              .map((image) => Positioned(
                    left: imageWidgets.indexOf(image) * 20,
                    child: image,
                  ))
              .toList()
            ..add(Positioned(                                             //plus button
              left: imageWidgets.length * 20,
              child: Center(
                child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromRGBO(245, 245, 245, 1),
                    ),
                    child: SvgPicture.asset(plusIcon)),
              ),
            )),
        ),
      ),
    );
  }

  String getTotalListPrice(List items) {
    var total = 0.0;
    for (var item in items) {
      total += item['item_price'] ?? 99999;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: Colors.black,
      ),
      body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    widget.storeImage != null
                        ? Image.asset(widget.storeImage!,width: 45,)
                        : Container(),
                    SizedBox(
                      width: 10.w,
                    ),
                    widget.storeName != null
                        ? Text(
                            widget.storeName!,
                            style: TextStyles.textViewMedium16
                                .copyWith(color: prussian),
                          )
                        : Container(),
                    SizedBox(
                      width: 10.w,
                    ),
                    // widget.storeImage != null ? Image.asset(widget.storeImage!) : Container(),
                    Spacer(),
                    FutureBuilder(
                        future: getUserImagesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: verdigris,
                            ));
                          }
                          return Flexible(
                            child: snapshot.data ??
                                const Text("Something went wrong"),
                          );
                        }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      isEditingName ? Expanded(
                        child: TextFormField(
                          initialValue: widget.listName,
                          style: TextStyles.textViewSemiBold30.copyWith(color: prussian),
                          onFieldSubmitted: (value) async {
                            await updateListName(value);
                          },
                        ),
                      ) : Text(
                        widget.listName,
                        style:
                            TextStyles.textViewSemiBold30.copyWith(color: prussian),
                      ),
                      Spacer(),
                      DropdownButton(
                        underline: Container(),
                        icon: Icon(Icons.more_vert,color: Colors.black,),items: const [
                        DropdownMenuItem(
                            value: 'rename',
                            child: Text("Rename")
                        ),
                        DropdownMenuItem(
                            value: 'remove',
                            child: Text("Remove")
                        ),DropdownMenuItem(
                            value: 'copy',
                            enabled: false,
                            child: Text("Copy"),
                        ),
                      ],
                        onChanged: (option){
                          if(option == 'rename'){
                            setState((){
                            isEditingName = true;
                            });
                          }else if(option == 'remove'){
                            deleteList(context);
                          }
                        },
                      ),
                      20.pw,
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            widget.isListView = !widget.isListView;
                          });
                        },
                          child: SvgPicture.asset(listViewIcon)),
                    ],
                  ),
                ),
                Divider(
                  height: 10.h,
                ),
                widget.isListView ?
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('/lists/${widget.listId}/items')
                          // .where('message', isEqualTo: '')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final items = snapshot.data?.docs ?? [];
                        if (items.isEmpty || !snapshot.hasData) {
                          return Container(
                            margin: EdgeInsets.only(top: 100.h),
                            alignment: Alignment.topCenter,
                            child: DottedContainer(
                              text: LocaleKeys.addToListFirstItem.tr(),
                            ),
                          );
                        }
                      return Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => shareList(), icon: Icon(Icons.share_outlined)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.isListView = !widget.isListView;
                                    });
                                  },
                                  icon: Icon(Icons.message_outlined)),
                              Spacer(),
                              Text(
                                "${items.length} items",
                                style: TextStyles.textViewMedium10
                                    .copyWith(color: Color.fromRGBO(204, 204, 203, 1)),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                LocaleKeys.total.tr(),
                                style: TextStyles.textViewMedium15
                                    .copyWith(color: prussian),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              // Text("€ ${getTotalListPrice(items)}",
                              //     style: TextStyles.textViewSemiBold18
                              //         .copyWith(color: prussian)),
                            ],
                          ),
                          Expanded(
                            child: ListView.separated(
                                itemCount: items.length,
                                separatorBuilder: (ctx, _) => const Divider(),
                                itemBuilder: (ctx, i) {
                                  var doc = items[i];
                                  var isChecked = items[i]['item_isChecked'];
                                  if(items[i]['text'] != ''){
                                    return Opacity(
                                      opacity: isChecked ? 0.6 : 1,
                                      child: Row(
                                        children: [
                                          30.pw,
                                          Checkbox(
                                            value: isChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                isChecked = !isChecked;
                                              });
                                              FirebaseFirestore.instance
                                                  .collection(
                                                  "/lists/${doc.reference.parent.parent?.id}/items")
                                                  .doc(doc.id)
                                                  .update({
                                                "item_isChecked": isChecked,
                                              }).catchError((e) {
                                                print(e);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "This operation couldn't be done please try again")));
                                              });
                                              updateList();
                                            },
                                          ),
                                          Text(items[i]['text'],style: TextStylesInter.textViewRegular16.copyWith(color: black2),)
                                        ],
                                      ),
                                    );
                                  }

                                  var itemName = items[i]['item_name'];
                                  var itemImage = items[i]['item_image'];
                                  var itemDescription = items[i]['item_description'];
                                  var itemPrice = items[i]['item_price'];
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Opacity(
                                          opacity: isChecked ? 0.6 : 1,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: isChecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isChecked = !isChecked;
                                                  });
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "/lists/${doc.reference.parent.parent?.id}/items")
                                                      .doc(doc.id)
                                                      .update({
                                                    "item_isChecked": isChecked,
                                                  }).catchError((e) {
                                                    print(e);
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                            content: Text(
                                                                "This operation couldn't be done please try again")));
                                                  });
                                                  updateList();
                                                },
                                              ),
                                              Image.network(
                                                itemImage,
                                                width: 55,
                                                height: 55,
                                              ),
                                              SizedBox(
                                                width: 12.w,
                                              ),
                                              Container(
                                                width: 140.w,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      itemName,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyles.textViewSemiBold14
                                                          .copyWith(
                                                              color: prussian,
                                                              decoration: isChecked
                                                                  ? TextDecoration
                                                                      .lineThrough
                                                                  : null),
                                                    ),
                                                    Text(
                                                      "$itemDescription",
                                                      style: TextStyles.textViewLight12
                                                          .copyWith(
                                                              color: prussian,
                                                              decoration: isChecked
                                                                  ? TextDecoration
                                                                      .lineThrough
                                                                  : null),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                "€ $itemPrice",
                                                style: TextStyles.textViewMedium13
                                                    .copyWith(
                                                  color: prussian,
                                                  decoration: isChecked
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
                                            setState(() {
                                              items.remove(items[i]);
                                            });
                                            await FirebaseFirestore.instance
                                                .collection('/lists/${widget.listId}/items')
                                                .doc(doc.id).delete();
                                            updateList();
                                          },
                                          icon: const Icon(Icons.delete,color: Colors.red,)),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      );
                    }
                  ),
                )
                    : Expanded(
                    child: ChatView(listId: widget.listId))
              ],
            ),
    );
  }

  Future<void> shareList() async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "https://www.google.com/add_user/${widget.listName}/${widget.listId}"), //TODO: listName has white space and that won't reflect well in using the link later
      uriPrefix: "https://swaav.page.link",
      androidParameters:
      const AndroidParameters(packageName: "com.example.swaav"),
      // iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance
        .buildShortLink(dynamicLinkParams);
    Share.share(dynamicLink.shortUrl.toString());
  }

  Future<void> updateListName(String value) async {
      setState(() {
      isEditingName = false;
      widget.listName = value;
    });
    await FirebaseFirestore.instance.collection('/lists').doc(widget.listId).update({
      "list_name": value
    });
    updateList();
  }

  void deleteList(BuildContext context) {
     FirebaseFirestore.instance.collection('/lists').doc(widget.listId).delete().then((value) {
      updateList();
      return AppNavigator.pop(context: context);
    }).onError((error, stackTrace) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn't delete list. Please try again later")));
    });
  }

  void updateList() {
     widget.updateList != null
        ? widget.updateList!()
        : () {};
  }
}
