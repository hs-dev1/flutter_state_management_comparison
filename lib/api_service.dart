import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<dynamic>> fetchAllProducts() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['products'];
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>> fetchProduct(int id) async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<dynamic>> fetchAllRecipes() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/recipes'));
    

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['recipes']; // Adjust based on the API response structure.
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
