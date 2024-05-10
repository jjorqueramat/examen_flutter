import 'dart:convert';
import 'package:exa_final_flutter/providers/supplier.dart';
import 'package:http/http.dart' as http;

class SupplierService {
  static const String baseUrl = 'http://143.198.118.203:8050/ejemplos/';
  static const String username = 'test';
  static const String password = 'test2023';

  Map<String, String> get authHeaders {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
  }

  Future<List<Supplier>> fetchSuppliers() async {
    final response = await http.get(Uri.parse(baseUrl + 'provider_list_rest/'),
        headers: authHeaders);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> supplierData = jsonData['Proveedores Listado'];
      List<Supplier> suppliers = supplierData
          .map((data) => Supplier(
                id: data['providerid'],
                name: data['provider_name'],
                lastName: data['provider_last_name'],
                email: data['provider_mail'],
                state: data['provider_state'],
              ))
          .toList();
      return suppliers;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<void> addSupplier({
    required String name,
    required String lastName,
    required String email,
    required String state,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'provider_add_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'provider_name': name,
        'provider_last_name': lastName,
        'provider_mail': email,
        'provider_state': state,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<void> editSupplier({
    required int supplierId,
    required String name,
    required String lastName,
    required String email,
    required String state,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'provider_edit_rest/'),
      headers: authHeaders,
      body: jsonEncode({
        'provider_id': supplierId,
        'provider_name': name,
        'provider_last_name': lastName,
        'provider_mail': email,
        'provider_state': state,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<void> deleteSupplier(int supplierId) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'provider_del_rest/'),
      headers: authHeaders,
      body: jsonEncode({'provider_id': supplierId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
