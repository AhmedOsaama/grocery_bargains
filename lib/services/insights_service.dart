import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
class InsightsServices{
  static Future<http.Response> getBasicInsights(String userId, DateTime startDate, DateTime endDate, String mode) async {
    var startDateStr = DateFormat("yyyy-MM-dd").format(startDate);
    var endDateStr = DateFormat("yyyy-MM-dd").format(endDate);
    final url = Uri.parse(
        'https://us-central1-discountly.cloudfunctions.net/getPurchaseRecord?userId=$userId&startDate=$startDateStr&endDate=$endDateStr&mode=$mode');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> getTopInsights() async {
    final url = Uri.parse(
        'https://us-central1-discountly.cloudfunctions.net/getTopInsights');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }


}