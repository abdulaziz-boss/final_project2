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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      isVerified: json['is_verified'] == 1 || json['is_verified'] == true,
      googleId: json['google_id'],
      fotoProfil: json['foto_profil'],
      fotoProfilUrl: json['foto_profil_url'],
      bio: json['bio'],
      lokasi: json['lokasi'],
      followersCount: json['followers_count'] ?? 0,
      followingsCount: json['followings_count'] ?? 0,
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