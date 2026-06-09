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
  final int likesCount;
  final int commentsCount;


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
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      // 🔥 Amankan ID Utama (Wajib int, jika string kita parse otomatis)
      id: json['id'] is int 
          ? json['id'] 
          : (int.tryParse(json['id'].toString()) ?? 0),

      // 🔥 Amankan Foreign Keys (Bisa bernilai null)
      organizationId: json['organization_id'] != null
          ? (json['organization_id'] is int 
              ? json['organization_id'] as int 
              : int.tryParse(json['organization_id'].toString()))
          : null,
          
      createdBy: json['created_by'] != null
          ? (json['created_by'] is int 
              ? json['created_by'] as int 
              : int.tryParse(json['created_by'].toString()))
          : null,

      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      lokasi: json['lokasi'] ?? '',

      tipe: json['tipe'] ?? 'offline',
      status: json['status'] ?? 'open',

      tanggalMulai: json['tanggal_mulai'] ?? '',
      tanggalSelesai: json['tanggal_selesai'],

      // handle string → int (Sudah benar bawaanmu)
      kuota: int.tryParse(json['kuota'].toString()) ?? 0,

      mapsUrl: json['maps_url'],
      foto: json['foto'],

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,

      // creator = user
      creator: json['creator'] != null
          ? UserModel.fromJson(json['creator'])
          : null,
          
      organization: json['organization'] != null
          ? OrganizationModel.fromJson(json['organization'])
          : null,
          
      // 🔥 Amankan juga Likes & Comments count jika di DB tipenya string
      likesCount: json['likes_count'] is int 
          ? json['likes_count'] 
          : (int.tryParse(json['likes_count'].toString()) ?? 0),
          
      commentsCount: json['comments_count'] is int 
          ? json['comments_count'] 
          : (int.tryParse(json['comments_count'].toString()) ?? 0),
    );
  }
}