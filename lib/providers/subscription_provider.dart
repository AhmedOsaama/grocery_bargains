import 'package:bargainb/services/purchase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SubscriptionProvider with ChangeNotifier{
  bool isSubscribed = false;
  static SubscriptionProvider get(context) => Provider.of<SubscriptionProvider>(context, listen: false);

  Future<void> initSubscription() async {
    isSubscribed = await PurchaseApi.checkSubscriptionStatus();
    notifyListeners();
  }

  void changeSubscriptionStatus(bool subscriptionStatus){
    isSubscribed = subscriptionStatus;
    notifyListeners();
  }

}