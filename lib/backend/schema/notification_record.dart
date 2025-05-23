import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRecord {
  final String? id;
  final String? userId;
  final String? type; // 'live_auction', 'challenge', etc.
  final String? title;
  final String? message;
  final DateTime? createdAt;
  final bool? isRead;
  final Map<String, dynamic>? data; // Additional data like auctionId, artistId, etc.

  NotificationRecord({
    this.id,
    this.userId,
    this.type,
    this.title,
    this.message,
    this.createdAt,
    this.isRead,
    this.data,
  });

  factory NotificationRecord.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return NotificationRecord(
      id: doc.id,
      userId: data?['userId'],
      type: data?['type'],
      title: data?['title'],
      message: data?['message'],
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
      isRead: data?['isRead'],
      data: data?['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'createdAt': createdAt,
      'isRead': isRead,
      'data': data,
    };
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('notifications');
} 