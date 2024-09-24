import 'dart:convert';
import 'dart:developer';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/chatlists/presentation/views/widgets/chatlist_overview_widget.dart';
import 'package:bargainb/features/chatlists/presentation/views/widgets/quick_item_text_field.dart';
import 'package:bargainb/features/home/data/models/product_category.dart';
import 'package:bargainb/providers/subscription_provider.dart';
import 'package:bargainb/providers/user_provider.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/down_triangle_painter.dart';
import 'package:bargainb/utils/tooltips_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/utils/utils.dart';
import 'package:bargainb/view/components/dotted_container.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';

import 'chat_prompts_widget.dart';
import 'itemListWidget.dart';
import '../../../../../providers/tutorial_provider.dart';
import '../../../../../view/widgets/message_bubble.dart';

class ChatView extends StatefulWidget {
  final String listId;
  final String chatlistName;
  final Function showInviteMembersDialog;
  final BuildContext showcaseContext;
  final String? promptMessage;

  ChatView(
      {Key? key,
      required this.listId,
      required this.showInviteMembersDialog,
      required this.chatlistName,
      required this.showcaseContext, this.promptMessage,
      })
      : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool isAddingItem = false;
  late Future<int> getAllProductsFuture;
  late Stream<QuerySnapshot<Object>> chatStream;
  late Stream<QuerySnapshot<Object>> chatlistItemsStream;
  var messageController = TextEditingController();
  var pageController = PageController();
  List allProducts = [];
  var isLoading = false;
  var isCollapsed = true;
  List albertItems = [];
  List jumboItems = [];
  List hoogvlietItems = [];
  List dirkItems = [];
  List edekaItems = [];
  List plusItems = [];
  List reweItems = [];
  List coopItems = [];
  List sparItems = [];
  List aldiItems = [];
  List quicklyAddedItems = [];
  TextEditingController quickItemController = TextEditingController();
  var pageNumber = 0;

  bool isBotLoading = false;


  Future turnOffFirstTimeChatlist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('firstTimeChatlist', false);
    print('turned off first time');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getOnboardingStore();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.subscribeToTopic(widget.listId);
    chatStream = FirebaseFirestore.instance
        .collection("/lists/${widget.listId}/messages")
        .orderBy('createdAt', descending: true)
        .snapshots();
    chatlistItemsStream =
        FirebaseFirestore.instance.collection("/lists/${widget.listId}/items")
            .orderBy('time')
    .snapshots();
    if(widget.promptMessage != null){
      messageController.text = widget.promptMessage!;
      submitMessage(context);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tutorialProvider = Provider.of<TutorialProvider>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: chatlistItemsStream,
        builder: (context, snapshot) {
          final items = snapshot.data?.docs ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return Column(
            children: [
              Provider.of<SubscriptionProvider>(context,listen: false).isSubscribed ?
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (page) {
                    setState(() {
                      pageNumber = page;
                    });
                  },
                  children: [
                    buildChatView(items, widget.showcaseContext),
                    buildListView(items, context),
                  ],
                ),
              ) : Expanded(child: buildListView(items, context))
              // 20.ph,
            ],
          );
        });
  }

  Consumer<ChatlistsProvider> buildListView(List<QueryDocumentSnapshot<Object?>> items, BuildContext context) {
    return Consumer<ChatlistsProvider>(
        builder: (ctx, chatlistProvider, _) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: Utils.boxShadow,
              ),
              child: Column(
                children: [
                  ChatlistOverviewWidget(
                    items: items,
                    pageController: pageController,
                    pageNumber: pageNumber,
                  ),
                  Builder(builder: (ctx) {
                    return buildItemList(context, items); //default case: items are not empty
                  }),
                ],
              ),
            ));
  }


  Widget buildItemList(BuildContext context, List<QueryDocumentSnapshot> items) {
    clearAllStoreLists();
    populateStoreLists(items);
    return ItemListWidget(
        quicklyAddedItems: quicklyAddedItems,
        quickItemController: quickItemController,
        widget: widget,
        albertItems: albertItems,
        jumboItems: jumboItems,
        hoogvlietItems: hoogvlietItems,
        dirkItems: dirkItems,
        edekaItems: edekaItems,
      plusItems: plusItems,
      reweItems: reweItems,
      coopItems: coopItems,
      sparItems: sparItems,
      aldiItems: aldiItems,
    );
  }

  void populateStoreLists(List<QueryDocumentSnapshot<Object?>> items) {
    // log("Items: ${items.last.data()}");
    for (var item in items) {
      if (item['store_name'] == "albert") {
        albertItems.add(item);
      }
      if (item['store_name'] == "jumbo") {
        jumboItems.add(item);
      }
      if (item['store_name'] == "hoogvliet") {
        hoogvlietItems.add(item);
      }
      if (item['store_name'] == "Dirk") {
        dirkItems.add(item);
      }
      if (item['store_name'] == "edeka24") {
        edekaItems.add(item);
      }
      if (item['store_name'] == "Plus") {
        plusItems.add(item);
      }
      if (item['store_name'] == "Rewe") {
        reweItems.add(item);
      }
      if (item['store_name'] == "Spar") {
        sparItems.add(item);
      }
      if (item['store_name'] == "Aldi") {
        aldiItems.add(item);
      }
      if (item['store_name'].isEmpty) {
        quicklyAddedItems.add(item);
      }
    }
  }

  void clearAllStoreLists() {
    albertItems.clear();
    jumboItems.clear();
    hoogvlietItems.clear();
    dirkItems.clear();
    quicklyAddedItems.clear();
  }

  StreamBuilder<QuerySnapshot<Object?>> buildChatView(
      List<QueryDocumentSnapshot<Object?>> items, BuildContext showcaseContext) {
    var tutorialProvider = Provider.of<TutorialProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: chatStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data?.docs ?? [];
          return Column(
            children: [
              ChatlistOverviewWidget(
                items: items,
                pageController: pageController,
                pageNumber: pageNumber,
              ),
              (messages.isEmpty || !snapshot.hasData)
                  ? Expanded(child: ChatPrompts(
                sendPrompt: (prompt) async {
                  messageController.text = prompt;
                  await submitMessage(context);
                },
              ))
                  : Expanded(
                      child: ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (ctx, index) {
                            // log(messages[index]['item_price'].runtimeType.toString());
                            // log(messages[index]['item_oldPrice'].runtimeType.toString());
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                child: MessageBubble(
                                  itemId: (messages[index].data()! as Map).containsKey('item_id')
                                      ? messages[index]['item_id']
                                      : -1,
                                  itemBrand: (messages[index].data()! as Map).containsKey('item_brand')
                                      ? messages[index]['item_brand']
                                      : "",
                                  itemQuantity: (messages[index].data()! as Map).containsKey('item_quantity')
                                      ? messages[index]['item_quantity']
                                      : 0,
                                  itemSize: (messages[index].data()! as Map).containsKey('item_size')
                                      ? messages[index]['item_size']
                                      : "",
                                  products: (messages[index].data()! as Map).containsKey('products') ? messages[index]['products'] : null,
                                  instructions: (messages[index].data()! as Map).containsKey('instructions') ? messages[index]['instructions'] : null,
                                  ingredients: (messages[index].data()! as Map).containsKey('ingredients') ? messages[index]['ingredients'] : null,
                                  recipeName: (messages[index].data()! as Map).containsKey('recipe_name') ? messages[index]['recipe_name'] : null,
                                  itemName: messages[index]['item_name'],
                                  itemPrice: messages[index]['item_price'],
                                  itemOldPrice: messages[index]['item_oldPrice'],
                                  itemImage: messages[index]['item_image'],
                                  storeName: messages[index]['store_name'] ?? "",
                                  isMe: messages[index]['userId'] == FirebaseAuth.instance.currentUser!.uid,
                                  message: messages[index]['message'],
                                  messageDocPath: messages[index].reference,
                                  userName: messages[index]['username'],
                                  userId: messages[index]['userId'],
                                  userImage: messages[index]['userImageURL'],
                                  key: ValueKey(messages[index].id),
                                  isAddedToList: messages[index]['isAddedToList'],
                                ),
                              );
                          }),
                    ),
              // Spacer(),
              if (isBotLoading)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      bee1,
                      width: 30,
                      height: 30,
                    ),
                    Container(
                      // width: message.length > 30 ? MediaQuery.of(context).size.width * 0.6 : null,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(18),
                            topLeft: const Radius.circular(18),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(18),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x263463ED),
                              blurRadius: 28,
                              offset: Offset(0, 10),
                              spreadRadius: 0,
                            )
                          ]),
                      child: Image.asset(
                        loadingIndicator,
                        width: 30,
                      ),
                    ),
                  ],
                ),
              Showcase.withWidget(
                height: 120,
                width: 200.w,
                disableDefaultTargetGestures: true,
                targetBorderRadius: BorderRadius.circular(10),
                key:
                    tutorialProvider.isTutorialRunning ? TooltipKeys.showCase6 : new GlobalKey<State<StatefulWidget>>(),
                tooltipPosition: TooltipPosition.top,
                container: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: 300.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: purple70,
                        ),
                        child: Column(children: [
                          Text(
                            "Let's activate your AI sidekick! Invite friends and family to chat with your BargainB sidekick. Type @BB or @bargainb to ask questions, get personalized advice, and find the best deals. Type @BB Show me the Top Deal from"
                                    .tr() +
                                "${userProvider.onboardingStore}",
                            // maxLines: 4,
                            style: TextStyles.textViewRegular13.copyWith(color: white),
                          ),
                        ]),
                      ),
                      Container(
                        height: 11,
                        width: 13,
                        child: CustomPaint(
                          painter: DownTrianglePainter(
                            strokeColor: purple70,
                            strokeWidth: 1,
                            paintingStyle: PaintingStyle.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: GenericField(
                          controller: messageController,
                          hintText: "How can I help you?".tr(),
                          hintStyle: TextStylesInter.textViewRegular14.copyWith(color: hintText),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffEBEBEB)
                            )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffEBEBEB)
                            )
                          ),
                          borderRaduis: 99999,
                          onSubmitted: (_) async {
                            ShowCaseWidget.of(showcaseContext).dismiss();
                            await submitMessage(context);
                            finishTutorial(tutorialProvider, showcaseContext);
                          },
                        ),
                      ),
                      5.pw,
                      ElevatedButton(
                        onPressed: () async {
                          ShowCaseWidget.of(showcaseContext).dismiss();
                          await submitMessage(context);
                          finishTutorial(tutorialProvider, showcaseContext);
                        },
                        style: ElevatedButton.styleFrom(
                          // fixedSize: Size(32, 32),
                          minimumSize: Size(32, 32),
                          backgroundColor: primaryGreen
                        ),
                        child: Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> finishTutorial(TutorialProvider tutorialProvider, BuildContext showcaseContext) async {
    if (tutorialProvider.isTutorialRunning) {
      ShowCaseWidget.of(showcaseContext).dismiss();
      await Future.delayed(Duration(seconds: 1));
      tutorialProvider.stopTutorial(showcaseContext);
    }
  }

  Future<void> submitMessage(BuildContext context) async {
    var text = messageController.text.trim();
    var prompt = "@bb";
    if (['@BargainB', '@Bargainb', '@bargainb', '@bb', '@BB'].any((element) {
      prompt = element;
      return text.contains(element);
    })) {
      messageController.clear();
      await Provider.of<ChatlistsProvider>(context, listen: false)
          .sendMessage(text, widget.listId, widget.chatlistName, "messages");
      text = text.replaceFirst(prompt, "");
      setState(() {
        isBotLoading = true;
      });
      var response = await post(Uri.parse("https://bbagent-yswessi.pythonanywhere.com/query"), headers: {
        "Content-Type": "application/json"
      }, body: json.encode({
        "message": text
      },));
      Map botResponse = jsonDecode(response.body);
      log(botResponse.toString());
      log(widget.listId);
        var botMessage = botResponse['message'];
      if(botResponse['type'] == "BasicChat"){               //basic chat case
        var botMessageText = botMessage['text'];
      storeMessageInDB(botMessageText);
      } else if(botResponse['type'] == "ProductList"){      //products case
        var botMessageText = botMessage['text'];
        List botProducts = botMessage['products'];
      storeMessageInDB(botMessageText, products: botProducts);
      } else if(botResponse['type'] == "RecipeDetails"){    //recipe case
        var botMessageText = botMessage['content'];
        var botRecipe = botMessage['recipe'];
        var botRecipeIngredients = botRecipe['ingredients'];
        var botRecipeInstructions = botRecipe['instructions'];
        var botRecipeName = botRecipe['name'];
      storeMessageInDB(botMessageText, recipeName: botRecipeName, ingredients: botRecipeIngredients, instructions: botRecipeInstructions);
      }
      setState(() {
        isBotLoading = false;
      });
    } else {
      messageController.clear();
      FirebaseMessaging.instance.unsubscribeFromTopic(widget.listId);
      await Provider.of<ChatlistsProvider>(context, listen: false)
          .sendMessage(text, widget.listId, widget.chatlistName, "messages");
      Future.delayed(Duration(seconds: 5), () {
        FirebaseMessaging.instance.subscribeToTopic(widget.listId);
      });
    }
  }

  Future<void> storeMessageInDB(String response, {List? products, List? ingredients, List? instructions, String? recipeName}) async {
    await FirebaseFirestore.instance.collection('/lists/${widget.listId}/messages').add({
      'item_name': "",
      'item_image': "",
      'item_description': "",
      'store_name': "",
      'isAddedToList': false,
      'item_price': 0.0,
      'item_oldPrice': 0.0,
      'message': response,          // String
      'products': products,         //list
      'ingredients': ingredients,   //list
      'instructions': instructions,  //list
      'recipe_name': recipeName,      //String
      'createdAt': Timestamp.fromDate(DateTime.now().toUtc()),
      'userId': "bargainb",
      'username': "BargainB",
      'userImageURL': '',
    });
  }
}
