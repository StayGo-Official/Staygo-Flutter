import 'dart:convert';

class Kost {
  String namaKost;
  String alamat;
  int hargaPerbulan;
  int hargaPertahun;
  int tersedia;
  String gender;
  List<String> fasilitas;
  String deskripsi;
  double latitude;
  double longitude;
  List<String> images;
  List<String> url;
  String createdAt;
  String updatedAt;
  int id;

  Kost ({
    required this.namaKost,
    required this.alamat,
    required this.hargaPerbulan,
    required this.hargaPertahun,
    required this.tersedia,
    required this.gender,
    required this.fasilitas,
    required this.deskripsi,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory Kost.fromJson(Map<String, dynamic> json) {
    return Kost(
      namaKost: json['namaKost'],
      alamat: json['alamat'],
      hargaPerbulan: json['hargaPerbulan'],
      hargaPertahun: json['hargaPertahun'],
      tersedia: json['tersedia'],
      gender: json['gender'],
      fasilitas: List<String>.from(json['fasilitas']),
      deskripsi: json['deskripsi'],
      latitude: (json['latitude'] as num).toDouble(), // Konversi ke double
      longitude: (json['longitude'] as num).toDouble(), // Konversi ke double
      images: List<String>.from(json['images']),
      url: List<String>.from(json['url']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      id: json['id'],
    );
  }
}

class Ojek {
  String nama;
  String alamat;
  bool status;
  String gender;
  List<String> images;
  List<String> url;
  String createdAt;
  int id;

  Ojek({
    required this.nama,
    required this.alamat,
    required this.status,
    required this.gender,
    required this.images,
    required this.url,
    required this.createdAt,
    required this.id,
  });

  factory Ojek.fromJson(Map<String, dynamic> json) {
    return Ojek(
      nama: json['nama'],
      alamat: json['alamat'],
      status: json['status'],
      gender: json['gender'],
      images: List<String>.from(json['images']),
      url: List<String>.from(json['url']),
      createdAt: json['createdAt'],
      id: json['id'],
    );
  }
}


// Model untuk User
class User {
  final int id;
  final String username;
  final String email;
  final String noHp;
  final String alamat;
  final String password;
  final String refreshToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.noHp,
    required this.alamat,
    required this.password,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory untuk membuat User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      noHp: json['noHp'],
      alamat: json['alamat'],
      password: json['password'],
      refreshToken: json['refresh_token'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Konversi User ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'noHp': noHp,
      'alamat': alamat,
      'password': password,
      'refresh_token': refreshToken,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// Model untuk Response Login
class LoginResponse {
  final bool status;
  final String message;
  final User? user;
  final String? accessToken;

  LoginResponse({
    required this.status,
    required this.message,
    this.user,
    this.accessToken,
  });

  // Factory untuk membuat LoginResponse dari JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      user: json['data'] != null ? User.fromJson(json['data']['user']) : null,
      accessToken: json['data']?['accessToken'],
    );
  }

  // Konversi LoginResponse ke JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': {
        'user': user?.toJson(),
        'accessToken': accessToken,
      },
    };
  }
}
