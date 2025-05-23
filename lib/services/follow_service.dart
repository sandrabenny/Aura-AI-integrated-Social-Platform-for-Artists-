import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/notifications_record.dart';

class FollowService {
  static final _followsCollection = FirebaseFirestore.instance.collection('follows');
  static final _notificationsCollection = FirebaseFirestore.instance.collection('notifications');

  static Stream<List<String>> getFollowers(String userEmail) {
    return _followsCollection
        .where('following_email', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()['follower_email'] as String).toList());
  }

  static Stream<List<String>> getFollowing(String userEmail) {
    return _followsCollection
        .where('follower_email', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()['following_email'] as String).toList());
  }

  static Stream<int> getFollowersCount(String userEmail) {
    return _followsCollection
        .where('following_email', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Stream<int> getFollowingCount(String userEmail) {
    return _followsCollection
        .where('follower_email', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Stream<bool> isFollowing(String followerEmail, String followingEmail) {
    return _followsCollection
        .where('follower_email', isEqualTo: followerEmail)
        .where('following_email', isEqualTo: followingEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  static Future<void> followUser(String followerEmail, String followingEmail) async {
    // Create follow relationship
    await _followsCollection.add({
      'follower_email': followerEmail,
      'following_email': followingEmail,
      'created_time': DateTime.now(),
    });

    // Check if the target user is following the current user
    final isFollowBack = await isFollowing(followingEmail, followerEmail).first;

    // Create notification for the person being followed
    await _notificationsCollection.add({
      'type': isFollowBack ? 'follow_back' : 'follow',
      'from_user': followerEmail,
      'to_user': followingEmail,
      'created_time': DateTime.now(),
      'is_read': false,
    });

    // If this is a follow back, create a notification for the original follower too
    if (isFollowBack) {
      await _notificationsCollection.add({
        'type': 'followed_you_back',
        'from_user': followingEmail,
        'to_user': followerEmail,
        'created_time': DateTime.now(),
        'is_read': false,
      });
    }
  }

  static Future<void> unfollowUser(String followerEmail, String followingEmail) async {
    final followDocs = await _followsCollection
        .where('follower_email', isEqualTo: followerEmail)
        .where('following_email', isEqualTo: followingEmail)
        .get();

    for (var doc in followDocs.docs) {
      await doc.reference.delete();
    }
  }

  static Stream<List<NotificationsRecord>> getNotifications(String userId) {
    final tenHoursAgo = DateTime.now().subtract(const Duration(hours: 10));
    
    return _notificationsCollection
        .where('to_user', isEqualTo: userId)
        .where('created_time', isGreaterThan: tenHoursAgo)
        .orderBy('created_time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationsRecord.fromSnapshot(doc))
            .toList());
  }

  static Future<void> markNotificationAsRead(String notificationId) async {
    final notificationRef = _notificationsCollection.doc(notificationId);
    final notificationDoc = await notificationRef.get();
    
    if (!notificationDoc.exists) return;
    
    final readTime = DateTime.now();
    await notificationRef.update({
      'is_read': true,
      'read_time': readTime,
    });
    
    // Schedule deletion after 10 hours
    final deleteTime = readTime.add(const Duration(hours: 10));
    Future.delayed(const Duration(hours: 10), () async {
      try {
        final doc = await notificationRef.get();
        if (doc.exists) {
          await notificationRef.delete();
        }
      } catch (e) {
        print('Error deleting expired notification: $e');
      }
    });
  }

  static Future<void> cleanupExpiredNotifications() async {
    final tenHoursAgo = DateTime.now().subtract(const Duration(hours: 10));
    
    try {
      final expiredNotifications = await _notificationsCollection
          .where('is_read', isEqualTo: true)
          .where('read_time', isLessThan: tenHoursAgo)
          .get();
          
      for (var doc in expiredNotifications.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error cleaning up expired notifications: $e');
    }
  }
} 