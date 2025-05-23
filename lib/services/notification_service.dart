import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/backend.dart';

class NotificationService {
  static Future<void> notifyFollowersOfLiveAuction({
    required String artistId,
    required String artistName,
    required String postId,
    required String postTitle,
    required String postImage,
    required String auctionId,
  }) async {
    try {
      print('Sending live auction notifications to followers');
      print('Artist ID: $artistId');
      print('Auction ID: $auctionId');

      // Get all followers of the artist
      final followersSnapshot = await FirebaseFirestore.instance
          .collection('follows')
          .where('following_id', isEqualTo: artistId)
          .get();

      print('Found ${followersSnapshot.docs.length} followers');

      // Create notifications for each follower
      final batch = FirebaseFirestore.instance.batch();
      
      for (var doc in followersSnapshot.docs) {
        final followerId = doc.data()['follower_id'] as String;
        final notificationRef = FirebaseFirestore.instance.collection('notifications').doc();
        
        print('Creating notification for follower: $followerId');
        
        batch.set(notificationRef, {
          'user_id': followerId,
          'type': 'live_auction',
          'title': '$artistName started a live auction!',
          'message': 'Join the live auction for "$postTitle"',
          'post_id': postId,
          'post_image': postImage,
          'auction_id': auctionId,
          'artist_id': artistId,
          'artist_name': artistName,
          'timestamp': FieldValue.serverTimestamp(),
          'is_read': false,
        });
      }

      await batch.commit();
      print('Successfully sent notifications to all followers');
    } catch (e) {
      print('Error notifying followers: $e');
      rethrow;
    }
  }

  static Stream<QuerySnapshot> getUnreadNotifications(String userId) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('user_id', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  static Future<void> markNotificationAsRead(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .update({'is_read': true});
  }

  static Future<void> deleteNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
} 