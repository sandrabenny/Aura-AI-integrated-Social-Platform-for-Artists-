import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/artist_rating_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:intl/intl.dart';
import '/components/rating_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArtistRatingsWidget extends StatelessWidget {
  final String artistEmail;

  const ArtistRatingsWidget({
    super.key,
    required this.artistEmail,
  });

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return '';
    if (timestamp is Timestamp) {
      return DateFormat('MMM d, yyyy').format(timestamp.toDate());
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: ArtistRatingService.getArtistRatingStatsStream(artistEmail),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final stats = snapshot.data ?? {};
        final double averageRating = stats['averageRating'] ?? 0.0;
        final int totalRatings = stats['totalRatings'] ?? 0;
        final List<Map<String, dynamic>> ratings = List<Map<String, dynamic>>.from(stats['ratings'] ?? []);

        if (totalRatings == 0) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No ratings yet',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Rating Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Overall Rating',
                          style: FlutterFlowTheme.of(context).titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 24),
                            const SizedBox(width: 4),
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: FlutterFlowTheme.of(context).headlineMedium,
                            ),
                          ],
                        ),
                        Text(
                          '$totalRatings ${totalRatings == 1 ? 'Review' : 'Reviews'}',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Reviews',
                style: FlutterFlowTheme.of(context).titleMedium,
              ),
              const SizedBox(height: 8),
              // Reviews List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ratings.length,
                itemBuilder: (context, index) {
                  final review = ratings[index];
                  final isCurrentUserReview = review['reviewerEmail'] == currentUserEmail;
                  final reviewDate = _formatDate(review['createdTime']);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(review['reviewerProfilePic'] ?? ''),
                              radius: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['reviewerName'] ?? '',
                                    style: FlutterFlowTheme.of(context).titleSmall,
                                  ),
                                  Text(
                                    reviewDate,
                                    style: FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            if (isCurrentUserReview)
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    // Show edit dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) => RatingDialog(
                                        artistEmail: artistEmail,
                                        reviewerName: review['reviewerName'],
                                        reviewerProfilePic: review['reviewerProfilePic'],
                                        initialRating: review['rating'].toDouble(),
                                        initialReview: review['reviewText'],
                                        isEditing: true,
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    // Show confirmation dialog
                                    final shouldDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Review'),
                                        content: const Text('Are you sure you want to delete your review?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (shouldDelete == true) {
                                      await ArtistRatingService.deleteRating(
                                        artistEmail: artistEmail,
                                        reviewerEmail: currentUserEmail,
                                      );
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              size: 20,
                              color: index < (review['rating'] ?? 0)
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          review['reviewText'] ?? '',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
} 