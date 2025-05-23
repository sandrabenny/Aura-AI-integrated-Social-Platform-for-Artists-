import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '/components/homenav_widget.dart';
import '/components/sidenav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'homepage_posts_widget.dart' show HomepagePostsWidget;

class HomepagePostsModel extends FlutterFlowModel<HomepagePostsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  // Model for homenav component.
  late HomenavModel homenavModel;
  // Model for sidenav component.
  late SidenavModel sidenavModel;

  @override
  void initState(BuildContext context) {
    homenavModel = createModel(context, () => HomenavModel());
    sidenavModel = createModel(context, () => SidenavModel());
  }

  @override
  void dispose() {
    homenavModel.dispose();
    sidenavModel.dispose();
  }
}
