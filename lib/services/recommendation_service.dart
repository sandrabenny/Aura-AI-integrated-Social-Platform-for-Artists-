import 'dart:math' as math;


import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';

class RecommendationService {
  static Future<List<PostImageRecord>> getRecommendedArtworks() async {
    try {
      // Get recent artworks
      final artworksSnapshot = await FirebaseFirestore.instance
          .collection('post_image')
          .orderBy('time_posted', descending: true)
          .limit(20)
          .get();

      if (artworksSnapshot.docs.isEmpty) {
        return [];
      }

      // Get all bookings to calculate popularity
      final bookingsSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .get();

      // Create a map of artwork URL to booking count
      Map<String, int> bookingCounts = {};
      for (var doc in bookingsSnapshot.docs) {
        final postImage = doc.get('postimage') as String?;
        if (postImage != null) {
          bookingCounts[postImage] = (bookingCounts[postImage] ?? 0) + 1;
        }
      }

      // Calculate scores for each artwork
      List<MapEntry<DocumentSnapshot, double>> artworksWithScores = [];
      
      for (var artworkDoc in artworksSnapshot.docs) {
        final artData = artworkDoc.data();
        double score = 0.0;

        // Popularity score (60%)
        final postImage = artData['post_image'] as String?;
        if (postImage != null) {
          final bookingCount = bookingCounts[postImage] ?? 0;
          score += (math.min(bookingCount, 10) / 10.0) * 0.6;
        }

        // Recency score (40%)
        final timestamp = (artData['time_posted'] as Timestamp).toDate();
        final daysOld = DateTime.now().difference(timestamp).inDays;
        score += (math.max(0, 30 - daysOld) / 30.0) * 0.4;

        artworksWithScores.add(MapEntry(artworkDoc, score));
      }

      // Sort by final score
      artworksWithScores.sort((a, b) => b.value.compareTo(a.value));

      // Take top 3 recommendations
      return artworksWithScores
          .take(3)
          .map((entry) => PostImageRecord.fromSnapshot(entry.key))
          .toList();
    } catch (e) {
      print('Error getting recommendations: $e');
      return [];
    }
  }

  static Future<void> trackArtworkInteraction(
    String artworkId,
    String interactionType,
  ) async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid);

      final artwork = await FirebaseFirestore.instance
          .collection('post_image')
          .doc(artworkId)
          .get();

      if (!artwork.exists) return;

      await userRef.collection('interactions').add({
        'artwork_id': artworkId,
        'type': interactionType,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error tracking interaction: $e');
    }
  }
} 