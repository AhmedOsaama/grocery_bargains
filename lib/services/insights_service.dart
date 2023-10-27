import 'package:http/http.dart' as http;
class InsightsServices{
  static Future<http.Response> getBasicInsights(String userId, DateTime startDate, DateTime endDate, String mode) async {
    final url = Uri.parse(
        'https://us-central1-discountly.cloudfunctions.net/getPurchaseRecord?userId=$userId&startDate=$startDate&endDate=$endDate&mode=$mode');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }
}