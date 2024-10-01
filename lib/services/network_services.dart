import 'package:http/http.dart' as http;

class NetworkServices {

  static String stagingUrl = "https://staging.thebargainb.com/api";

  //by id

  static Future<http.Response> getSimilarProducts(int id) async {
    final url = Uri.parse(
        '$stagingUrl/product/similar/$id');
    var response =
    await http.get(url, headers: {'Content-Type': 'application/json'});
    return response;
  }

}