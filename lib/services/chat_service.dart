import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../auth/firebase_auth/auth_util.dart';
import '../backend/schema/chat_message_record.dart';

class ChatService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // Get chat messages stream between two users
  Stream<List<ChatMessageRecord>> getChatMessages(String userId1, String userId2) {
    return _firestore
        .collection('chat_messages')
        .where('sender_id', whereIn: [userId1, userId2])
        .where('receiver_id', whereIn: [userId1, userId2])
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatMessageRecord.fromSnapshot(doc)).toList());
  }

  // Send a text message
  Future<void> sendMessage(String receiverId, String text) async {
    final currentUser = currentUserReference;
    if (currentUser == null) return;

    final message = ChatMessageRecord(
      id: '',
      senderId: currentUser.id,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    await _firestore.collection('chat_messages').add(message.toMap());
    
    // Create or update chat room
    final chatRoomId = [currentUser.id, receiverId]..sort();
    final chatRoomRef = _firestore.collection('chat_rooms').doc(chatRoomId.join('_'));
    
    await chatRoomRef.set({
      'participants': [currentUser.id, receiverId],
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  // Send an image message
  Future<void> sendImage(String receiverId, File imageFile) async {
    final currentUser = currentUserReference;
    if (currentUser == null) return;

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
    final ref = _storage.ref().child('chat_images/$fileName');
    await ref.putFile(imageFile);
    final imageUrl = await ref.getDownloadURL();

    final message = ChatMessageRecord(
      id: '',
      senderId: currentUser.id,
      receiverId: receiverId,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
    );

    await _firestore.collection('chat_messages').add(message.toMap());
  }

  // Send a file message
  Future<void> sendFile(String receiverId, PlatformFile file) async {
    final currentUser = currentUserReference;
    if (currentUser == null) return;

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final ref = _storage.ref().child('chat_files/$fileName');
    await ref.putData(file.bytes!);
    final fileUrl = await ref.getDownloadURL();

    final message = ChatMessageRecord(
      id: '',
      senderId: currentUser.id,
      receiverId: receiverId,
      fileUrl: fileUrl,
      fileName: file.name,
      timestamp: DateTime.now(),
    );

    await _firestore.collection('chat_messages').add(message.toMap());
  }

  // Get messages for a chat
  Stream<List<ChatMessageRecord>> getMessages(String receiverId) {
    final currentUser = currentUserReference;
    if (currentUser == null) return Stream.value([]);

    return _firestore
        .collection('chat_messages')
        .where('sender_id', whereIn: [currentUser.id, receiverId])
        .where('receiver_id', whereIn: [currentUser.id, receiverId])
        .orderBy('timestamp', descending: false) // Changed to ascending for proper chat order
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatMessageRecord.fromSnapshot(doc)).toList());
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatPartnerId) async {
    final currentUser = currentUserReference;
    if (currentUser == null) return;

    final chatRoomId = [currentUser.id, chatPartnerId]..sort();
    final chatRoomRef = _firestore.collection('chat_rooms').doc(chatRoomId.join('_'));

    final unreadMessages = await _firestore
        .collection('chat_messages')
        .where('receiver_id', isEqualTo: currentUser.id)
        .where('sender_id', isEqualTo: chatPartnerId)
        .where('is_read', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (var doc in unreadMessages.docs) {
      batch.update(doc.reference, {'is_read': true});
    }
    
    // Reset unread count in chat room
    batch.update(chatRoomRef, {'unreadCount': 0});
    
    await batch.commit();
  }

  // Get unread message count
  Stream<int> getUnreadMessageCount(String userId) {
    return _firestore
        .collection('chat_messages')
        .where('receiver_id', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Delete message
  Future<void> deleteMessage(String messageId) async {
    await _firestore.collection('chat_messages').doc(messageId).delete();
  }

  // Check if two users can chat (they follow each other)
  Future<bool> canUsersChat(String userId1, String userId2) async {
    final follows1 = await _firestore
        .collection('follows')
        .where('follower_id', isEqualTo: userId1)
        .where('following_id', isEqualTo: userId2)
        .get();

    final follows2 = await _firestore
        .collection('follows')
        .where('follower_id', isEqualTo: userId2)
        .where('following_id', isEqualTo: userId1)
        .get();

    return follows1.docs.isNotEmpty && follows2.docs.isNotEmpty;
  }
} 