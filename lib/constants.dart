import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromARGB(255, 102, 147, 244);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kSecondaryColor = Color(0xFF979797);

class AppConstants {
  static const secondary = Color.fromARGB(255, 104, 188, 247);
  static const primary = Color.fromARGB(255, 21, 201, 48);
  static const danger = Color.fromRGBO(227, 32, 32, 1);

  static const baseUrl = "http://192.168.18.247:5000";
  static const baseUrlImage = "http://192.168.18.247:5000/images/";
  static const baseUrlWeb = "http://192.168.18.247:3000";
}

enum ServerStatus { normal, loading, error }
