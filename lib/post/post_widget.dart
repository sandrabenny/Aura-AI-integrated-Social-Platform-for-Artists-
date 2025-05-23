import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/schema/social_interaction_record.dart';
import '/components/post_interaction_widget.dart';
import '/components/postnav_widget.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/services/image_security_service.dart';
import '/index.dart';
import 'post_model.dart';

export 'post_model.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({super.key});

  static String routeName = 'post';
  static String routePath = '/post';

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late PostModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'just now';
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PostModel());

    _model.titleTextController ??= TextEditingController();
    _model.titleFocusNode ??= FocusNode();

    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Stream<List<SocialInteractionRecord>> querySocialInteractionRecord({
    Query Function(Query)? queryBuilder,
    int limit = -1,
    bool singleRecord = false,
  }) {
    Query query = FirebaseFirestore.instance.collection('social_interactions');
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (limit > 0) {
      query = query.limit(limit);
    }
    return query.snapshots().map((snapshot) => snapshot.docs.map((d) => SocialInteractionRecord.fromSnapshot(d)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: StreamBuilder<List<SignupRecord>>(
                    stream: querySignupRecord(
                      queryBuilder: (signupRecord) => signupRecord.where(
                        'email',
                        isEqualTo: currentUserEmail,
                      ),
                      singleRecord: true,
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }
                      List<SignupRecord> columnSignupRecordList =
                          snapshot.data!;
                      final columnSignupRecord =
                          columnSignupRecordList.isNotEmpty
                              ? columnSignupRecordList.first
                              : null;

                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8.0, 40.0, 8.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FFButtonWidget(
                                        onPressed: () {
                                          print('Button pressed ...');
                                        },
                                        text: 'Cancel',
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Inter Tight',
                                                    color: Colors.white,
                                                    letterSpacing: 0.0,
                                                  ),
                                          elevation: 0.0,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(25.0),
                                            bottomRight: Radius.circular(25.0),
                                            topLeft: Radius.circular(25.0),
                                            topRight: Radius.circular(25.0),
                                          ),
                                        ),
                                      ),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          if (_model.uploadedFileUrl1 != '') {
                                            // Create post first to get the post ID
                                            final postRef = await PostImageRecord.collection
                                                .add(createPostImageRecordData(
                                                  title: _model
                                                      .titleTextController.text,
                                                  description: _model
                                                      .descriptionTextController
                                                      .text,
                                                  postImage:
                                                      _model.uploadedFileUrl1,
                                                  timePosted:
                                                      getCurrentTimestamp,
                                                  postUser: columnSignupRecord
                                                      ?.username,
                                                  postEmail:
                                                      columnSignupRecord?.email,
                                                  artPrice: _model
                                                      .textController3.text,
                                                  postUserProfile:
                                                      columnSignupRecord
                                                          ?.profilepic,
                                                ));

                                            // Set the post ID and user info
                                            _model.postId = postRef.id;
                                            _model.postUserId = columnSignupRecord?.reference.id ?? '';
                                            _model.postUserName = columnSignupRecord?.username ?? '';
                                            _model.postUserAvatar = columnSignupRecord?.profilepic ?? '';

                                            // Now store the image security data
                                            try {
                                              final imageSecurityService = ImageSecurityService();
                                              final result = await imageSecurityService.processImage(
                                                imageUrl: _model.uploadedFileUrl1,
                                                artistId: _model.postUserId,
                                                artworkId: _model.postId,
                                              );
                                              
                                              if (!result['success']) {
                                                print('Failed to store image security data: ${result['error']}');
                                              } else {
                                                print('Successfully stored image security data for post ${_model.postId}');
                                              }
                                            } catch (e) {
                                              print('Error storing image security data: $e');
                                            }

                                            context.goNamed(
                                                HomepagePostsWidget.routeName);
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: const Text('ERROR'),
                                                  content: const Text(
                                                      'An Image is not selected to post'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: const Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        text: 'Post',
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily: 'Inter Tight',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                letterSpacing: 0.0,
                                              ),
                                          elevation: 3.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(25.0),
                                            bottomRight: Radius.circular(25.0),
                                            topLeft: Radius.circular(25.0),
                                            topRight: Radius.circular(25.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 20.0, 0.0, 0.0),
                                        child: SizedBox(
                                          width: 350.0,
                                          child: TextFormField(
                                            controller:
                                                _model.titleTextController,
                                            focusNode: _model.titleFocusNode,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText: 'Title',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            validator: _model.titleTextControllerValidator,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 0.0, 0.0),
                                        child: SizedBox(
                                          width: 350.0,
                                          child: TextFormField(
                                            controller: _model
                                                .descriptionTextController,
                                            focusNode:
                                                _model.descriptionFocusNode,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText: 'Description',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                            maxLines: 5,
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            validator: _model.descriptionTextControllerValidator,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 10.0, 0.0, 0.0),
                                        child: SizedBox(
                                          width: 350.0,
                                          child: TextFormField(
                                            controller: _model.textController3,
                                            focusNode:
                                                _model.textFieldFocusNode,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText: 'Your art price..',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                            cursorColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            validator: _model.textController3Validator,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 0.0),
                                      child: Column(
                                        children: [
                                          // Image preview container
                                          Container(
                                            height: 376.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFB7C3CD),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: _model.uploadedFileUrl1.isEmpty
                                                ? Center(
                                                    child: Text(
                                                      'Select an image to post',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () async {
                                                      await Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type: PageTransitionType.fade,
                                                          child: FlutterFlowExpandedImageView(
                                                            image: Image.network(
                                                              _model.uploadedFileUrl1,
                                                              fit: BoxFit.contain,
                                                              cacheHeight: 250,
                                                            ),
                                                            allowRotation: false,
                                                            tag: _model.uploadedFileUrl1,
                                                            useHeroAnimation: true,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Hero(
                                                      tag: _model.uploadedFileUrl1,
                                                      transitionOnUserGestures: true,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(14.0),
                                                        child: Image.network(
                                                          _model.uploadedFileUrl1,
                                                          width: double.infinity,
                                                          height: 265.0,
                                                          fit: BoxFit.cover,
                                                          cacheHeight: 250,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                          // Image selection buttons
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // Gallery Button
                                                FlutterFlowIconButton(
                                                  borderColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                  borderRadius: 30.0,
                                                  buttonSize: 60.0,
                                                  fillColor: FlutterFlowTheme.of(context).tertiary,
                                                  icon: FaIcon(
                                                    FontAwesomeIcons.image,
                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: () async {
                                                    final selectedMedia = await selectMedia(
                                                      imageQuality: 100,
                                                      mediaSource: MediaSource.photoGallery,
                                                      multiImage: false,
                                                    );
                                                    if (selectedMedia != null &&
                                                        selectedMedia.every((m) =>
                                                            validateFileFormat(m.storagePath, context))) {
                                                      setState(() => _model.isDataUploading1 = true);
                                                      var selectedUploadedFiles = <FFUploadedFile>[];
                                                      var downloadUrls = <String>[];
                                                      try {
                                                        showUploadMessage(context, 'Uploading file...',
                                                            showLoading: true);
                                                        selectedUploadedFiles = selectedMedia
                                                            .map((m) => FFUploadedFile(
                                                                  name: m.storagePath.split('/').last,
                                                                  bytes: m.bytes,
                                                                ))
                                                            .toList();

                                                        downloadUrls = (await Future.wait(
                                                          selectedMedia.map(
                                                            (m) async =>
                                                                await uploadData(m.storagePath, m.bytes),
                                                          ),
                                                        ))
                                                            .whereType<String>()
                                                            .toList();
                                                      } finally {
                                                        ScaffoldMessenger.of(context)
                                                            .hideCurrentSnackBar();
                                                        _model.isDataUploading1 = false;
                                                      }
                                                      if (selectedUploadedFiles.length ==
                                                              selectedMedia.length &&
                                                          downloadUrls.length == selectedMedia.length) {
                                                        try {
                                                          // Check for image forgery before setting the image
                                                          final imageSecurityService = ImageSecurityService();
                                                          final forgeryCheck = await imageSecurityService.checkImageForgery(
                                                            downloadUrls.first,
                                                          );

                                                          if (forgeryCheck['isDuplicate'] == true) {
                                                            if (mounted) {
                                                              showDialog(
                                                                context: context,
                                                                builder: (alertDialogContext) {
                                                                  return AlertDialog(
                                                                    title: const Text('Duplicate Image Detected'),
                                                                    content: Text(
                                                                        'This appears to be a duplicate or very similar to an existing artwork (${(forgeryCheck['similarityScore'] * 100).toStringAsFixed(1)}% match). Please upload original artwork only.'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(alertDialogContext),
                                                                        child: const Text('OK'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                            // Delete the uploaded file since it's a duplicate
                                                            try {
                                                              final storageRef = firebase_storage.FirebaseStorage.instance.refFromURL(downloadUrls.first);
                                                              await storageRef.delete();
                                                            } catch (e) {
                                                              print('Error deleting duplicate image: $e');
                                                            }
                                                            return;
                                                          }

                                                          setState(() {
                                                            _model.uploadedLocalFile1 =
                                                                selectedUploadedFiles.first;
                                                            _model.uploadedFileUrl1 = downloadUrls.first;
                                                          });
                                                          showUploadMessage(context, 'Success!');
                                                        } catch (e) {
                                                          print('Error checking image forgery: $e');
                                                          showUploadMessage(
                                                            context, 
                                                            'Error checking image: $e',
                                                            showLoading: false,
                                                          );
                                                        }
                                                      } else {
                                                        setState(() {});
                                                        showUploadMessage(
                                                            context, 'Failed to upload media');
                                                        return;
                                                      }
                                                    }
                                                  },
                                                ),
                                                // Camera Button
                                                FlutterFlowIconButton(
                                                  borderColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                  borderRadius: 30.0,
                                                  buttonSize: 60.0,
                                                  fillColor: FlutterFlowTheme.of(context).tertiary,
                                                  icon: FaIcon(
                                                    FontAwesomeIcons.camera,
                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: () async {
                                                    final selectedMedia = await selectMedia(
                                                      imageQuality: 100,
                                                      mediaSource: MediaSource.camera,
                                                      multiImage: false,
                                                    );
                                                    if (selectedMedia != null &&
                                                        selectedMedia.every((m) =>
                                                            validateFileFormat(m.storagePath, context))) {
                                                      setState(() => _model.isDataUploading2 = true);
                                                      var selectedUploadedFiles = <FFUploadedFile>[];
                                                      var downloadUrls = <String>[];
                                                      try {
                                                        showUploadMessage(context, 'Uploading file...',
                                                            showLoading: true);
                                                        selectedUploadedFiles = selectedMedia
                                                            .map((m) => FFUploadedFile(
                                                                  name: m.storagePath.split('/').last,
                                                                  bytes: m.bytes,
                                                                ))
                                                            .toList();

                                                        downloadUrls = (await Future.wait(
                                                          selectedMedia.map(
                                                            (m) async =>
                                                                await uploadData(m.storagePath, m.bytes),
                                                          ),
                                                        ))
                                                            .whereType<String>()
                                                            .toList();
                                                      } finally {
                                                        ScaffoldMessenger.of(context)
                                                            .hideCurrentSnackBar();
                                                        _model.isDataUploading2 = false;
                                                      }
                                                      if (selectedUploadedFiles.length ==
                                                              selectedMedia.length &&
                                                          downloadUrls.length == selectedMedia.length) {
                                                        // Check for image forgery before setting the image
                                                        final imageSecurityService = ImageSecurityService();
                                                        final forgeryCheck = await imageSecurityService.checkImageForgery(
                                                          downloadUrls.first,
                                                        );

                                                        if (forgeryCheck['isDuplicate'] == true) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: const Text('Duplicate Image Detected'),
                                                                content: Text(
                                                                    'This appears to be a duplicate or very similar to an existing artwork (${(forgeryCheck['similarityScore'] * 100).toStringAsFixed(1)}% match). Please upload original artwork only.'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () => Navigator.pop(alertDialogContext),
                                                                    child: const Text('OK'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          // Delete the uploaded file since it's a duplicate
                                                          try {
                                                            final storageRef = firebase_storage.FirebaseStorage.instance.refFromURL(downloadUrls.first);
                                                            await storageRef.delete();
                                                          } catch (e) {
                                                            print('Error deleting duplicate image: $e');
                                                          }
                                                        } else {
                                                          setState(() {
                                                            _model.uploadedLocalFile2 =
                                                                selectedUploadedFiles.first;
                                                            _model.uploadedFileUrl1 = downloadUrls.first;
                                                          });
                                                          showUploadMessage(context, 'Success!');
                                                        }
                                                      } else {
                                                        setState(() {});
                                                        showUploadMessage(
                                                            context, 'Failed to upload media');
                                                        return;
                                                      }
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Add social interaction widget after image is selected
                                          if (_model.uploadedFileUrl1.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 16),
                                              child: PostInteractionWidget(
                                                postId: _model.postId ?? '',
                                                postUserId: columnSignupRecord?.reference.id ?? '',
                                                postUserName: columnSignupRecord?.username ?? '',
                                                postUserAvatar: columnSignupRecord?.profilepic ?? '',
                                                postImage: _model.uploadedFileUrl1,
                                                postTitle: _model.titleTextController.text,
                                                postDescription: _model.descriptionTextController.text,
                                                postPrice: _model.textController3.text,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            wrapWithModel(
              model: _model.postnavModel,
              updateCallback: () => safeSetState(() {}),
              child: const PostnavWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
