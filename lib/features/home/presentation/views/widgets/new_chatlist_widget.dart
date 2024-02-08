import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../config/routes/app_navigator.dart';
import '../../../../../providers/chatlists_provider.dart';
import '../../../../../utils/assets_manager.dart';

class NewChatlistWidget extends StatefulWidget {
  const NewChatlistWidget({Key? key}) : super(key: key);

  @override
  State<NewChatlistWidget> createState() => _NewChatlistWidgetState();
}

class _NewChatlistWidgetState extends State<NewChatlistWidget> {
  late Future<QuerySnapshot> getAllListsFuture;

  @override
  void initState() {
    getAllListsFuture = Provider.of<ChatlistsProvider>(context, listen: false).getAllChatlistsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllListsFuture,
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          var allLists = snapshot.data?.docs ?? [];
          if (!snapshot.hasData || allLists.isEmpty || FirebaseAuth.instance.currentUser == null) {
            return GestureDetector(
              onTap: () {
                AppNavigator.goToChatlistTab(context);
              },
              child: Image.asset(
                newChatList,
              ),
            );
          }
          return SizedBox();
        });
  }
}
