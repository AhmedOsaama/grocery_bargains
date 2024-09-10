import 'package:http/http.dart' as http;

class NetworkServices {

  static String stagingUrl = "https://staging.thebargainb.com/api";

  //"all" requests

  static Future<http.Response> getAllCategories() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_all_categories');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    return response;
  }

  //by id

  static Future<http.Response> getSimilarProducts(int id) async {
    final url = Uri.parse(
        '$stagingUrl/product/similar/$id');
    var response =
    await http.get(url, headers: {'Content-Type': 'application/json'});
    return response;
  }

  static Future<http.Response> getProductById(int id) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_new_products_by_id?id=$id');
    var response =
    await http.get(url, headers: {'Content-Type': 'application/json'});
    return response;
  }

  //"limited" requests


  static Future<http.Response> getLimitedProducts(int startingIndex,int limit) async {                  //starting index is the page number(i.e 1,2,3...)
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_limited_latest_products?startingIndex=$startingIndex&numberPerPage=$limit');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> getLimitedAlbertProductsByCategory(String category, int pageNumber) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/getLimitedAlbertCategoryProducts_new?startingIndex=$pageNumber&numberPerPage=100&category=$category');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> getLimitedAlbertProductsBySubCategory(String subCategory, int pageNumber) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/getLimitedAlbertSubCategoryProducts_new?startingIndex=$pageNumber&numberPerPage=100&subCategory=$subCategory');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }


}