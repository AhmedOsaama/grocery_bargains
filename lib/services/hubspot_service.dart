import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

class HubspotService{
  static Future<void> createHubspotContact(Map userData) async {
    log("Creating hubspot contact");
    var contactData = jsonEncode({"properties": userData});
    try {
      var response = await post(
        Uri.parse('https://api.hubapi.com/crm/v3/objects/contacts'),
        headers: {
          'Authorization': 'Bearer pat-eu1-6afeefb9-6630-45c6-b31e-e292f251c251',
          'Content-Type': 'application/json'
        },
        body: contactData,
      ).catchError((e) {
        log("ERROR CREATING HUBSPOT CONTACT: $e");
      });
      if(response.statusCode == 201) {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'isHubspotContact': true,
        });
        log("DONE creating hubspot contact");
      }else{
        log("ERROR CREATING HUBSPOT CONTACT: ${response.statusCode} ---> ${response.body}");
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Hubspot Contact")));
    } catch (e) {
      log(e.toString());
    }
  }

}