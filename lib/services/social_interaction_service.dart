import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/firebase_auth/auth_util.dart';
import '../backend/schema/social_interaction_record.dart';

class SocialInteractionService {
  final _firestore = FirebaseFirestore.instance;

  // Like a post
  Future<bool> toggleLike(String postId) async {
    final currentUser = currentUserReference;
    if (currentUser == null) return false;

    final likeDoc = await _firestore
        .collection('social_interactions')
        .where('post_id', isEqualTo: postId)
        .where('user_id', isEqualTo: currentUser.id)
        .where('type', isEqualTo: 'like')
        .get();

    if (likeDoc.docs.isEmpty) {
      // Add like
      final interaction = SocialInteractionRecord(
        id: '',
        postId: postId,
        userId: currentUser.id,
        type: 'like',
        timestamp: DateTime.now(),
      );
      await _firestore.collection('social_interactions').add(interaction.toMap());
      return true;
    } else {
      // Remove like
      await _firestore.collection('social_interactions').doc(likeDoc.docs.first.id).delete();
      return false;
    }
  }

  // Add a comment
  Future<void> addComment(String postId, String commentText) async {
    final currentUser = currentUserReference;
    if (currentUser == null) return;

    final interaction = SocialInteractionRecord(
      id: '',
      postId: postId,
      userId: currentUser.id,
      type: 'comment',
      commentText: commentText,
      timestamp: DateTime.now(),
    );

    await _firestore.collection('social_interactions').add(interaction.toMap());
  }

  // Share a post
  Future<void> sharePost(String postId, String destination) async {
    final currentUser = currentUserReference;
    if (currentUser == null) return;

    final interaction = SocialInteractionRecord(
      id: '',
      postId: postId,
      userId: currentUser.id,
      type: 'share',
      shareDestination: destination,
      timestamp: DateTime.now(),
    );

    await _firestore.collection('social_interactions').add(interaction.toMap());
  }

  // Get likes for a post
  Stream<int> getLikeCount(String postId) {
    return _firestore
        .collection('social_interactions')
        .where('post_id', isEqualTo: postId)
        .where('type', isEqualTo: 'like')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Check if user liked a post
  Stream<bool> hasUserLiked(String postId) {
    final currentUser = currentUserReference;
    if (currentUser == null) return Stream.value(false);

    return _firestore
        .collection('social_interactions')
        .where('post_id', isEqualTo: postId)
        .where('user_id', isEqualTo: currentUser.id)
        .where('type', isEqualTo: 'like')
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  // Get comments for a post
  Stream<List<SocialInteractionRecord>> getComments(String postId) {
    return _firestore
        .collection('social_interactions')
        .where('post_id', isEqualTo: postId)
        .where('type', isEqualTo: 'comment')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => SocialInteractionRecord.fromSnapshot(doc)).toList());
  }

  // Get share count for a post
  Stream<int> getShareCount(String postId) {
    return _firestore
        .collection('social_interactions')
        .where('post_id', isEqualTo: postId)
        .where('type', isEqualTo: 'share')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Delete a comment
  Future<void> deleteComment(String commentId) async {
    await _firestore.collection('social_interactions').doc(commentId).delete();
  }
} 