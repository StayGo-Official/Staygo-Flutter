import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromARGB(255, 102, 147, 244);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kSecondaryColor = Color(0xFF979797);

class AppConstants {
  static const secondary = Color.fromARGB(255, 104, 188, 247);
  static const primary = Color.fromARGB(255, 21, 201, 48);
  static const danger = Color.fromRGBO(227, 32, 32, 1);

  static const baseUrl = "https://api-staygo.tonexus.my.id";
  static const baseUrlImage = "https://api-staygo.tonexus.my.id/images/";
  static const baseUrlWeb = "https://staygo-com.preview-domain.com";
}

enum ServerStatus { normal, loading, error }
