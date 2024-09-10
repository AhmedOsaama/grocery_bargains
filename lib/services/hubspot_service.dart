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
        var contactId = jsonDecode(response.body)['id'];
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'isHubspotContact': true,
          "hubspot_contact_id": contactId
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

  static Future<void> updateHubspotContact(Map userData, String contactId) async {
    log("Updating hubspot contact");
    var contactData = jsonEncode({"properties": userData});
    try {
      var response = await patch(
        Uri.parse('https://api.hubapi.com/crm/v3/objects/contacts/$contactId'),
        headers: {
          'Authorization': 'Bearer pat-eu1-6afeefb9-6630-45c6-b31e-e292f251c251',
          'Content-Type': 'application/json'
        },
        body: contactData,
      ).catchError((e) {
        log("ERROR CREATING HUBSPOT CONTACT: $e");
      });
      if(response.statusCode == 201 || response.statusCode == 200 ) {
        log("DONE updating hubspot contact");
      }else{
        log("ERROR UPDATING HUBSPOT CONTACT: ${response.statusCode} ---> ${response.body}");
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Hubspot Contact")));
    } catch (e) {
      log(e.toString());
    }
  }

}