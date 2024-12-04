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
  String namaLengkap;
  String alamat;
  bool status;
  bool isRide;
  bool isFood;
  String gender;
  List<String> images;
  List<String> url;
  String createdAt;
  int id;
  bool isFavorite;

  Ojek({
    required this.nama,
    required this.namaLengkap,
    required this.alamat,
    required this.status,
    required this.isRide,
    required this.isFood,
    required this.gender,
    required this.images,
    required this.url,
    required this.createdAt,
    required this.id,
    required this.isFavorite,
  });

  factory Ojek.fromJson(Map<String, dynamic> json) {
    return Ojek(
      nama: json['nama'],
      namaLengkap: json['namaLengkap'],
      alamat: json['alamat'],
      status: json['status'],
      isRide: json['isRide'],
      isFood: json['isFood'],
      gender: json['gender'],
      images: List<String>.from(json['images']),
      url: List<String>.from(json['url']),
      createdAt: json['createdAt'],
      id: json['id'],
      isFavorite: json['isFavorite'],
    );
  }
}

// Model untuk User
class User {
  final int id;
  final String username;
  final String nama;
  final String email;
  final String noHp;
  final String alamat;
  final String ttl;
  final String password;
  bool isVerified;
  final String? image; // Filename of the image
  final String? url; // Full URL of the image
  final String refreshToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.alamat,
    required this.ttl,
    required this.password,
    required this.isVerified,
    required this.image,
    required this.url,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory for creating a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      nama: json['nama'],
      email: json['email'],
      noHp: json['noHp'],
      alamat: json['alamat'],
      ttl: json['ttl'],
      password: json['password'],
      isVerified: json['isVerified'],
      image: json['image'], // Extract the filename
      url: json['url'], // Extract the full URL
      refreshToken: json['refresh_token'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nama': nama,
      'email': email,
      'noHp': noHp,
      'alamat': alamat,
      'ttl': ttl,
      'password': password,
      'isVerified': isVerified,
      'image': image,
      'url': url,
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
      status: json['status'] ?? false,
      message: json['msg'] ?? json['message'] ?? 'Unknown error',
      user: json['data'] != null && json['data']['user'] != null
          ? User.fromJson(json['data']['user'])
          : null,
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

class CustomerRegistration {
  final String username;
  final String nama;
  final String email;
  final String noHp;
  final String alamat;
  final String ttl;
  final String password;
  final String confPassword;

  CustomerRegistration({
    required this.username,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.alamat,
    required this.ttl,
    required this.password,
    required this.confPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'nama': nama,
      'email': email,
      'noHp': noHp,
      'alamat': alamat,
      'ttl': ttl,
      'password': password,
      'confPassword': confPassword,
    };
  }
}

class DeleteFavoriteResponse {
  final bool status;
  final String message;

  DeleteFavoriteResponse({
    required this.status,
    required this.message,
  });

  factory DeleteFavoriteResponse.fromJson(Map<String, dynamic> json) {
    return DeleteFavoriteResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

class ResetPasswordResponse {
  final bool status;
  final String message;

  ResetPasswordResponse({
    required this.status,
    required this.message,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

class VerificationResponse {
  final bool status;
  final String message;

  VerificationResponse({
    required this.status,
    required this.message,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

class VerifyEmailResponse {
  final bool status;
  final String message;

  VerifyEmailResponse({
    required this.status,
    required this.message,
  });

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

class MidtransResponse {
  final bool status;
  final String message;
  final String token;
  final String redirect_url;

  MidtransResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.redirect_url,
  });

  factory MidtransResponse.fromJson(Map<String, dynamic> json) {
    return MidtransResponse(
      status: json['status'],
      message: json['message'], 
      token: json['token'],
      redirect_url: json['redirect_url'],
    );
  }
}