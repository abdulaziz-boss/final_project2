import 'organization_model.dart';

class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? role;
  final bool isVerified;
  final String? googleId;
  final String? fotoProfil;
  final String? fotoProfilUrl;
  final String? bio;
  final String? lokasi;
  final int followersCount;
  final int followingsCount;
  final int? organizationId;
  final OrganizationModel? organization;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.role,
    required this.isVerified,
    this.googleId,
    this.fotoProfil,
    this.fotoProfilUrl,
    this.bio,
    this.lokasi,
    this.followersCount = 0,
    this.followingsCount = 0,
    this.organizationId,
    this.organization,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // 🔥 Amankan ID Utama User
      id: json['id'] is int 
          ? json['id'] 
          : (int.tryParse(json['id'].toString()) ?? 0),

      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      
      // Keamanan boolean status verifikasi
      isVerified: json['is_verified'] == 1 || 
                  json['is_verified'] == true || 
                  json['is_verified'].toString() == '1',

      googleId: json['google_id'],
      fotoProfil: json['foto_profil'],
      fotoProfilUrl: json['foto_profil_url'],
      bio: json['bio'],
      lokasi: json['lokasi'],
      
      // 🔥 Amankan data followers & followings count jika di DB berupa string
      followersCount: json['followers_count'] is int 
          ? json['followers_count'] 
          : (int.tryParse(json['followers_count'].toString()) ?? 0),

      followingsCount: json['followings_count'] is int 
          ? json['followings_count'] 
          : (int.tryParse(json['followings_count'].toString()) ?? 0),

      // 🔥 Amankan Foreign Key ID Organisasi (bisa bernilai null)
      organizationId: json['organization_id'] != null
          ? (json['organization_id'] is int 
              ? json['organization_id'] as int 
              : int.tryParse(json['organization_id'].toString()))
          : null,

      organization: json['organization'] != null
          ? OrganizationModel.fromJson(json['organization'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'role': role,
      'is_verified': isVerified,
      'google_id': googleId,
      'foto_profil': fotoProfil,
      'bio': bio,
      'lokasi': lokasi,
    };
  }
}