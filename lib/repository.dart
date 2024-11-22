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