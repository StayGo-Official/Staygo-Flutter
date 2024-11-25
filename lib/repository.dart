import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:staygo/models.dart';
import 'package:staygo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class RepositoryKost {
  final endpoint = AppConstants.baseUrl;

  Future<List<Kost>> getDataKost() async {
    try {
      final response = await http.get(Uri.parse(endpoint + '/kost'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Kost> kostList =
            responseData.map((json) => Kost.fromJson(json)).toList();

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

  Future<List<Ojek>> getDataOjek() async {
    try {
      final response = await http.get(Uri.parse(endpoint + '/ojek'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Ojek> ojekList =
            responseData.map((json) => Ojek.fromJson(json)).toList();

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

  Future<Map<String, dynamic>> registerCustomer(
      CustomerRegistration customer) async {
    final url = Uri.parse("${AppConstants.baseUrl}/register-customer");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(customer.toJson()),
      );

      if (response.statusCode == 200) {
        // Parse success response
        return jsonDecode(response.body);
      } else {
        // Handle errors
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['msg'] ?? 'Registration failed');
      }
    } catch (error) {
      throw Exception("Error during registration: $error");
    }
  }

  // Fungsi untuk update data profile customer
  Future<Map<String, dynamic>> updateCustomerProfile({
    required String accessToken,
    required int customerId,
    required Map<String, dynamic> profileData,
    File? imageFile,
  }) async {
    final url = Uri.parse("${AppConstants.baseUrl}/update-profile/$customerId");
    final request = http.MultipartRequest('PATCH', url);

    // Add Authorization header
    request.headers['Authorization'] = 'Bearer $accessToken';

    // Add profile data to request fields
    profileData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add the image file if present
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response body
        final responseBody = await response.stream.bytesToString();
        final responseJson = jsonDecode(responseBody);

        return {
          'status': responseJson['status'] ?? false,
          'message': responseJson['message'] ?? 'Update failed',
          'imagePath': responseJson['imagePath'], // Return the imagePath
        };
      } else {
        final responseBody = await response.stream.bytesToString();
        print("Error updating profile: $responseBody");
        return {
          'status': false,
          'message': 'Update failed',
          'imagePath': null,
        };
      }
    } catch (e) {
      print("Exception occurred: $e");
      return {
        'status': false,
        'message': 'Exception occurred',
        'imagePath': null,
      };
    }
  }
}

class FavoriteKostRepository {
  final endpoint = AppConstants.baseUrl;

  // Fetch Favorite Kost
  Future<List<dynamic>> fetchFavoriteKost(String accessToken) async {
    final url = Uri.parse('$endpoint/favorite-kost');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return the parsed JSON response
      } else {
        throw Exception('Failed to load favorite kost');
      }
    } catch (error) {
      print('Error fetching favorite kost: $error');
      throw Exception('Error fetching favorite kost');
    }
  }

  Future<Map<String, dynamic>> addFavorite({
    required String accessToken,
    required int kostId,
  }) async {
    final url = Uri.parse('$endpoint/favorite-kost');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'kostId': kostId}),
      );

      // Decode respons backend
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Return respons jika sukses
        return decodedResponse;
      } else {
        // Jika gagal, kembalikan respons backend dengan status false
        return {
          'status': false,
          'message': decodedResponse['message'] ?? 'Gagal menambahkan favorit',
        };
      }
    } catch (error) {
      // Tangani error lain
      throw Exception('Error adding favorite: $error');
    }
  }

  Future<Map<String, dynamic>> checkIfFavorite({
    required String accessToken,
    required int kostId,
  }) async {
    final url = Uri.parse(
        '$endpoint/favorite-kost/check/$kostId'); // Pastikan endpoint sesuai dengan backend

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Parsing respons backend
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Jika respons berhasil
        return decodedResponse;
      } else {
        // Jika gagal, return status false
        return {
          'status': false,
          'message':
              decodedResponse['message'] ?? 'Gagal memeriksa status favorit',
        };
      }
    } catch (error) {
      // Tangani error lain
      throw Exception('Error checking favorite status: $error');
    }
  }

  Future<Map<String, dynamic>> deleteFavorite({
    required String accessToken,
    required int favoriteId,
  }) async {
    final url = Uri.parse('$endpoint/favorite-kost/$favoriteId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to delete favorite');
      }
    } catch (error) {
      throw Exception('Error deleting favorite: $error');
    }
  }
  
}
