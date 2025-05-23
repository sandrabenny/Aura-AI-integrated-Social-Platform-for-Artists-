import 'package:cloud_firestore/cloud_firestore.dart';

class BlogRecord {
  final String? id;
  final String? title;
  final String? content;
  final String? imageUrl;
  final String? authorId;
  final String? authorName;
  final String? authorPic;
  final DateTime? createdAt;
  final int? likes;
  final int? comments;
  final int? shares;
  final List<String>? likedBy;

  BlogRecord({
    this.id,
    this.title,
    this.content,
    this.imageUrl,
    this.authorId,
    this.authorName,
    this.authorPic,
    this.createdAt,
    this.likes,
    this.comments,
    this.shares,
    this.likedBy,
  });

  factory BlogRecord.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BlogRecord(
      id: snapshot.id,
      title: data['title'] as String?,
      content: data['content'] as String?,
      imageUrl: data['imageUrl'] as String?,
      authorId: data['authorId'] as String?,
      authorName: data['authorName'] as String?,
      authorPic: data['authorPic'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      likes: data['likes'] as int?,
      comments: data['comments'] as int?,
      shares: data['shares'] as int?,
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'authorId': authorId,
      'authorName': authorName,
      'authorPic': authorPic,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'likedBy': likedBy,
    };
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('blogs');

  bool isLikedBy(String userId) {
    return likedBy?.contains(userId) ?? false;
  }
} 