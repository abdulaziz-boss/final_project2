class PostModel {
  final int id;
  final String caption;
  final String? imageUrl;
  final String? createdAt;

  // Relasi user
  final String? userName;
  final String? userAvatar;

  PostModel({
    required this.id,
    required this.caption,
    this.imageUrl,
    this.createdAt,
    this.userName,
    this.userAvatar,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      caption: json['caption'] ?? '',
      imageUrl: json['image_url'],
      createdAt: json['created_at'],

      userName: json['user']?['name'],
      userAvatar: json['user']?['foto_profil'],
    );
  }
}