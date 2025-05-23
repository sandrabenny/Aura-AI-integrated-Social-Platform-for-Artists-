import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart';

class SignupRecord extends FirestoreRecord {
  SignupRecord._(
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

  // "password" field.
  String? _password;
  String get password => _password ?? '';
  bool hasPassword() => _password != null;

  // "con_password" field.
  String? _conPassword;
  String get conPassword => _conPassword ?? '';
  bool hasConPassword() => _conPassword != null;

  // "profilepic" field.
  String? _profilepic;
  String get profilepic => _profilepic ?? '';
  bool hasProfilepic() => _profilepic != null;

  // "fav_art" field.
  String? _favArt;
  String get favArt => _favArt ?? '';
  bool hasFavArt() => _favArt != null;

  // "viewcount" field.
  int? _viewcount;
  int get viewcount => _viewcount ?? 0;
  bool hasViewcount() => _viewcount != null;

  void _initializeFields() {
    _username = snapshotData['username'] as String?;
    _email = snapshotData['email'] as String?;
    _password = snapshotData['password'] as String?;
    _conPassword = snapshotData['con_password'] as String?;
    _profilepic = snapshotData['profilepic'] as String?;
    _favArt = snapshotData['fav_art'] as String?;
    _viewcount = castToType<int>(snapshotData['viewcount']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('signup');

  static Stream<SignupRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SignupRecord.fromSnapshot(s));

  static Future<SignupRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SignupRecord.fromSnapshot(s));

  static SignupRecord fromSnapshot(DocumentSnapshot snapshot) => SignupRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SignupRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SignupRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SignupRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SignupRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSignupRecordData({
  String? username,
  String? email,
  String? password,
  String? conPassword,
  String? profilepic,
  String? favArt,
  int? viewcount,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'con_password': conPassword,
      'profilepic': profilepic,
      'fav_art': favArt,
      'viewcount': viewcount,
    }.withoutNulls,
  );

  return firestoreData;
}

class SignupRecordDocumentEquality implements Equality<SignupRecord> {
  const SignupRecordDocumentEquality();

  @override
  bool equals(SignupRecord? e1, SignupRecord? e2) {
    return e1?.username == e2?.username &&
        e1?.email == e2?.email &&
        e1?.password == e2?.password &&
        e1?.conPassword == e2?.conPassword &&
        e1?.profilepic == e2?.profilepic &&
        e1?.favArt == e2?.favArt &&
        e1?.viewcount == e2?.viewcount;
  }

  @override
  int hash(SignupRecord? e) => const ListEquality().hash([
        e?.username,
        e?.email,
        e?.password,
        e?.conPassword,
        e?.profilepic,
        e?.favArt,
        e?.viewcount
      ]);

  @override
  bool isValidKey(Object? o) => o is SignupRecord;
}
