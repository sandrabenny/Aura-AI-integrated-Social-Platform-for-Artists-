import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/backend/schema/badge_record.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class BadgeDisplay extends StatelessWidget {
  final String userId;

  const BadgeDisplay({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: BadgeRecord.collection
          .where('userId', isEqualTo: userId)
          .orderBy('earnedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final badges = snapshot.data!.docs
            .map((doc) => BadgeRecord.fromSnapshot(doc))
            .toList();

        if (badges.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 48,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                const SizedBox(height: 8),
                Text(
                  'No badges yet',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            return Tooltip(
              message: '${badge.type?.toUpperCase()} Badge - Level ${badge.challengeLevel}',
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      badge.imageUrl ?? '',
                      width: 48,
                      height: 48,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.emoji_events,
                          size: 48,
                          color: _getBadgeColor(badge.type),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Level ${badge.challengeLevel}',
                      style: FlutterFlowTheme.of(context).bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getBadgeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'gold':
        return Colors.amber;
      case 'silver':
        return Colors.grey[400]!;
      case 'bronze':
        return Colors.brown[300]!;
      default:
        return Colors.grey;
    }
  }
} 