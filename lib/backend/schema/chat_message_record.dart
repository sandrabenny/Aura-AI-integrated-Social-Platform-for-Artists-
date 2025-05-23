import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageRecord {
  final String id;
  final String senderId;
  final String receiverId;
  final String? text;
  final String? imageUrl;
  final String? fileUrl;
  final String? fileName;
  final DateTime timestamp;
  final bool isRead;

  ChatMessageRecord({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.text,
    this.imageUrl,
    this.fileUrl,
    this.fileName,
    required this.timestamp,
    this.isRead = false,
  });

  static ChatMessageRecord fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return ChatMessageRecord(
      id: snap.id,
      senderId: data['sender_id'] ?? '',
      receiverId: data['receiver_id'] ?? '',
      text: data['text'],
      imageUrl: data['image_url'],
      fileUrl: data['file_url'],
      fileName: data['file_name'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'text': text,
      'image_url': imageUrl,
      'file_url': fileUrl,
      'file_name': fileName,
      'timestamp': FieldValue.serverTimestamp(),
      'is_read': isRead,
    };
  }
} 