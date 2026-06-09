class OrganizationModel {
  final int id;
  final int userId;

  final String namaOrganisasi;

  final String? deskripsi;
  final String? alamat;
  final String? website;

  final String? logo;
  final String? fotoUrl;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final bool isVerified;

  OrganizationModel({
    required this.id,
    required this.userId,
    required this.namaOrganisasi,
    this.deskripsi,
    this.alamat,
    this.website,
    this.logo,
    this.fotoUrl,
    this.createdAt,
    this.updatedAt,
    this.isVerified = false,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      // 🔥 Amankan ID Utama Organisasi
      id: json['id'] is int 
          ? json['id'] 
          : (int.tryParse(json['id'].toString()) ?? 0),

      // 🔥 Amankan ID User pemilik organisasi
      userId: json['user_id'] is int 
          ? json['user_id'] 
          : (int.tryParse(json['user_id'].toString()) ?? 0),

      namaOrganisasi: json['nama_organisasi'] ?? '',
      deskripsi: json['deskripsi'],
      alamat: json['alamat'],
      website: json['website'],
      logo: json['logo'],
      fotoUrl: json['foto_url'],

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
          
      // Pengecekan status verifikasi sudah aman
      isVerified: json['is_verified'] == 1 || 
                  json['is_verified'] == true || 
                  json['is_verified'].toString() == '1',
    );
  }
}