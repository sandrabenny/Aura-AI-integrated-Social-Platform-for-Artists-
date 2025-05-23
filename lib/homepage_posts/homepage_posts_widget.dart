import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/chat_bot_widget.dart';
import '/components/homenav_widget.dart';
import '/components/post_interaction_widget.dart';
import '/components/sidenav_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/notifications/notifications_page.dart';
import '/services/ai_analysis_service.dart';
import '/services/recommendation_service.dart';
import 'homepage_posts_model.dart';

export 'homepage_posts_model.dart';

class HomepagePostsWidget extends StatefulWidget {
  const HomepagePostsWidget({super.key});

  static String routeName = 'Homepage_posts';
  static String routePath = '/homepagePosts';

  @override
  State<HomepagePostsWidget> createState() => _HomepagePostsWidgetState();
}

class _HomepagePostsWidgetState extends State<HomepagePostsWidget> {
  late HomepagePostsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomepagePostsModel());

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
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF1F4F8),
        drawer: Drawer(
          elevation: 16.0,
          child: wrapWithModel(
            model: _model.sidenavModel,
            updateCallback: () => safeSetState(() {}),
            child: const SidenavWidget(),
          ),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        StreamBuilder<List<SignupRecord>>(
                stream: querySignupRecord(
                  queryBuilder: (signupRecord) => signupRecord.where(
                    'email',
                    isEqualTo: currentUserEmail,
                  ),
                  singleRecord: true,
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
                  List<SignupRecord> columnSignupRecordList = snapshot.data!;
                  final columnSignupRecord = columnSignupRecordList.isNotEmpty
                      ? columnSignupRecordList.first
                      : null;

                            return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 230.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.network(
                                    'https://images.unsplash.com/photo-1626684496076-07e23c6361ff?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8bW91bnRhaW4lMjBob3VzZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                  ).image,
                                ),
                              ),
                              child: Container(
                                width: 100.0,
                                height: 170.0,
                                decoration: const BoxDecoration(
                                  color: Color(0x9A1D2428),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 64.0, 16.0, 12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                        child: Text(
                                          'Welcome to AURA !',
                                          style: FlutterFlowTheme.of(context)
                                              .displaySmall
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: Colors.white,
                                                fontSize: 36.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          columnSignupRecord?.username,
                                          'Sandra',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              color: const Color(0xBEFFFFFF),
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 25.0, 0.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                                SearchPageWidget.routeName);
                                          },
                                          child: Container(
                                                    width: double.infinity,
                                                    height: 40.0,
                                            decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                      borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                        Expanded(
                                                  child: Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                    child: Text(
                                                      'Search users',
                                                              style: FlutterFlowTheme.of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                            fontSize: 15.0,
                                                            letterSpacing: 0.0,
                                                                    fontWeight: FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                        Padding(
                                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                    child: Icon(
                                                      Icons.search,
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                            size: 24.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 0.0, 0.0),
                              child: Text(
                                'Stay Up-to-Date with the Latest in Art!',
                                style: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0xFF57636C),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.recommend,
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  size: 24.0,
                                                ),
                                                const SizedBox(width: 8.0),
                                                Text(
                                                  'Recommended For You',
                                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                                    fontFamily: 'Plus Jakarta Sans',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          FutureBuilder<List<PostImageRecord>>(
                                            future: RecommendationService.getRecommendedArtworks(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation<Color>(
                                                            FlutterFlowTheme.of(context).primary,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 12.0),
                                                        Text(
                                                          'Finding the perfect artworks for you...',
                                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }

                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.error_outline,
                                                          color: FlutterFlowTheme.of(context).error,
                                                          size: 40.0,
                                                        ),
                                                        const SizedBox(height: 8.0),
                                                        Text(
                                                          'Unable to load recommendations',
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Plus Jakarta Sans',
                                                            color: FlutterFlowTheme.of(context).error,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }

                                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                return Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.art_track,
                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                          size: 40.0,
                                                        ),
                                                        const SizedBox(height: 8.0),
                                                        Text(
                                                          'Explore more artworks to get personalized recommendations',
                                                          textAlign: TextAlign.center,
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Plus Jakarta Sans',
                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }

                                              List<PostImageRecord> topArtworks = snapshot.data!;

                                              return SizedBox(
                                                height: 320.0,
                                                child: ListView.builder(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: topArtworks.length,
                                                  itemBuilder: (context, index) {
                                                    final post = topArtworks[index];
                                                    return Padding(
                                                      padding: const EdgeInsets.only(right: 16.0),
                                                      child: Container(
                                                        width: 240.0,
                                                        decoration: BoxDecoration(
                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          borderRadius: BorderRadius.circular(12.0),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              blurRadius: 4.0,
                                                              color: Color(0x1F000000),
                                                              offset: Offset(0.0, 2.0),
                                                            ),
                                                          ],
                                                        ),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            context.pushNamed(
                                                              'ArtDetails',
                                                              queryParameters: {
                                                                'artRef': serializeParam(
                                                                  post.reference,
                                                                  ParamType.DocumentReference,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius: const BorderRadius.vertical(
                                                                      top: Radius.circular(12.0),
                                                                    ),
                                                                    child: Image.network(
                                                                      post.postImage,
                                                                      width: double.infinity,
                                                                      height: 180.0,
                                                                      fit: BoxFit.cover,
                                                                      errorBuilder: (context, error, stackTrace) {
                                                                        print('Error loading image: $error');
                                                                        return Container(
                                                                          width: double.infinity,
                                                                          height: 180.0,
                                                                          color: FlutterFlowTheme.of(context).alternate,
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.image_not_supported,
                                                                                size: 40.0,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                              ),
                                                                              const SizedBox(height: 8.0),
                                                                              Text(
                                                                                'Image not available',
                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                  fontFamily: 'Plus Jakarta Sans',
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                      loadingBuilder: (context, child, loadingProgress) {
                                                                        if (loadingProgress == null) return child;
                                                                        return Container(
                                                                          width: double.infinity,
                                                                          height: 180.0,
                                                                          color: FlutterFlowTheme.of(context).alternate,
                                                                          child: Center(
                                                                            child: CircularProgressIndicator(
                                                                              value: loadingProgress.expectedTotalBytes != null
                                                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                                  : null,
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                FlutterFlowTheme.of(context).primary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      cacheWidth: 500,
                                                                    ),
                                                                  ),
                                                                  StreamBuilder<QuerySnapshot>(
                                                                    stream: FirebaseFirestore.instance
                                                                        .collection('bookings')
                                                                        .where('postimage', isEqualTo: post.postImage)
                                                                        .snapshots(),
                                                                    builder: (context, snapshot) {
                                                                      final bookingCount = snapshot.hasData ? snapshot.data!.size : 0;
                                                                      if (bookingCount > 0) {
                                                                        return Positioned(
                                                                          top: 8.0,
                                                                          right: 8.0,
                                                                          child: Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                                                            decoration: BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).tertiary.withOpacity(0.9),
                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                const Icon(
                                                                                  Icons.local_fire_department,
                                                                                  color: Colors.white,
                                                                                  size: 16.0,
                                                                                ),
                                                                                const SizedBox(width: 4.0),
                                                                                Text(
                                                                                  '$bookingCount booked',
                                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                    fontFamily: 'Plus Jakarta Sans',
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      return const SizedBox();
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(12.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      post.title,
                                                                      style: FlutterFlowTheme.of(context).titleSmall,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                    const SizedBox(height: 4.0),
                                                                    Text(
                                                                      '\$${post.artPrice}',
                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                        fontFamily: 'Plus Jakarta Sans',
                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 8.0),
                                                                    Text(
                                                                      post.description,
                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                        fontFamily: 'Plus Jakarta Sans',
                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                      ),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 200.0,
                                child: CarouselSlider(
                                  items: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/Things_to_do_in_Grasse,_France.jpg',
                                        width: 200.0,
                                        height: 250.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/download.jpg',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/The_Dark_Arts_Of_Henrik_Uldalen.jpg',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/100+_Spring_Phone_Wallpapers_With_Seasonal_Vibes.jpg',
                                            width: 200.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  carouselController:
                                      _model.carouselController ??=
                                          CarouselSliderController(),
                                  options: CarouselOptions(
                                    initialPage: 1,
                                    viewportFraction: 0.5,
                                    disableCenter: true,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.25,
                                    enableInfiniteScroll: true,
                                    scrollDirection: Axis.horizontal,
                                    autoPlay: false,
                                    onPageChanged: (index, _) =>
                                        _model.carouselCurrentIndex = index,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                      child: StreamBuilder<List<PostImageRecord>>(
                                      stream: queryPostImageRecord(
                                        queryBuilder: (postImageRecord) =>
                                              postImageRecord.orderBy('time_posted', descending: true),
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
                                          List<PostImageRecord> listViewPostImageRecordList = snapshot.data!;

                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              for (var listViewPostImageRecord in listViewPostImageRecordList)
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10.0),
                                                    bottomRight:
                                                        Radius.circular(10.0),
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    topRight:
                                                        Radius.circular(10.0),
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        StreamBuilder<
                                                            List<SignupRecord>>(
                                                          stream:
                                                              querySignupRecord(
                                                            queryBuilder:
                                                                (signupRecord) =>
                                                                    signupRecord
                                                                        .where(
                                                              'email',
                                                              isEqualTo:
                                                                  listViewPostImageRecord
                                                                      .postEmail,
                                                            ),
                                                            singleRecord: true,
                                                          ),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return Center(
                                                                child: SizedBox(
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            List<SignupRecord>
                                                                rowSignupRecordList =
                                                                snapshot.data!;
                                                            final rowSignupRecord =
                                                                rowSignupRecordList
                                                                        .isNotEmpty
                                                                    ? rowSignupRecordList
                                                                        .first
                                                                    : null;

                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                await columnSignupRecord!
                                                                    .reference
                                                                    .update(
                                                                        createSignupRecordData(
                                                                  viewcount:
                                                                      columnSignupRecord
                                                                              .viewcount +
                                                                          1,
                                                                ));

                                                                context
                                                                    .pushNamed(
                                                                  MyprofileusepovWidget
                                                                      .routeName,
                                                                  queryParameters:
                                                                      {
                                                                    'name':
                                                                        serializeParam(
                                                                      listViewPostImageRecord
                                                                          .postUser,
                                                                      ParamType
                                                                          .String,
                                                                    ),
                                                                    'profilepic':
                                                                        serializeParam(
                                                                      listViewPostImageRecord
                                                                          .postUserProfile,
                                                                      ParamType
                                                                          .String,
                                                                    ),
                                                                    'email':
                                                                        serializeParam(
                                                                      listViewPostImageRecord
                                                                          .postEmail,
                                                                      ParamType
                                                                          .String,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            10.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          50.0,
                                                                      height:
                                                                          50.0,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child: Image.network(
                                                                        listViewPostImageRecord.postUserProfile,
                                                                        fit: BoxFit.cover,
                                                                        errorBuilder: (context, error, stackTrace) {
                                                                          return Container(
                                                                            width: 50.0,
                                                                            height: 50.0,
                                                                            decoration: BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: Icon(
                                                                              Icons.person,
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              size: 30.0,
                                                                            ),
                                                                          );
                                                                        },
                                                                        loadingBuilder: (context, child, loadingProgress) {
                                                                          if (loadingProgress == null) return child;
                                                                          return Container(
                                                                            width: 50.0,
                                                                            height: 50.0,
                                                                            decoration: BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: Center(
                                                                              child: CircularProgressIndicator(
                                                                                value: loadingProgress.expectedTotalBytes != null
                                                                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                                    : null,
                                                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                                                  FlutterFlowTheme.of(context).primary,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      valueOrDefault<
                                                                          String>(
                                                                        listViewPostImageRecord
                                                                            .postUser,
                                                                        'Sandra',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                listViewPostImageRecord.title,
                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                      fontFamily: 'Plus Jakarta Sans',
                                                                      fontSize: 22.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              const SizedBox(height: 8.0),
                                                              Text(
                                                                listViewPostImageRecord.description,
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Plus Jakarta Sans',
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                              Padding(
                                                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                                                                child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(12.0),
                                                                  child: Image.network(
                                                                    listViewPostImageRecord.postImage,
                                                                    width: double.infinity,
                                                              height: 300.0,
                                                                    fit: BoxFit.cover,
                                                                    errorBuilder: (context, error, stackTrace) {
                                                                print('Error loading image: $error');
                                                                      return Container(
                                                                        width: double.infinity,
                                                                  height: 300.0,
                                                                        decoration: BoxDecoration(
                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                        ),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.image_not_supported,
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                        size: 50.0,
                                                                            ),
                                                                      const SizedBox(height: 8.0),
                                                                            Text(
                                                                        'Image not available',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                fontFamily: 'Plus Jakarta Sans',
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                    loadingBuilder: (context, child, loadingProgress) {
                                                                      if (loadingProgress == null) return child;
                                                                      return Container(
                                                                        width: double.infinity,
                                                                  height: 300.0,
                                                                        decoration: BoxDecoration(
                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                        ),
                                                                        child: Center(
                                                                          child: CircularProgressIndicator(
                                                                            value: loadingProgress.expectedTotalBytes != null
                                                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                                : null,
                                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                                              FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 8.0),
                                                          child: PostInteractionWidget(
                                                            postId: listViewPostImageRecord.reference.id,
                                                            postUserId: listViewPostImageRecord.postEmail,
                                                            postUserName: listViewPostImageRecord.postUser,
                                                            postUserAvatar: listViewPostImageRecord.postUserProfile,
                                                            postImage: listViewPostImageRecord.postImage,
                                                            postTitle: listViewPostImageRecord.title,
                                                            postDescription: listViewPostImageRecord.description,
                                                            postPrice: listViewPostImageRecord.artPrice,
                                                                ),
                                                              ),
                                                              Padding(
                                                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                  children: [
                                                                    Text(
                                                                    'Rs. ',
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Plus Jakarta Sans',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                        listViewPostImageRecord.artPrice,
                                                                    style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                          fontFamily: 'Plus Jakarta Sans',
                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                  FFButtonWidget(
                                                                            onPressed: () async {
                                                                              // Show loading dialog
                                                                              showDialog(
                                                                                context: context,
                                                                                barrierDismissible: false,
                                                                        builder: (context) => const Center(
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      CircularProgressIndicator(),
                                                                                      SizedBox(height: 16),
                                                                                      Text(
                                                                                        'Analyzing artwork...',
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );

                                                                              try {
                                                                                final analysis = await AiAnalysisService.analyzeArtwork(
                                                                                  listViewPostImageRecord.postImage,
                                                                                );

                                                                                // Close loading dialog
                                                                                Navigator.pop(context);

                                                                                // Show analysis in a modal
                                                                                showModalBottomSheet(
                                                                                  context: context,
                                                                                  builder: (context) => Container(
                                                                            padding: const EdgeInsets.all(16),
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              'AI Analysis',
                                                                                              style: FlutterFlowTheme.of(context).titleMedium,
                                                                                            ),
                                                                                            IconButton(
                                                                                      icon: const Icon(Icons.close),
                                                                                              onPressed: () => Navigator.pop(context),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                const Divider(),
                                                                                        Text(
                                                                                          analysis,
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              } catch (e) {
                                                                                // Close loading dialog
                                                                                Navigator.pop(context);
                                                                                
                                                                                // Show error
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(
                                                                            content: const Text('Failed to analyze artwork. Please try again.'),
                                                                                    backgroundColor: FlutterFlowTheme.of(context).error,
                                                                                  ),
                                                                                );
                                                                              }
                                                                            },
                                                                            text: 'AI Analysis',
                                                                    icon: const Icon(
                                                                              Icons.auto_awesome,
                                                                              size: 15,
                                                                            ),
                                                                            options: FFButtonOptions(
                                                                              width: 110.0,
                                                                              height: 38.0,
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                    fontFamily: 'Inter Tight',
                                                                                    color: Colors.white,
                                                                                    letterSpacing: 0.0,
                                                                                  ),
                                                                      elevation: 2.0,
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                  const SizedBox(width: 8.0),
                                                                  FFButtonWidget(
                                                                            onPressed: () async {
                                                                              context.pushNamed(
                                                                            ArtbuyingWidget.routeName,
                                                                                queryParameters: {
                                                                              'postimage': serializeParam(
                                                                                listViewPostImageRecord.postImage,
                                                                                ParamType.String,
                                                                              ),
                                                                              'postTitle': serializeParam(
                                                                                listViewPostImageRecord.title,
                                                                                ParamType.String,
                                                                              ),
                                                                              'postDescp': serializeParam(
                                                                                listViewPostImageRecord.description,
                                                                                ParamType.String,
                                                                              ),
                                                                              'postPrice': serializeParam(
                                                                                listViewPostImageRecord.artPrice,
                                                                                ParamType.String,
                                                                              ),
                                                                              'postUser': serializeParam(
                                                                                columnSignupRecord?.username,
                                                                                ParamType.String,
                                                                              ),
                                                                              'postEmail': serializeParam(
                                                                                listViewPostImageRecord.postEmail,
                                                                                ParamType.String,
                                                                              ),
                                                                              'userpic': serializeParam(
                                                                                columnSignupRecord?.profilepic,
                                                                                ParamType.String,
                                                                              ),
                                                                              'datetime': serializeParam(
                                                                                getCurrentTimestamp,
                                                                                ParamType.DateTime,
                                                                              ),
                                                                              'mymail': serializeParam(
                                                                                currentUserEmail,
                                                                                ParamType.String,
                                                                              ),
                                                                              'myname': serializeParam(
                                                                                columnSignupRecord?.username,
                                                                                ParamType.String,
                                                                              ),
                                                                            }.withoutNulls,
                                                                          );
                                                                        },
                                                                            text: 'Buy now',
                                                                            options: FFButtonOptions(
                                                                              width: 90.0,
                                                                              height: 38.0,
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                              color: FlutterFlowTheme.of(context).tertiary,
                                                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                fontFamily: 'Inter Tight',
                                                                                color: Colors.white,
                                                                                letterSpacing: 0.0,
                                                                              ),
                                                                        elevation: 2.0,
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                      
                                                    ),
                                                  ),
                                                ),
                                              ),
                                                ),
                                            ],
                                        );
                                      },
                              ),
                            ),
                          ],
                        ),
                      ],
                  );
                },
              ),
                      ],
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.homenavModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const HomenavWidget(),
                ),
              ],
            ),
            Align(
              alignment: const AlignmentDirectional(1.0, -1.0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 10.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed('BlogPage');
                      },
                      child: Icon(
                        Icons.article_outlined,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 30.0,
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(BookexhibitionWidget.routeName);
                  },
                  child: Icon(
                    Icons.warehouse_sharp,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 30.0,
                  ),
                ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('notifications')
                          .where('user_id', isEqualTo: currentUser?.uid)
                          .where('is_read', isEqualTo: false)
                          .where('type', isEqualTo: 'live_auction')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const SizedBox();
                        }
                        return Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).error,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              snapshot.data!.docs.length.toString(),
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 35.0,
              left: 10.0,
              child: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              icon: Icon(
                Icons.dehaze_sharp,
                color: FlutterFlowTheme.of(context).info,
                size: 30.0,
              ),
              onPressed: () async {
                scaffoldKey.currentState!.openDrawer();
              },
            ),
            ),
            Positioned(
              bottom: 100.0,
              left: 16.0,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('user_id', isEqualTo: currentUser?.uid)
                    .where('is_read', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  final unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: FlutterFlowIconButton(
                          borderRadius: 30.0,
                          buttonSize: 60.0,
                          icon: Icon(
                            Icons.notifications_outlined,
                            color: FlutterFlowTheme.of(context).info,
                            size: 30.0,
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationsPage()),
                            );
                          },
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).error,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primaryBackground,
                                width: 2,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                unreadCount.toString(),
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const ChatBotWidget(),
          ],
        ),
      ),
    );
  }
}
