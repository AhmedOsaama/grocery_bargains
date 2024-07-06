import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AppTrackingUtils{
  static Future<void> showAppTrackingDialog() async {
    TrackingStatus appTrackingStatus = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (appTrackingStatus == TrackingStatus.notDetermined) {
      appTrackingStatus = await AppTrackingTransparency.requestTrackingAuthorization();
    }
    return;
  }
}