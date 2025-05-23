import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';

class BookingRecord extends FirestoreRecord {
  BookingRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "artprice" field.
  String? _artprice;
  String get artprice => _artprice ?? '';
  bool hasArtprice() => _artprice != null;

  // "arttitle" field.
  String? _arttitle;
  String get arttitle => _arttitle ?? '';
  bool hasArttitle() => _arttitle != null;

  // "artdesc" field.
  String? _artdesc;
  String get artdesc => _artdesc ?? '';
  bool hasArtdesc() => _artdesc != null;

  // "artimage" field.
  String? _artimage;
  String get artimage => _artimage ?? '';
  bool hasArtimage() => _artimage != null;

  // "artuser" field.
  String? _artuser;
  String get artuser => _artuser ?? '';
  bool hasArtuser() => _artuser != null;

  // "artemail" field.
  String? _artemail;
  String get artemail => _artemail ?? '';
  bool hasArtemail() => _artemail != null;

  // "bookedtimeDate" field.
  DateTime? _bookedtimeDate;
  DateTime? get bookedtimeDate => _bookedtimeDate;
  bool hasBookedtimeDate() => _bookedtimeDate != null;

  // "mymail" field.
  String? _mymail;
  String get mymail => _mymail ?? '';
  bool hasMymail() => _mymail != null;

  void _initializeFields() {
    _artprice = snapshotData['artprice'] as String?;
    _arttitle = snapshotData['arttitle'] as String?;
    _artdesc = snapshotData['artdesc'] as String?;
    _artimage = snapshotData['artimage'] as String?;
    _artuser = snapshotData['artuser'] as String?;
    _artemail = snapshotData['artemail'] as String?;
    _bookedtimeDate = snapshotData['bookedtimeDate'] as DateTime?;
    _mymail = snapshotData['mymail'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('booking');

  static Stream<BookingRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BookingRecord.fromSnapshot(s));

  static Future<BookingRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BookingRecord.fromSnapshot(s));

  static BookingRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BookingRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BookingRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BookingRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BookingRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BookingRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBookingRecordData({
  String? artprice,
  String? arttitle,
  String? artdesc,
  String? artimage,
  String? artuser,
  String? artemail,
  DateTime? bookedtimeDate,
  String? mymail,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'artprice': artprice,
      'arttitle': arttitle,
      'artdesc': artdesc,
      'artimage': artimage,
      'artuser': artuser,
      'artemail': artemail,
      'bookedtimeDate': bookedtimeDate,
      'mymail': mymail,
    }.withoutNulls,
  );

  return firestoreData;
}

class BookingRecordDocumentEquality implements Equality<BookingRecord> {
  const BookingRecordDocumentEquality();

  @override
  bool equals(BookingRecord? e1, BookingRecord? e2) {
    return e1?.artprice == e2?.artprice &&
        e1?.arttitle == e2?.arttitle &&
        e1?.artdesc == e2?.artdesc &&
        e1?.artimage == e2?.artimage &&
        e1?.artuser == e2?.artuser &&
        e1?.artemail == e2?.artemail &&
        e1?.bookedtimeDate == e2?.bookedtimeDate &&
        e1?.mymail == e2?.mymail;
  }

  @override
  int hash(BookingRecord? e) => const ListEquality().hash([
        e?.artprice,
        e?.arttitle,
        e?.artdesc,
        e?.artimage,
        e?.artuser,
        e?.artemail,
        e?.bookedtimeDate,
        e?.mymail
      ]);

  @override
  bool isValidKey(Object? o) => o is BookingRecord;
}
