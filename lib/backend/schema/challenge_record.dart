import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeRecord {
  final String? id;
  final String? title;
  final String? description;
  final int? level;
  final String? theme;
  final int? timeLimit;
  final DateTime? createdAt;
  final Map<String, dynamic>? participants;
  final String? status; // 'pending', 'active', 'completed'
  final String? winnerId;
  final Map<String, dynamic>? submissions;
  final Map<String, dynamic>? scores;
  final Map<String, dynamic>? criteria;
  final String? roomCode;

  ChallengeRecord({
    this.id,
    this.title,
    this.description,
    this.level,
    this.theme,
    this.timeLimit,
    this.createdAt,
    this.participants,
    this.status,
    this.winnerId,
    this.submissions,
    this.scores,
    this.criteria,
    this.roomCode,
  });

  factory ChallengeRecord.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return ChallengeRecord(
      id: doc.id,
      title: data?['title'],
      description: data?['description'],
      level: data?['level'],
      theme: data?['theme'],
      timeLimit: data?['timeLimit'],
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
      participants: data?['participants'],
      status: data?['status'],
      winnerId: data?['winnerId'],
      submissions: data?['submissions'],
      scores: data?['scores'],
      criteria: data?['criteria'],
      roomCode: data?['roomCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'level': level,
      'theme': theme,
      'timeLimit': timeLimit,
      'createdAt': createdAt,
      'participants': participants,
      'status': status,
      'winnerId': winnerId,
      'submissions': submissions,
      'scores': scores,
      'criteria': criteria,
      'roomCode': roomCode,
    };
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('challenges');
} 