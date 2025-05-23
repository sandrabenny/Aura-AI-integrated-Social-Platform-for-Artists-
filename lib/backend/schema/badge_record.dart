import 'package:cloud_firestore/cloud_firestore.dart';

class BadgeRecord {
  final String? id;
  final String? userId;
  final String? type; // 'gold', 'silver', 'bronze'
  final String? challengeLevel;
  final int? wins;
  final DateTime? earnedAt;
  final String? imageUrl;

  BadgeRecord({
    this.id,
    this.userId,
    this.type,
    this.challengeLevel,
    this.wins,
    this.earnedAt,
    this.imageUrl,
  });

  factory BadgeRecord.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BadgeRecord(
      id: doc.id,
      userId: data['userId'],
      type: data['type'],
      challengeLevel: data['challengeLevel'],
      wins: data['wins'],
      earnedAt: (data['earnedAt'] as Timestamp?)?.toDate(),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'challengeLevel': challengeLevel,
      'wins': wins,
      'earnedAt': earnedAt != null ? Timestamp.fromDate(earnedAt!) : null,
      'imageUrl': imageUrl,
    };
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('badges');
} 