import 'package:flutter/material.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/follow_service.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({super.key});

  String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _getNotificationMessage(String type) {
    switch (type) {
      case 'follow':
        return ' started following you';
      case 'follow_back':
        return ' followed you back';
      case 'followed_you_back':
        return ' also followed you back';
      default:
        return ' interacted with your profile';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Notifications',
          style: FlutterFlowTheme.of(context).titleLarge,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<List<NotificationsRecord>>(
        stream: FollowService.getNotifications(currentUser?.email ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final notification = snapshot.data![index];
              return StreamBuilder<List<SignupRecord>>(
                stream: querySignupRecord(
                  queryBuilder: (query) =>
                      query.where('email', isEqualTo: notification.fromUser),
                  singleRecord: true,
                ),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
                    return const SizedBox();
                  }

                  final user = userSnapshot.data!.first;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilepic),
                    ),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: user.username,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: _getNotificationMessage(notification.type),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      getRelativeTime(notification.createdTime),
                      style: FlutterFlowTheme.of(context).labelSmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      // Mark as read
                      FollowService.markNotificationAsRead(notification.reference.id);
                      
                      // Navigate to user profile
                      Navigator.pushNamed(
                        context,
                        'myprofileuserpov',
                        arguments: {
                          'name': user.username,
                          'profilepic': user.profilepic,
                          'email': user.email,
                        },
                      );
                    },
                    tileColor: notification.isRead ? null : Colors.grey[100],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
} 