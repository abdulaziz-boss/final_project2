class OpportunityModel {
  final int id;
  final String judul;
  final String deskripsi;
  final String lokasi;
  final String tipe;
  final String status;
  final String tanggalMulai;
  final int kuota;
  final String? mapsUrl;
  final String? foto;

  OpportunityModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.lokasi,
    required this.tipe,
    required this.status,
    required this.tanggalMulai,
    required this.kuota,
    this.mapsUrl,
    this.foto,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      id: json['id'],
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      lokasi: json['lokasi'] ?? '',
      tipe: json['tipe'] ?? 'offline',
      status: json['status'] ?? 'open',
      tanggalMulai: json['tanggal_mulai'] ?? '',
      kuota: json['kuota'] ?? 0,
      mapsUrl: json['maps_url'],
      foto: json['foto'],
    );
  }
}