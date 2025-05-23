import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';

class ExhibitionRecord extends FirestoreRecord {
  ExhibitionRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "profilepic" field.
  String? _profilepic;
  String get profilepic => _profilepic ?? '';
  bool hasProfilepic() => _profilepic != null;

  // "no_arts" field.
  String? _noArts;
  String get noArts => _noArts ?? '';
  bool hasNoArts() => _noArts != null;

  // "theme" field.
  String? _theme;
  String get theme => _theme ?? '';
  bool hasTheme() => _theme != null;

  // "more_info" field.
  String? _moreInfo;
  String get moreInfo => _moreInfo ?? '';
  bool hasMoreInfo() => _moreInfo != null;

  // "location" field.
  String? _location;
  String get location => _location ?? '';
  bool hasLocation() => _location != null;

  // "datetime" field.
  DateTime? _datetime;
  DateTime? get datetime => _datetime;
  bool hasDatetime() => _datetime != null;

  // "price" field.
  String? _price;
  String get price => _price ?? '';
  bool hasPrice() => _price != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _profilepic = snapshotData['profilepic'] as String?;
    _noArts = snapshotData['no_arts'] as String?;
    _theme = snapshotData['theme'] as String?;
    _moreInfo = snapshotData['more_info'] as String?;
    _location = snapshotData['location'] as String?;
    _datetime = snapshotData['datetime'] as DateTime?;
    _price = snapshotData['price'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('exhibition');

  static Stream<ExhibitionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ExhibitionRecord.fromSnapshot(s));

  static Future<ExhibitionRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ExhibitionRecord.fromSnapshot(s));

  static ExhibitionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ExhibitionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ExhibitionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ExhibitionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ExhibitionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ExhibitionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createExhibitionRecordData({
  String? email,
  String? profilepic,
  String? noArts,
  String? theme,
  String? moreInfo,
  String? location,
  DateTime? datetime,
  String? price,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'profilepic': profilepic,
      'no_arts': noArts,
      'theme': theme,
      'more_info': moreInfo,
      'location': location,
      'datetime': datetime,
      'price': price,
    }.withoutNulls,
  );

  return firestoreData;
}

class ExhibitionRecordDocumentEquality implements Equality<ExhibitionRecord> {
  const ExhibitionRecordDocumentEquality();

  @override
  bool equals(ExhibitionRecord? e1, ExhibitionRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.profilepic == e2?.profilepic &&
        e1?.noArts == e2?.noArts &&
        e1?.theme == e2?.theme &&
        e1?.moreInfo == e2?.moreInfo &&
        e1?.location == e2?.location &&
        e1?.datetime == e2?.datetime &&
        e1?.price == e2?.price;
  }

  @override
  int hash(ExhibitionRecord? e) => const ListEquality().hash([
        e?.email,
        e?.profilepic,
        e?.noArts,
        e?.theme,
        e?.moreInfo,
        e?.location,
        e?.datetime,
        e?.price
      ]);

  @override
  bool isValidKey(Object? o) => o is ExhibitionRecord;
}
