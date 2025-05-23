import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  static Future<void> sendLiveAuctionInvitations({
    required String auctionId,
    required String auctionTitle,
    required String auctionDescription,
    required DateTime auctionTime,
    required String artistId,
  }) async {
    try {
      // Get all users except the artist
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isNotEqualTo: artistId)
          .get();

      final batch = FirebaseFirestore.instance.batch();
      final notificationsRef = FirebaseFirestore.instance.collection('notifications');

      for (var userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final notificationRef = notificationsRef.doc();
        
        batch.set(notificationRef, {
          'user_id': userId,
          'type': 'live_invitation',
          'title': 'Live Auction Invitation',
          'message': 'You have been invited to join a live auction!',
          'is_read': false,
          'created_at': FieldValue.serverTimestamp(),
          'auction_id': auctionId,
          'auction_title': auctionTitle,
          'auction_description': auctionDescription,
          'auction_time': Timestamp.fromDate(auctionTime),
        });
      }

      await batch.commit();
    } catch (e) {
      print('Error sending live auction invitations: $e');
      rethrow;
    }
  }

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.comment;
      case 'follow':
        return Icons.person_add;
      case 'live_auction':
        return Icons.live_tv;
      case 'challenge':
        return Icons.emoji_events;
      case 'booking':
        return Icons.shopping_cart;
      case 'live_invitation':
        return Icons.video_camera_front;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showLiveInvitationDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Stream Invitation'),
        content: Text(data['message'] ?? 'You have been invited to join a live stream'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Decline'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to live stream
              context.pushNamed('LiveStreamPage');
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    switch (notification['type']) {
      case 'live_auction':
        // Navigate to live auction
        context.pushNamed(
          'LiveAuctionPage',
          queryParameters: {
            'auctionId': notification['auction_id'],
            'isOwner': 'false',
            'postImage': notification['post_image'],
          },
        );
        break;
      case 'live_invitation':
        _showLiveInvitationDialog(notification);
        break;
      // ... handle other notification types ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: Text(
          'Notifications',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Plus Jakarta Sans',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 24.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        actions: [
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.done_all,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              // Mark all notifications as read
              final notifications = await FirebaseFirestore.instance
                  .collection('notifications')
                  .where('user_id', isEqualTo: currentUser?.uid)
                  .where('is_read', isEqualTo: false)
                  .get();

              final batch = FirebaseFirestore.instance.batch();
              for (var doc in notifications.docs) {
                batch.update(doc.reference, {'is_read': true});
              }
              await batch.commit();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('user_id', isEqualTo: currentUser?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No notifications',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final notification = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final notificationId = snapshot.data!.docs[index].id;
              final timestamp = (notification['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

              return InkWell(
                onTap: () async {
                  // Mark as read
                  await FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(notificationId)
                      .update({'is_read': true});

                  // Handle notification action
                  _handleNotificationAction(notification);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: notification['is_read'] == true
                        ? FlutterFlowTheme.of(context).primaryBackground
                        : FlutterFlowTheme.of(context).secondaryBackground,
                    border: Border(
                      bottom: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: notification['type'] == 'live_auction'
                              ? Colors.red
                              : FlutterFlowTheme.of(context).primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getNotificationIcon(notification['type']),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['title'] ?? '',
                              style: FlutterFlowTheme.of(context).titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification['message'] ?? '',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimestamp(timestamp),
                              style: FlutterFlowTheme.of(context).bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (notification['type'] == 'live_auction')
                        ElevatedButton(
                          onPressed: () => _handleNotificationAction(notification),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Join Live'),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 