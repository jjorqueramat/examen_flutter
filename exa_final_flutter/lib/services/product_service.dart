import 'dart:convert';
import 'package:exa_final_flutter/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = 'http://143.198.118.203:8050/ejemplos/';
  static const String username = 'test';
  static const String password = 'test2023';

  Map<String, String> get authHeaders {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl + 'product_list_rest/'),
        headers: authHeaders);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)['Listado'];
      List<Product> products =
          jsonData.map((data) => Product.fromJson(data)).toList();
      return products;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'product_add_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'product_name': product.name,
        'product_price': product.price,
        'product_image': product.imageUrl
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'product_del_rest/'),
      headers: authHeaders,
      body: jsonEncode({'product_id': productId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<void> editProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'product_edit_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'product_id': product.id,
        'product_name': product.name,
        'product_price': product.price,
        'product_image': product.imageUrl,
        'product_state': product.state
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
