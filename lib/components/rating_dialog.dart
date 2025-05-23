import 'package:flutter/material.dart';

import '/services/artist_rating_service.dart';

class RatingDialog extends StatefulWidget {
  final String artistEmail;
  final String reviewerName;
  final String reviewerProfilePic;
  final double? initialRating;
  final String? initialReview;
  final bool isEditing;

  const RatingDialog({
    super.key,
    required this.artistEmail,
    required this.reviewerName,
    required this.reviewerProfilePic,
    this.initialRating,
    this.initialReview,
    this.isEditing = false,
  });

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late double _rating;
  late TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 0;
    _reviewController = TextEditingController(text: widget.initialReview ?? '');
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Review' : 'Rate Artist'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _rating ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _rating == 0
              ? null
              : () async {
                  try {
                    await ArtistRatingService.addRating(
                      artistEmail: widget.artistEmail,
                      rating: _rating,
                      reviewText: _reviewController.text.trim(),
                      reviewerName: widget.reviewerName,
                      reviewerProfilePic: widget.reviewerProfilePic,
                      isUpdate: widget.isEditing,
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error submitting review. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
          child: Text(widget.isEditing ? 'Update' : 'Submit'),
        ),
      ],
    );
  }
} 