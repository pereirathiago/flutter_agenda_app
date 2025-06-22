import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/comment.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final bool isCurrentUser;

  const CommentItem({
    super.key,
    required this.comment,
    required this.isCurrentUser
  });

  ImageProvider? _getProfileImage(String? imagePath) {
    if (imagePath == null) {
      return const AssetImage('assets/images/profile.png');
    } else if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        final bytes = file.readAsBytesSync();
        return MemoryImage(bytes);
      } else {
        return const AssetImage('assets/images/profile.png');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: _getProfileImage(comment.userAvatarUrl),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isCurrentUser
                            ? AppColors.primaryDegrade
                            : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              isCurrentUser
                                  ? AppColors.primary
                                  : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(comment.text),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year} às ${comment.createdAt.hour}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
