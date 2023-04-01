import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkServices {
 static Future<http.Response> getAllAlbertProducts() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/function-1');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json'});
    // var decodedResponse = jsonDecode(responseBody);
    // print('SQL Response: $decodedResponse');
    // print('SQL status: ${response.statusCode}');
    // print(
    //     "SQL Error Result: ${decodedResponse['code']}, ${decodedResponse['sqlMessage']}");
    // if(decodedResponse['code'] != null || decodedResponse['sqlMessage'] != null){
    //   // Sentry.captureMessage("SQL Error Result: ${decodedResponse['code']}, ${decodedResponse['sqlMessage']} \n\n  SQL Response: $decodedResponse");
    // }
    // if(response.statusCode != 200){
    //   return response.statusCode;
    // }
    return response;
  }
  static Future<http.Response> getAllJumboProducts() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_all_products_JUMBO');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json'});
    return response;
  }

 static Future<http.Response> getAllPriceComparisons() async {
   final url = Uri.parse(
       'https://europe-west1-discountly.cloudfunctions.net/get_all_price_comparisons');
   var response = await http.get(
       url, headers: {'Content-Type': 'application/json'});
   return response;
 }








  static Future<http.Response> getProducts(int startingIndex) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/function-2?startingIndex=$startingIndex');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> searchAlbertProducts(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/function-3?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> searchJumboProducts(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_jumbo?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }


}