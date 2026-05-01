import 'user_model.dart';
import 'organization_model.dart';

class OpportunityModel {
  final int id;
  final int? organizationId;
  final int? createdBy;

  final String judul;
  final String deskripsi;
  final String lokasi;

  final String tipe;
  final String status;

  final String tanggalMulai;
  final String? tanggalSelesai;

  final int kuota;

  final String? mapsUrl;
  final String? foto;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final UserModel? creator;
  final OrganizationModel? organization;

  OpportunityModel({
    required this.id,
    this.organizationId,
    this.createdBy,
    required this.judul,
    required this.deskripsi,
    required this.lokasi,
    required this.tipe,
    required this.status,
    required this.tanggalMulai,
    this.tanggalSelesai,
    required this.kuota,
    this.mapsUrl,
    this.foto,
    this.createdAt,
    this.updatedAt,
    this.creator,
    this.organization,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      id: json['id'],

      organizationId: json['organization_id'],
      createdBy: json['created_by'],

      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      lokasi: json['lokasi'] ?? '',

      tipe: json['tipe'] ?? 'offline',
      status: json['status'] ?? 'open',

      tanggalMulai: json['tanggal_mulai'] ?? '',
      tanggalSelesai: json['tanggal_selesai'],

      // 🔥 handle string → int
      kuota: int.tryParse(json['kuota'].toString()) ?? 0,

      mapsUrl: json['maps_url'],
      foto: json['foto'],

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,

      // 🔥 creator = user
      creator: json['creator'] != null
          ? UserModel.fromJson(json['creator'])
          : null,
      organization: json['organization'] != null
          ? OrganizationModel.fromJson(json['organization'])
          : null,
    );
  }
}