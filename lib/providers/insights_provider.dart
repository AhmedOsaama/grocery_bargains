import 'dart:convert';

import 'package:bargainb/models/insight.dart';
import 'package:bargainb/services/insights_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/top_insight.dart';

class InsightsProvider with ChangeNotifier{
  Future<Insight> getBasicInsights(String userId, DateTime startDate, DateTime endDate, String mode) async {
    print("start date: $startDate");
    print("end date: $endDate");
    print("mode: $mode");
    print("userId: $userId");
    try {
      var response = await InsightsServices.getBasicInsights(userId, startDate, endDate, mode);
      var json = jsonDecode(response.body);
      Insight insights = Insight.fromJson(json);
      return insights;
    }catch(e){
      print(e);
      return Future.value();
    }
  }

  Future<TopInsight> getTopInsights() async {
    try {
      var response = await InsightsServices.getTopInsights();
      var json = jsonDecode(response.body);
      TopInsight topInsights = TopInsight.fromJson(json);
      return topInsights;
    }catch(e){
      print(e);
      return Future.value();
    }
  }
}