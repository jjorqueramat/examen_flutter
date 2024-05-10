import 'dart:convert';
import 'package:exa_final_flutter/providers/categorie.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  static const String baseUrl = 'http://143.198.118.203:8050/ejemplos/';
  static const String username = 'test';
  static const String password = 'test2023';

  Map<String, String> get authHeaders {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(baseUrl + 'category_list_rest/'),
        headers: authHeaders);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> categoryData = jsonData['Listado Categorias'];
      List<Category> categories = categoryData
          .map((data) => Category(
                id: data['category_id'],
                name: data['category_name'],
                state: data['category_state'],
              ))
          .toList();
      return categories;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<void> addCategory({required String name}) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'category_add_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'category_name': name,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'category_del_rest/'),
      headers: authHeaders,
      body: jsonEncode({'category_id': categoryId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<void> editCategory(
      {required int categoryId,
      required String name,
      required String state}) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'category_edit_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'category_id': categoryId,
        'category_name': name,
        'category_state': state,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
