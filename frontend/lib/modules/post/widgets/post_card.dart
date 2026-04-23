import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel data;

  const PostCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String imageUrl = data.imageUrl ?? '';
    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      imageUrl = 'http://192.168.43.73:8000/storage/$imageUrl';
    }

    String avatar = data.userAvatar ?? '';
    if (avatar.isNotEmpty && !avatar.startsWith('http')) {
      avatar = 'http://192.168.43.73:8000/storage/$avatar';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // HEADER
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: avatar.isNotEmpty
                      ? NetworkImage(avatar)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  data.userName ?? 'User',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // IMAGE
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

          // ACTIONS
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.favorite_border),
                SizedBox(width: 12),
                Icon(Icons.chat_bubble_outline),
              ],
            ),
          ),

          // CAPTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${data.userName ?? 'User'} ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: data.caption),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}