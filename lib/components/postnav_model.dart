import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'postnav_widget.dart' show PostnavWidget;

class PostnavModel extends FlutterFlowModel<PostnavWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  final textController = TextEditingController();
  String? Function(String?)? textControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textController.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
