import 'package:flutter/material.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/challenges/challenges_page.dart';
import '/components/artist_ratings_widget.dart';
import '/components/follow_button_widget.dart';
import '/components/follow_list_widget.dart';
import '/components/post_interaction_widget.dart';
import '/components/profilenav_widget.dart';
import '/components/rating_dialog.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/follow_service.dart';
import 'myprofileusepov_model.dart';

export 'myprofileusepov_model.dart';

class MyprofileusepovWidget extends StatefulWidget {
  const MyprofileusepovWidget({
    super.key,
    required this.name,
    required this.profilepic,
    required this.email,
  });

  final String? name;
  final String? profilepic;
  final String? email;

  static String routeName = 'myprofileusepov';
  static String routePath = '/myprofileuserpov';

  @override
  State<MyprofileusepovWidget> createState() => _MyprofileusepovWidgetState();
}

class _MyprofileusepovWidgetState extends State<MyprofileusepovWidget> {
  late MyprofileusepovModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyprofileusepovModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 1.0),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 0.0,
                              shape: const CircleBorder(),
                              child: Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF63676D),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image.network(
                                      widget.profilepic!,
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.emoji_events),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ChallengesPage(),
                                      ),
                                    );
                                  },
                                  tooltip: 'View Challenges',
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  valueOrDefault<String>(
                                    widget.name,
                                    'Name',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: const Color(0xFF15161E),
                                        fontSize: 22.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 4.0, 0.0, 0.0),
                            child: Text(
                              valueOrDefault<String>(
                                widget.email,
                                'Email',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: const Color(0xFF606A85),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F4F8),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12.0, 16.0, 12.0, 16.0),
                                child: FutureBuilder<int>(
                                  future: queryPostImageRecordCount(
                                    queryBuilder: (postImageRecord) =>
                                        postImageRecord.where(
                                      'post_email',
                                      isEqualTo: widget.email,
                                    ),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    int rowCount = snapshot.data!;

                                    return Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 8.0),
                                                child: Text(
                                                  rowCount.toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            const Color(0xFF15161E),
                                                        fontSize: 22.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                              Text(
                                                'Posts',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          color:
                                                              const Color(0xFF606A85),
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: StreamBuilder<int>(
                                            stream: FollowService.getFollowersCount(
                                              widget.email ?? '',
                                            ),
                                            builder: (context, snapshot) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => FollowListWidget(
                                                        userId: widget.email ?? '',
                                                        isFollowers: true,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                                      child: Text(
                                                        snapshot.data?.toString() ?? '0',
                                                        style: FlutterFlowTheme.of(context).titleLarge.override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(0xFF15161E),
                                                          fontSize: 22.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Followers',
                                                      style: FlutterFlowTheme.of(context).labelMedium.override(
                                                        fontFamily: 'Plus Jakarta Sans',
                                                        color: const Color(0xFF606A85),
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: StreamBuilder<int>(
                                            stream: FollowService.getFollowingCount(
                                              widget.email ?? '',
                                            ),
                                            builder: (context, snapshot) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => FollowListWidget(
                                                        userId: widget.email ?? '',
                                                        isFollowers: false,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                                      child: Text(
                                                        snapshot.data?.toString() ?? '0',
                                                        style: FlutterFlowTheme.of(context).titleLarge.override(
                                                          fontFamily: 'Outfit',
                                                          color: const Color(0xFF15161E),
                                                          fontSize: 22.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Following',
                                                      style: FlutterFlowTheme.of(context).labelMedium.override(
                                                        fontFamily: 'Plus Jakarta Sans',
                                                        color: const Color(0xFF606A85),
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'My Collections',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: const Color(0xFF15161E),
                                        fontSize: 22.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StreamBuilder<int>(
                                stream: FollowService.getFollowersCount(widget.email ?? ''),
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      Text(
                                        snapshot.data?.toString() ?? '0',
                                        style: FlutterFlowTheme.of(context).titleLarge,
                                      ),
                                      Text(
                                        'Followers',
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              StreamBuilder<int>(
                                stream: FollowService.getFollowingCount(widget.email ?? ''),
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      Text(
                                        snapshot.data?.toString() ?? '0',
                                        style: FlutterFlowTheme.of(context).titleLarge,
                                      ),
                                      Text(
                                        'Following',
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (currentUser?.email != widget.email)
                            FollowButtonWidget(targetUserId: widget.email ?? ''),
                          if (currentUser?.email == widget.email)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  context.pushNamed('MyLiveAuctions');
                                },
                                icon: const Icon(Icons.live_tv),
                                label: const Text('My Live Auctions'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: FlutterFlowTheme.of(context).primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      StreamBuilder<List<PostImageRecord>>(
                        stream: queryPostImageRecord(
                          queryBuilder: (postImageRecord) => postImageRecord
                              .where(
                                'post_email',
                                isEqualTo: widget.email,
                              )
                              .orderBy('time_posted', descending: true),
                        ),
                        builder: (context, snapshot) {
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
                          List<PostImageRecord> listViewPostImageRecordList =
                              snapshot.data!;

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: listViewPostImageRecordList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewPostImageRecord =
                                      listViewPostImageRecordList[listViewIndex];
                                  return Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        10.0, 10.0, 10.0, 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            FlutterFlowTheme.of(context).alternate,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional.fromSTEB(
                                                      20.0, 10.0, 0.0, 10.0),
                                              child: Text(
                                                valueOrDefault<String>(
                                                  listViewPostImageRecord.title,
                                                  'Title',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Outfit',
                                                      color: FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 342.0,
                                            height: 212.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context)
                                                  .primaryText,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                listViewPostImageRecord.postImage,
                                                width: 475.0,
                                                height: 217.89,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional.fromSTEB(
                                                      20.0, 10.0, 0.0, 10.0),
                                              child: Text(
                                                valueOrDefault<String>(
                                                  listViewPostImageRecord
                                                      .description,
                                                  'Description',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primaryText,
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          PostInteractionWidget(
                                            postId: listViewPostImageRecord.reference.id,
                                            postUserId: listViewPostImageRecord.postEmail,
                                            postUserName: listViewPostImageRecord.postUser ?? 'Anonymous',
                                            postUserAvatar: listViewPostImageRecord.postUserProfile ?? '',
                                            postImage: listViewPostImageRecord.postImage,
                                            postTitle: listViewPostImageRecord.title ?? '',
                                            postDescription: listViewPostImageRecord.description ?? '',
                                            postPrice: listViewPostImageRecord.artPrice ?? '0',
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (widget.email != currentUserEmail)
                                StreamBuilder<List<SignupRecord>>(
                                  stream: querySignupRecord(
                                    queryBuilder: (query) => query.where('email', isEqualTo: currentUserEmail),
                                    singleRecord: true,
                                  ),
                                  builder: (context, userSnapshot) {
                                    if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
                                      return const SizedBox();
                                    }
                                    
                                    final userRecord = userSnapshot.data!.first;
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => RatingDialog(
                                                  artistEmail: widget.email ?? '',
                                                  reviewerName: currentUser?.displayName ?? '',
                                                  reviewerProfilePic: userRecord.profilepic ?? '',
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.star),
                                            label: const Text('Rate Artist'),
                                          ),
                                          const SizedBox(height: 16),
                                          ArtistRatingsWidget(artistEmail: widget.email ?? ''),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              const SizedBox(height: 100),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            wrapWithModel(
              model: _model.profilenavModel,
              updateCallback: () => safeSetState(() {}),
              child: const ProfilenavWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
