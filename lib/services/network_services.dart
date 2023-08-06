import 'package:http/http.dart' as http;

class NetworkServices {

  //"all" requests

  static Future<http.Response> getAllAlbertProducts() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_all_albert_products');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json'});
    return response;
  }

  static Future<http.Response> getAllJumboProducts() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_all_jumbo_products');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    return response;
  }
  static Future<http.Response> getAllHoogvlietProducts() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_all_hoogvliet_products');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    return response;
  }

  static Future<http.Response> getAllCategories() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_all_categories');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    return response;
  }


  static Future<http.Response> getSimilarProducts(String gtin) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_products_by_gtin?gtin=$gtin');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    return response;
  }


  //"limited" requests


  static Future<http.Response> getLimitedProducts(int startingIndex) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_limited_new_products?startingIndex=$startingIndex');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> getLimitedAlbertProductsByCategory(String category) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/getLimitedAlbertCategoryProducts?category=$category');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> getLimitedAlbertProductsBySubCategory(String subCategory) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/getLimitedAlbertSubCategoryProducts?sub=$subCategory');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }


  //searches

  static Future<http.Response> searchAlbertProducts(String searchTerm) async {
    final url = Uri.parse(
        'https://us-central1-discountly.cloudfunctions.net/test_get_all_products_new?tableName=products&searchIndex=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> searchJumboProducts(String searchTerm) async {
    final url = Uri.parse(
        'https://us-central1-discountly.cloudfunctions.net/test_get_all_products_new?tableName=jumbo&searchIndex=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> searchHoogvlietProducts(String searchTerm) async {
    final url = Uri.parse(
        'https://us-central1-discountly.cloudfunctions.net/test_get_all_products_new?tableName=hoogvliet&searchIndex=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }


  static Future<http.Response> getSearchSuggestions(String searchTerm, String tableName) async {
    final url = Uri.parse(
      'https://us-central1-discountly.cloudfunctions.net/test_search_list?tableName=$tableName&searchIndex=$searchTerm'
    );
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }


}