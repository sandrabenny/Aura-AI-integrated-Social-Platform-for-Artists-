import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/backend/schema/notification_record.dart';
import '/notifications/notifications_page.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadNotifications();
  }

  Future<void> _loadUnreadNotifications() async {
    final user = currentUser;
    if (user == null || user.uid == null) return;

    final notifications = await NotificationRecord.collection
        .where('userId', isEqualTo: user.uid)
        .where('isRead', isEqualTo: false)
        .get();

    setState(() {
      _unreadNotifications = notifications.docs.length;
    });
  }

  Future<void> _startLiveAuction() async {
    final user = currentUser;
    if (user == null || user.uid == null) return;

    // Get all artists except the current user
    final artists = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'artist')
        .where('uid', isNotEqualTo: user.uid)
        .get();

    // Create notifications for all artists
    final batch = FirebaseFirestore.instance.batch();
    for (var artist in artists.docs) {
      final notificationRef = NotificationRecord.collection.doc();
      final notification = NotificationRecord(
        userId: artist.id,
        type: 'live_auction',
        title: 'Live Auction Started',
        message: '${user.displayName ?? 'An artist'} has started a live auction!',
        createdAt: DateTime.now(),
        isRead: false,
        data: {
          'auctionId': 'auction_${DateTime.now().millisecondsSinceEpoch}',
          'artistId': user.uid,
          'artistName': user.displayName,
        },
      );
      batch.set(notificationRef, notification.toMap());
    }
    await batch.commit();

    // Navigate to live auction page
    if (mounted) {
      Navigator.pushNamed(context, '/live-auction');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        title: Text(
          'Home',
          style: FlutterFlowTheme.of(context).titleMedium,
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Your existing homepage content here
            // ... (keep all your existing widgets)
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
            },
            backgroundColor: const Color(0xFFFFA500),
            child: const Icon(Icons.notifications),
          ),
          if (_unreadNotifications > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Text(
                  _unreadNotifications.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
} 