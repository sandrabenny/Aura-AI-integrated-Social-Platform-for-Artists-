import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';

class ArtistRatingRecord extends FirestoreRecord {
  ArtistRatingRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "artist_email" field.
  String? _artistEmail;
  String get artistEmail => _artistEmail ?? '';
  bool hasArtistEmail() => _artistEmail != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  bool hasRating() => _rating != null;

  // "review_text" field.
  String? _reviewText;
  String get reviewText => _reviewText ?? '';
  bool hasReviewText() => _reviewText != null;

  // "reviewer_email" field.
  String? _reviewerEmail;
  String get reviewerEmail => _reviewerEmail ?? '';
  bool hasReviewerEmail() => _reviewerEmail != null;

  // "reviewer_name" field.
  String? _reviewerName;
  String get reviewerName => _reviewerName ?? '';
  bool hasReviewerName() => _reviewerName != null;

  // "reviewer_profile_pic" field.
  String? _reviewerProfilePic;
  String get reviewerProfilePic => _reviewerProfilePic ?? '';
  bool hasReviewerProfilePic() => _reviewerProfilePic != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  void _initializeFields() {
    _artistEmail = snapshotData['artist_email'] as String?;
    _rating = (snapshotData['rating'] as num?)?.toDouble();
    _reviewText = snapshotData['review_text'] as String?;
    _reviewerEmail = snapshotData['reviewer_email'] as String?;
    _reviewerName = snapshotData['reviewer_name'] as String?;
    _reviewerProfilePic = snapshotData['reviewer_profile_pic'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('artist_ratings');

  static Stream<ArtistRatingRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ArtistRatingRecord.fromSnapshot(s));

  static Future<ArtistRatingRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ArtistRatingRecord.fromSnapshot(s));

  static ArtistRatingRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ArtistRatingRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ArtistRatingRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ArtistRatingRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ArtistRatingRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ArtistRatingRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createArtistRatingRecordData({
  String? artistEmail,
  double? rating,
  String? reviewText,
  String? reviewerEmail,
  String? reviewerName,
  String? reviewerProfilePic,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'artist_email': artistEmail,
      'rating': rating,
      'review_text': reviewText,
      'reviewer_email': reviewerEmail,
      'reviewer_name': reviewerName,
      'reviewer_profile_pic': reviewerProfilePic,
      'created_time': createdTime,
    }.withoutNulls,
  );

  return firestoreData;
}

class ArtistRatingRecordDocumentEquality implements Equality<ArtistRatingRecord> {
  const ArtistRatingRecordDocumentEquality();

  @override
  bool equals(ArtistRatingRecord? e1, ArtistRatingRecord? e2) {
    return e1?.artistEmail == e2?.artistEmail &&
        e1?.rating == e2?.rating &&
        e1?.reviewText == e2?.reviewText &&
        e1?.reviewerEmail == e2?.reviewerEmail &&
        e1?.reviewerName == e2?.reviewerName &&
        e1?.reviewerProfilePic == e2?.reviewerProfilePic &&
        e1?.createdTime == e2?.createdTime;
  }

  @override
  int hash(ArtistRatingRecord? e) => const ListEquality().hash([
        e?.artistEmail,
        e?.rating,
        e?.reviewText,
        e?.reviewerEmail,
        e?.reviewerName,
        e?.reviewerProfilePic,
        e?.createdTime
      ]);

  @override
  bool isValidKey(Object? o) => o is ArtistRatingRecord;
} 