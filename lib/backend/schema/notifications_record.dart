
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import 'index.dart';

class NotificationsRecord {
  final String type;
  final String fromUser;
  final String toUser;
  final DateTime createdTime;
  final bool isRead;
  final DocumentReference reference;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('notifications');

  NotificationsRecord._({
    required this.type,
    required this.fromUser,
    required this.toUser,
    required this.createdTime,
    required this.isRead,
    required this.reference,
  });

  static NotificationsRecord fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return NotificationsRecord._(
      type: data['type'] as String,
      fromUser: data['from_user'] as String,
      toUser: data['to_user'] as String,
      createdTime: (data['created_time'] as Timestamp).toDate(),
      isRead: data['is_read'] as bool,
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'from_user': fromUser,
      'to_user': toUser,
      'created_time': Timestamp.fromDate(createdTime),
      'is_read': isRead,
    };
  }
}

class NotificationsRecordDocumentEquality
    implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(NotificationsRecord? e1, NotificationsRecord? e2) {
    return e1?.type == e2?.type &&
        e1?.fromUser == e2?.fromUser &&
        e1?.toUser == e2?.toUser &&
        e1?.createdTime == e2?.createdTime &&
        e1?.isRead == e2?.isRead;
  }

  @override
  int hash(NotificationsRecord? e) => const ListEquality().hash([
        e?.type,
        e?.fromUser,
        e?.toUser,
        e?.createdTime,
        e?.isRead
      ]);

  @override
  bool isValidKey(Object? o) => o is NotificationsRecord;
}
