import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class NetworkServices {

  //"all" requests

  static Future<http.Response> getAllAlbertProducts() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/function-1');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json'});
    return response;
  }

  static Future<http.Response> getAllJumboProducts() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_all_products_JUMBO');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    return response;
  }
  static Future<http.Response> getAllHoogvlietProducts() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_all_products_hoogvliet');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    return response;
  }

  static Future<http.Response> getAllAlbertCategories() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_all_albert_categories');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    return response;
  }

  static Future<http.Response> getAllPriceComparisons() async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/get_all_price_comparisons');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    return response;
  }


  //"limited" requests

  static Future<http.Response> getProducts(int startingIndex) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/function-2?startingIndex=$startingIndex');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> getLimitedPriceComparisons(int startingIndex) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/getLimitedPriceComparisons?startingIndex=$startingIndex');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  //searches

  static Future<http.Response> searchComparisonByAlbertLink(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_comparison_by_albert_link?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> searchComparisonByJumboLink(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_comparison_by_jumbo_link?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> searchComparisonByHoogvlietLink(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_comparison_by_hoogvliet_link?search=$searchTerm');
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

  static Future<http.Response> searchHoogvlietProducts(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_hoogvliet?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  //searches by link

  static Future<http.Response> searchAlbertProductByLink(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_albert_by_link?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }


  static Future<http.Response> searchJumboProductByLink(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_jumbo_by_link?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> searchHoogvlietProductByLink(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_hoogvliet_by_link?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  //by name
  static Future<http.Response> searchAlbertProductByName(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_albert_by_name?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> searchJumboProductByName(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_jumbo_by_name?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }

  static Future<http.Response> searchHoogvlietProductByName(String searchTerm) async {
    final url = Uri.parse(
        'https://europe-west1-discountly.cloudfunctions.net/search_hoogvliet_by_name?search=$searchTerm');
    var response = await http.get(
        url, headers: {'Content-Type': 'application/json',});
    return response;
  }


}