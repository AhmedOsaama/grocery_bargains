import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkServices {
 static Future<http.Response> getAllProducts() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/function-1');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json'});
    final responseBody = response.body;
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
}