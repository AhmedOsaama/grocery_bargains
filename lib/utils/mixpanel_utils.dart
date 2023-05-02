import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelUtils{
  Mixpanel mixpanel = Mixpanel('752b3abf782a7347499ccb3ebb504194');

  void trackSocialLogin({required String providerName}){
    mixpanel.track('social_login',properties: {
      "provider_name": providerName
    });
  }

  // void trackAppStart({required String providerName}){
  //   mixpanel.track('social_login',properties: {
  //     "provider_name": providerName
  //   });
  // }
  
  Future<void> createUser({required String userName,required String email,required String id}) async {
   var distinctId = await mixpanel.getDistinctId();
   print(distinctId);
    mixpanel.identify(distinctId);
    // mixpanel.alias("$email", distinctId);
   print(await mixpanel.getDistinctId());
    mixpanel.getPeople().set("\$name", "Hamed");
    mixpanel.getPeople().set("\$email", "hamed@gmail.com");
    // mixpanel.getPeople().set("Email", email);
  }

}