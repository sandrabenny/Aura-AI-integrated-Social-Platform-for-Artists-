import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';

class ArtvaluesRecord extends FirestoreRecord {
  ArtvaluesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  void _initializeFields() {
    _image = snapshotData['image'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('artvalues');

  static Stream<ArtvaluesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ArtvaluesRecord.fromSnapshot(s));

  static Future<ArtvaluesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ArtvaluesRecord.fromSnapshot(s));

  static ArtvaluesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ArtvaluesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ArtvaluesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ArtvaluesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ArtvaluesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ArtvaluesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createArtvaluesRecordData({
  String? image,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'image': image,
    }.withoutNulls,
  );

  return firestoreData;
}

class ArtvaluesRecordDocumentEquality implements Equality<ArtvaluesRecord> {
  const ArtvaluesRecordDocumentEquality();

  @override
  bool equals(ArtvaluesRecord? e1, ArtvaluesRecord? e2) {
    return e1?.image == e2?.image;
  }

  @override
  int hash(ArtvaluesRecord? e) => const ListEquality().hash([e?.image]);

  @override
  bool isValidKey(Object? o) => o is ArtvaluesRecord;
}
