import 'package:cloud_firestore/cloud_firestore.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/artist_rating_record.dart';

class ArtistRatingService {
  static const String collectionName = 'artist_rating_record';

  static Future<void> addRating({
    required String artistEmail,
    required double rating,
    required String reviewText,
    required String reviewerName,
    required String reviewerProfilePic,
    bool isUpdate = false,
  }) async {
    try {
      // If updating, first find and delete the existing review
      if (isUpdate) {
        final existingRating = await FirebaseFirestore.instance
            .collection(collectionName)
            .where('artist_email', isEqualTo: artistEmail)
            .where('reviewer_email', isEqualTo: currentUserEmail)
            .get();

        if (existingRating.docs.isNotEmpty) {
          await existingRating.docs.first.reference.update({
            'rating': rating,
            'review_text': reviewText,
            'reviewer_name': reviewerName,
            'reviewer_profile_pic': reviewerProfilePic,
            'updated_time': FieldValue.serverTimestamp(),
          });
          return;
        }
      }

      // If not updating or no existing review found, create new
      await FirebaseFirestore.instance.collection(collectionName).add({
        'artist_email': artistEmail,
        'rating': rating,
        'review_text': reviewText,
        'reviewer_email': currentUserEmail,
        'reviewer_name': reviewerName,
        'reviewer_profile_pic': reviewerProfilePic,
        'created_time': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding/updating rating: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getArtistRatingStats(String artistEmail) async {
    try {
      final ratingsSnapshot = await ArtistRatingRecord.collection
          .where('artist_email', isEqualTo: artistEmail)
          .get();

      if (ratingsSnapshot.docs.isEmpty) {
        return {
          'averageRating': 0.0,
          'totalRatings': 0,
          'ratings': <Map<String, dynamic>>[],
        };
      }

      double totalRating = 0;
      final List<Map<String, dynamic>> ratings = [];

      for (var doc in ratingsSnapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final rating = data['rating'];
        if (rating != null) {
          totalRating += (rating as num).toDouble();
        }
        ratings.add({
          'rating': rating ?? 0,
          'reviewText': data['review_text'] as String? ?? '',
          'reviewerName': data['reviewer_name'] as String? ?? '',
          'reviewerEmail': data['reviewer_email'] as String? ?? '',
          'reviewerProfilePic': data['reviewer_profile_pic'] as String? ?? '',
          'createdTime': data['created_time'] as Timestamp? ?? Timestamp.now(),
        });
      }

      return {
        'averageRating': totalRating / ratingsSnapshot.docs.length,
        'totalRatings': ratingsSnapshot.docs.length,
        'ratings': ratings,
      };
    } catch (e) {
      print('Error getting artist rating stats: $e');
      rethrow;
    }
  }

  static Stream<Map<String, dynamic>> getArtistRatingStatsStream(String artistEmail) {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('artist_email', isEqualTo: artistEmail)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return {
          'averageRating': 0.0,
          'totalRatings': 0,
          'ratings': <Map<String, dynamic>>[],
        };
      }

      double totalRating = 0;
      final List<Map<String, dynamic>> ratings = [];

      for (var doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data();
        final rating = data['rating'];
        if (rating != null) {
          totalRating += (rating as num).toDouble();
        }
        ratings.add({
          'rating': rating ?? 0,
          'reviewText': data['review_text'] as String? ?? '',
          'reviewerName': data['reviewer_name'] as String? ?? '',
          'reviewerEmail': data['reviewer_email'] as String? ?? '',
          'reviewerProfilePic': data['reviewer_profile_pic'] as String? ?? '',
          'createdTime': data['created_time'] ?? data['updated_time'] ?? Timestamp.now(),
        });
      }

      return {
        'averageRating': totalRating / snapshot.docs.length,
        'totalRatings': snapshot.docs.length,
        'ratings': ratings,
      };
    });
  }

  static Future<void> deleteRating({
    required String artistEmail,
    required String reviewerEmail,
  }) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('artist_email', isEqualTo: artistEmail)
          .where('reviewer_email', isEqualTo: reviewerEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
      }
    } catch (e) {
      print('Error deleting rating: $e');
      rethrow;
    }
  }
} 