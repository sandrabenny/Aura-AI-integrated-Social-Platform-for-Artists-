import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';

class SupportRecord extends FirestoreRecord {
  SupportRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "username" field.
  String? _username;
  String get username => _username ?? '';
  bool hasUsername() => _username != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "support" field.
  String? _support;
  String get support => _support ?? '';
  bool hasSupport() => _support != null;

  void _initializeFields() {
    _username = snapshotData['username'] as String?;
    _email = snapshotData['email'] as String?;
    _support = snapshotData['support'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('support');

  static Stream<SupportRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SupportRecord.fromSnapshot(s));

  static Future<SupportRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SupportRecord.fromSnapshot(s));

  static SupportRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SupportRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SupportRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SupportRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SupportRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SupportRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSupportRecordData({
  String? username,
  String? email,
  String? support,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'username': username,
      'email': email,
      'support': support,
    }.withoutNulls,
  );

  return firestoreData;
}

class SupportRecordDocumentEquality implements Equality<SupportRecord> {
  const SupportRecordDocumentEquality();

  @override
  bool equals(SupportRecord? e1, SupportRecord? e2) {
    return e1?.username == e2?.username &&
        e1?.email == e2?.email &&
        e1?.support == e2?.support;
  }

  @override
  int hash(SupportRecord? e) =>
      const ListEquality().hash([e?.username, e?.email, e?.support]);

  @override
  bool isValidKey(Object? o) => o is SupportRecord;
}
