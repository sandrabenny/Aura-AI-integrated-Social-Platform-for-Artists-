import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessagesRecord {
  final String id;
  final List<String> participants;
  final String? senderId;
  final String? receiverId;
  final String? message;
  final String? lastMessage;
  final DateTime? timestamp;
  final List<String> unreadBy;
  final DocumentReference reference;
  final String? receiverAvatar;
  final String? receiverName;

  ChatMessagesRecord._({
    required this.id,
    required this.participants,
    this.senderId,
    this.receiverId,
    this.message,
    this.lastMessage,
    this.timestamp,
    required this.unreadBy,
    required this.reference,
    this.receiverAvatar,
    this.receiverName,
  });

  factory ChatMessagesRecord.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ChatMessagesRecord._(
      id: snapshot.id,
      participants: List<String>.from(data['participants'] ?? []),
      senderId: data['sender_id'] as String?,
      receiverId: data['receiver_id'] as String?,
      message: data['message'] as String?,
      lastMessage: data['last_message'] as String?,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
      unreadBy: List<String>.from(data['unread_by'] ?? []),
      reference: snapshot.reference,
      receiverAvatar: data['receiver_avatar'] as String?,
      receiverName: data['receiver_name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'last_message': lastMessage,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
      'unread_by': unreadBy,
      'receiver_avatar': receiverAvatar,
      'receiver_name': receiverName,
    };
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('chat_messages');

  static Future<ChatMessagesRecord?> getDocument(DocumentReference ref) =>
      ref.get().then((s) => ChatMessagesRecord.fromSnapshot(s));

  static Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final chatId = [senderId, receiverId]..sort();
    final chatRef = collection.doc();

    await chatRef.set({
      'participants': chatId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'last_message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'unread_by': [receiverId],
      'receiver_avatar': null,
      'receiver_name': null,
    });
  }

  static Future<void> markAsRead(String chatId, String userId) async {
    final chatRef = collection.doc(chatId);
    await chatRef.update({
      'unread_by': FieldValue.arrayRemove([userId]),
    });
  }

  static Stream<List<ChatMessagesRecord>> getChats(String userId) {
    return collection
        .where('participants', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessagesRecord.fromSnapshot(doc))
            .toList());
  }

  static Stream<List<ChatMessagesRecord>> getMessages(String chatId) {
    return collection
        .where('participants', isEqualTo: [chatId])
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessagesRecord.fromSnapshot(doc))
            .toList());
  }
} 