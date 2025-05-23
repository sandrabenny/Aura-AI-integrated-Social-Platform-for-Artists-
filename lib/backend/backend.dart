import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/firebase_auth/auth_util.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'schema/artvalues_record.dart';
import 'schema/booking_record.dart';
import 'schema/exhibition_record.dart';
import 'schema/notifications_record.dart';
import 'schema/post_image_record.dart';
import 'schema/signup_record.dart';
import 'schema/support_record.dart';
import 'schema/users_record.dart';
import 'schema/util/firestore_util.dart';

export 'dart:async' show StreamSubscription;

export 'package:cloud_firestore/cloud_firestore.dart' hide Order;
export 'package:firebase_core/firebase_core.dart';

export 'schema/artvalues_record.dart';
export 'schema/booking_record.dart';
export 'schema/exhibition_record.dart';
export 'schema/index.dart';
export 'schema/notifications_record.dart';
export 'schema/post_image_record.dart';
export 'schema/signup_record.dart';
export 'schema/support_record.dart';
export 'schema/users_record.dart';
export 'schema/util/firestore_util.dart';
export 'schema/util/schema_util.dart';

/// Functions to query SignupRecords (as a Stream and as a Future).
Future<int> querySignupRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      SignupRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<SignupRecord>> querySignupRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      SignupRecord.collection,
      SignupRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<SignupRecord>> querySignupRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      SignupRecord.collection,
      SignupRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PostImageRecords (as a Stream and as a Future).
Future<int> queryPostImageRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PostImageRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PostImageRecord>> queryPostImageRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PostImageRecord.collection,
      PostImageRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PostImageRecord>> queryPostImageRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PostImageRecord.collection,
      PostImageRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query SupportRecords (as a Stream and as a Future).
Future<int> querySupportRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      SupportRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<SupportRecord>> querySupportRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      SupportRecord.collection,
      SupportRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<SupportRecord>> querySupportRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      SupportRecord.collection,
      SupportRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query BookingRecords (as a Stream and as a Future).
Future<int> queryBookingRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      BookingRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<BookingRecord>> queryBookingRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      BookingRecord.collection,
      BookingRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<BookingRecord>> queryBookingRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      BookingRecord.collection,
      BookingRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query UsersRecords (as a Stream and as a Future).
Future<int> queryUsersRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      UsersRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<UsersRecord>> queryUsersRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      UsersRecord.collection,
      UsersRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<UsersRecord>> queryUsersRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      UsersRecord.collection,
      UsersRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ArtvaluesRecords (as a Stream and as a Future).
Future<int> queryArtvaluesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ArtvaluesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ArtvaluesRecord>> queryArtvaluesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ArtvaluesRecord.collection,
      ArtvaluesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ArtvaluesRecord>> queryArtvaluesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ArtvaluesRecord.collection,
      ArtvaluesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ExhibitionRecords (as a Stream and as a Future).
Future<int> queryExhibitionRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ExhibitionRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ExhibitionRecord>> queryExhibitionRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ExhibitionRecord.collection,
      ExhibitionRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ExhibitionRecord>> queryExhibitionRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ExhibitionRecord.collection,
      ExhibitionRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query NotificationsRecords (as a Stream and as a Future).
Future<int> queryNotificationsRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      NotificationsRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<NotificationsRecord>> queryNotificationsRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      NotificationsRecord.collection,
      NotificationsRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<NotificationsRecord>> queryNotificationsRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      NotificationsRecord.collection,
      NotificationsRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<int> queryCollectionCount(
  Query collection, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0) {
    query = query.limit(limit);
  }

  return query.count().get().catchError((err) {
    print('Error querying $collection: $err');
  }).then((value) => value.count ?? 0);
}

Stream<List<T>> queryCollection<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.snapshots().handleError((err) {
    print('Error querying $collection: $err');
  }).map((s) => s.docs
      .map((d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ))
      .where((d) => d != null)
      .cast<T>()
      .toList());
}

Future<List<T>> queryCollectionOnce<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.get().then((s) => s.docs
      .map((d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ))
      .where((d) => d != null)
      .cast<T>()
      .toList());
}

Filter filterIn(String field, List? list) => (list?.isEmpty ?? true)
    ? Filter(field, whereIn: null)
    : Filter(field, whereIn: list);

Filter filterArrayContainsAny(String field, List? list) =>
    (list?.isEmpty ?? true)
        ? Filter(field, arrayContainsAny: null)
        : Filter(field, arrayContainsAny: list);

extension QueryExtension on Query {
  Query whereIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereIn: null)
      : where(field, whereIn: list);

  Query whereNotIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereNotIn: null)
      : where(field, whereNotIn: list);

  Query whereArrayContainsAny(String field, List? list) =>
      (list?.isEmpty ?? true)
          ? where(field, arrayContainsAny: null)
          : where(field, arrayContainsAny: list);
}

class FFFirestorePage<T> {
  final List<T> data;
  final Stream<List<T>>? dataStream;
  final QueryDocumentSnapshot? nextPageMarker;

  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
}

Future<FFFirestorePage<T>> queryCollectionPage<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) async {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection).limit(pageSize);
  if (nextPageMarker != null) {
    query = query.startAfterDocument(nextPageMarker);
  }
  Stream<QuerySnapshot>? docSnapshotStream;
  QuerySnapshot docSnapshot;
  if (isStream) {
    docSnapshotStream = query.snapshots();
    docSnapshot = await docSnapshotStream.first;
  } else {
    docSnapshot = await query.get();
  }
  getDocs(QuerySnapshot s) => s.docs
      .map((d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ))
      .where((d) => d != null)
      .cast<T>()
      .toList();
  final data = getDocs(docSnapshot);
  final dataStream = docSnapshotStream?.map(getDocs);
  final nextPageToken = docSnapshot.docs.isEmpty ? null : docSnapshot.docs.last;
  return FFFirestorePage(data, dataStream, nextPageToken);
}

// Creates a Firestore document representing the logged in user if it doesn't yet exist
Future maybeCreateUser(User user) async {
  final userRecord = UsersRecord.collection.doc(user.uid);
  final userExists = await userRecord.get().then((u) => u.exists);
  if (userExists) {
    currentUserDocument = await UsersRecord.getDocumentOnce(userRecord);
    return;
  }

  final userData = createUsersRecordData(
    email: user.email ??
        FirebaseAuth.instance.currentUser?.email ??
        user.providerData.firstOrNull?.email,
    displayName:
        user.displayName ?? FirebaseAuth.instance.currentUser?.displayName,
    photoUrl: user.photoURL,
    uid: user.uid,
    phoneNumber: user.phoneNumber,
    createdTime: getCurrentTimestamp,
  );

  await userRecord.set(userData);
  currentUserDocument = UsersRecord.getDocumentFromData(userData, userRecord);
}

Future updateUserDocument({String? email}) async {
  await currentUserDocument?.reference
      .update(createUsersRecordData(email: email));
}

class LiveAuctionRecord {
  final DocumentReference? reference;
  final String? postId;
  final String? postImage;
  final String? postTitle;
  final String? postDescription;
  final String? postPrice;
  final String? postUser;
  final String? postEmail;
  final String? userpic;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool? isActive;
  final double? currentBid;
  final String? currentBidder;
  final String? currentBidderName;
  final String? currentBidderPic;
  final List<String>? bidders;
  final List<double>? bidAmounts;
  final List<String>? bidderNames;
  final List<String>? bidderPics;
  final List<DateTime>? bidTimes;

  LiveAuctionRecord({
    this.reference,
    this.postId,
    this.postImage,
    this.postTitle,
    this.postDescription,
    this.postPrice,
    this.postUser,
    this.postEmail,
    this.userpic,
    this.startTime,
    this.endTime,
    this.isActive,
    this.currentBid,
    this.currentBidder,
    this.currentBidderName,
    this.currentBidderPic,
    this.bidders,
    this.bidAmounts,
    this.bidderNames,
    this.bidderPics,
    this.bidTimes,
  });

  factory LiveAuctionRecord.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return LiveAuctionRecord(
      reference: snapshot.reference,
      postId: data['postId'] as String?,
      postImage: data['postImage'] as String?,
      postTitle: data['postTitle'] as String?,
      postDescription: data['postDescription'] as String?,
      postPrice: data['postPrice'] as String?,
      postUser: data['postUser'] as String?,
      postEmail: data['postEmail'] as String?,
      userpic: data['userpic'] as String?,
      startTime: (data['startTime'] as Timestamp?)?.toDate(),
      endTime: (data['endTime'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] as bool?,
      currentBid: (data['currentBid'] as num?)?.toDouble(),
      currentBidder: data['currentBidder'] as String?,
      currentBidderName: data['currentBidderName'] as String?,
      currentBidderPic: data['currentBidderPic'] as String?,
      bidders: (data['bidders'] as List<dynamic>?)?.cast<String>(),
      bidAmounts: (data['bidAmounts'] as List<dynamic>?)?.cast<double>(),
      bidderNames: (data['bidderNames'] as List<dynamic>?)?.cast<String>(),
      bidderPics: (data['bidderPics'] as List<dynamic>?)?.cast<String>(),
      bidTimes: (data['bidTimes'] as List<dynamic>?)?.map((e) => (e as Timestamp).toDate()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'postImage': postImage,
      'postTitle': postTitle,
      'postDescription': postDescription,
      'postPrice': postPrice,
      'postUser': postUser,
      'postEmail': postEmail,
      'userpic': userpic,
      'startTime': startTime != null ? Timestamp.fromDate(startTime!) : null,
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'isActive': isActive,
      'currentBid': currentBid,
      'currentBidder': currentBidder,
      'currentBidderName': currentBidderName,
      'currentBidderPic': currentBidderPic,
      'bidders': bidders,
      'bidAmounts': bidAmounts,
      'bidderNames': bidderNames,
      'bidderPics': bidderPics,
      'bidTimes': bidTimes?.map((e) => Timestamp.fromDate(e)).toList(),
    };
  }
}

Future<LiveAuctionRecord?> createLiveAuction({
  required String postId,
  required String postImage,
  required String postTitle,
  required String postDescription,
  required String postPrice,
  required String postUser,
  required String postEmail,
  required String userpic,
}) async {
  final docRef = FirebaseFirestore.instance.collection('liveAuctions').doc();
  final data = {
    'postId': postId,
    'postImage': postImage,
    'postTitle': postTitle,
    'postDescription': postDescription,
    'postPrice': postPrice,
    'postUser': postUser,
    'postEmail': postEmail,
    'userpic': userpic,
    'startTime': Timestamp.fromDate(DateTime.now()),
    'isActive': true,
    'currentBid': double.parse(postPrice),
    'bidders': [],
    'bidAmounts': [],
    'bidderNames': [],
    'bidderPics': [],
    'bidTimes': [],
  };

  await docRef.set(data);
  return LiveAuctionRecord.fromSnapshot(await docRef.get());
}

Stream<List<LiveAuctionRecord>> queryLiveAuctionRecord({
  DocumentReference? parent,
  int? limit,
  double? startAfter,
  bool singleRecord = false,
}) {
  final builder = FirebaseFirestore.instance
      .collection('liveAuctions')
      .where('isActive', isEqualTo: true)
      .orderBy('startTime', descending: true);

  if (limit != null) {
    builder.limit(limit);
  }
  if (startAfter != null) {
    builder.startAfter([startAfter]);
  }
  if (singleRecord) {
    builder.limit(1);
  }

  return builder.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => LiveAuctionRecord.fromSnapshot(doc)).toList();
  });
}

Future<void> placeBid({
  required String auctionId,
  required String bidderId,
  required String bidderName,
  required String bidderPic,
  required double bidAmount,
}) async {
  final docRef = FirebaseFirestore.instance.collection('liveAuctions').doc(auctionId);
  
  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final snapshot = await transaction.get(docRef);
    final currentBid = snapshot.data()?['currentBid'] as double? ?? 0.0;
    
    if (bidAmount <= currentBid) {
      throw Exception('Bid must be higher than current bid');
    }
    
    final bidders = List<String>.from(snapshot.data()?['bidders'] ?? []);
    final bidAmounts = List<double>.from(snapshot.data()?['bidAmounts'] ?? []);
    final bidderNames = List<String>.from(snapshot.data()?['bidderNames'] ?? []);
    final bidderPics = List<String>.from(snapshot.data()?['bidderPics'] ?? []);
    final bidTimes = List<Timestamp>.from(snapshot.data()?['bidTimes'] ?? []);
    
    bidders.add(bidderId);
    bidAmounts.add(bidAmount);
    bidderNames.add(bidderName);
    bidderPics.add(bidderPic);
    bidTimes.add(Timestamp.fromDate(DateTime.now()));
    
    transaction.update(docRef, {
      'currentBid': bidAmount,
      'currentBidder': bidderId,
      'currentBidderName': bidderName,
      'currentBidderPic': bidderPic,
      'bidders': bidders,
      'bidAmounts': bidAmounts,
      'bidderNames': bidderNames,
      'bidderPics': bidderPics,
      'bidTimes': bidTimes,
    });
  });
}

Future<void> endAuction({
  required String auctionId,
  required String winnerId,
  required double finalBid,
}) async {
  final docRef = FirebaseFirestore.instance.collection('liveAuctions').doc(auctionId);
  
  await docRef.update({
    'isActive': false,
    'endTime': Timestamp.fromDate(DateTime.now()),
    'currentBid': finalBid,
    'currentBidder': winnerId,
  });
}
