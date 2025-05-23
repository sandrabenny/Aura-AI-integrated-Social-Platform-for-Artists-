import 'package:cloud_firestore/cloud_firestore.dart';

class SocialInteractionRecord {
  final String? id;
  final String? postId;
  final String? userId;
  final String? type; // 'like', 'comment', 'share'
  final String? commentText;
  final DateTime? timestamp;
  final String? userName;
  final String? userAvatar;
  final String? shareDestination; // for tracking where content was shared
  
  static final CollectionReference collection = FirebaseFirestore.instance.collection('social_interactions');
  
  SocialInteractionRecord({
    this.id,
    this.postId,
    this.userId,
    this.type,
    this.commentText,
    this.timestamp,
    this.userName,
    this.userAvatar,
    this.shareDestination,
  });

  factory SocialInteractionRecord.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    return SocialInteractionRecord(
      id: snapshot.id,
      postId: data?['post_id'] as String?,
      userId: data?['user_id'] as String?,
      type: data?['type'] as String?,
      commentText: data?['comment_text'] as String?,
      timestamp: (data?['timestamp'] as Timestamp?)?.toDate(),
      userName: data?['userName'] as String?,
      userAvatar: data?['userAvatar'] as String?,
      shareDestination: data?['shareDestination'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'user_id': userId,
      'type': type,
      'comment_text': commentText,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : FieldValue.serverTimestamp(),
      'userName': userName,
      'userAvatar': userAvatar,
      'shareDestination': shareDestination,
    };
  }

  static Future<DocumentReference> add(Map<String, dynamic> data) {
    return collection.add(data);
  }
} 