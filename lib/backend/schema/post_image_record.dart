import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';

class PostImageRecord extends FirestoreRecord {
  PostImageRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "post_image" field.
  String? _postImage;
  String get postImage => _postImage ?? '';
  bool hasPostImage() => _postImage != null;

  // "time_posted" field.
  DateTime? _timePosted;
  DateTime? get timePosted => _timePosted;
  bool hasTimePosted() => _timePosted != null;

  // "post_user" field.
  String? _postUser;
  String get postUser => _postUser ?? '';
  bool hasPostUser() => _postUser != null;

  // "post_email" field.
  String? _postEmail;
  String get postEmail => _postEmail ?? '';
  bool hasPostEmail() => _postEmail != null;

  // "art_price" field.
  String? _artPrice;
  String get artPrice => _artPrice ?? '';
  bool hasArtPrice() => _artPrice != null;

  // "post_count" field.
  int? _postCount;
  int get postCount => _postCount ?? 0;
  bool hasPostCount() => _postCount != null;

  // "post_user_profile" field.
  String? _postUserProfile;
  String get postUserProfile => _postUserProfile ?? '';
  bool hasPostUserProfile() => _postUserProfile != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _description = snapshotData['description'] as String?;
    _postImage = snapshotData['post_image'] as String?;
    _timePosted = snapshotData['time_posted'] as DateTime?;
    _postUser = snapshotData['post_user'] as String?;
    _postEmail = snapshotData['post_email'] as String?;
    _artPrice = snapshotData['art_price'] as String?;
    _postCount = castToType<int>(snapshotData['post_count']);
    _postUserProfile = snapshotData['post_user_profile'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('post_image');

  static Stream<PostImageRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PostImageRecord.fromSnapshot(s));

  static Future<PostImageRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PostImageRecord.fromSnapshot(s));

  static PostImageRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PostImageRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PostImageRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PostImageRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PostImageRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PostImageRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPostImageRecordData({
  String? title,
  String? description,
  String? postImage,
  DateTime? timePosted,
  String? postUser,
  String? postEmail,
  String? artPrice,
  int? postCount,
  String? postUserProfile,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'description': description,
      'post_image': postImage,
      'time_posted': timePosted,
      'post_user': postUser,
      'post_email': postEmail,
      'art_price': artPrice,
      'post_count': postCount,
      'post_user_profile': postUserProfile,
    }.withoutNulls,
  );

  return firestoreData;
}

class PostImageRecordDocumentEquality implements Equality<PostImageRecord> {
  const PostImageRecordDocumentEquality();

  @override
  bool equals(PostImageRecord? e1, PostImageRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        e1?.postImage == e2?.postImage &&
        e1?.timePosted == e2?.timePosted &&
        e1?.postUser == e2?.postUser &&
        e1?.postEmail == e2?.postEmail &&
        e1?.artPrice == e2?.artPrice &&
        e1?.postCount == e2?.postCount &&
        e1?.postUserProfile == e2?.postUserProfile;
  }

  @override
  int hash(PostImageRecord? e) => const ListEquality().hash([
        e?.title,
        e?.description,
        e?.postImage,
        e?.timePosted,
        e?.postUser,
        e?.postEmail,
        e?.artPrice,
        e?.postCount,
        e?.postUserProfile
      ]);

  @override
  bool isValidKey(Object? o) => o is PostImageRecord;
}
