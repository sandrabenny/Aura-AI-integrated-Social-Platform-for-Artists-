import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'social_interaction_widget.dart';

class PostWidget extends StatelessWidget {
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String imageUrl;
  final String description;
  final DateTime timestamp;

  const PostWidget({
    super.key,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.imageUrl,
    required this.description,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userAvatar),
            ),
            title: Text(
              userName,
              style: FlutterFlowTheme.of(context).titleMedium,
            ),
            subtitle: Text(
              _getTimeAgo(timestamp),
              style: FlutterFlowTheme.of(context).bodySmall,
            ),
          ),
          // Post Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Description
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                description,
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ),
          // Social Interactions
          SocialInteractionWidget(
            postId: postId,
            postImageUrl: imageUrl,
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
} 