import 'package:flutter/material.dart';

import '/components/profilenav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'myprofile_widget.dart' show MyprofileWidget;

class MyprofileModel extends FlutterFlowModel<MyprofileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for profilenav component.
  late ProfilenavModel profilenavModel;

  @override
  void initState(BuildContext context) {
    profilenavModel = createModel(context, () => ProfilenavModel());
  }

  @override
  void dispose() {
    profilenavModel.dispose();
  }
}
