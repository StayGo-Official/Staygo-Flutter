import 'dart:async';
import 'dart:convert';
import 'package:staygo/models.dart';
import 'package:staygo/constants.dart';
import 'package:http/http.dart' as http;

class RepositoryKost {

  final endpoint = AppConstants.baseUrl;

  Future <List<Kost>> getDataKost() async {
    try {
      final response = await http.get(Uri.parse(endpoint + '/kost'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Kost> kostList = responseData
            .map((json) => Kost.fromJson(json)).toList(); 

        return kostList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch data');
    }
  }

}

class RepositoryOjek {

  final endpoint = AppConstants.baseUrl;

  Future <List<Ojek>> getDataOjek() async {
    try {
      final response = await http.get(Uri.parse(endpoint + '/ojek'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Ojek> ojekList = responseData
            .map((json) => Ojek.fromJson(json)).toList(); 

        return ojekList;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch data');
    }
  }

}

class CustomerRepository {
  Future<LoginResponse> loginCustomer(String email, String password) async {
    final url = Uri.parse("${AppConstants.baseUrl}/login-customer");

    try {
      final body = jsonEncode({
        "email": email,
        "password": password,
      });

      final headers = {
        "Content-Type": "application/json",
      };

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Respons sukses
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        // Respons error dengan status 400 (bad request) atau 404 (not found)
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return LoginResponse(
          status: false,
          message: responseData['msg'] ?? 'Unknown error',
        );
      } else {
        // Error lain
        return LoginResponse(
          status: false,
          message: "Server error: ${response.statusCode}",
        );
      }
    } catch (error) {
      return LoginResponse(
        status: false,
        message: "Error: ${error.toString()}",
      );
    }
  }

  // Fungsi logout customer
  Future<bool> logoutCustomer(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/logout-customer");

    try {
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['status'] == true;
      } else {
        return false; // Logout gagal
      }
    } catch (error) {
      print("Error during logout: $error");
      return false;
    }
  }
}