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
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'],
      userId: json['user_id'],

      namaOrganisasi: json['nama_organisasi'] ?? '',

      deskripsi: json['deskripsi'],
      alamat: json['alamat'],
      website: json['website'],

      logo: json['logo'],
      fotoUrl: json['foto_url'],

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}