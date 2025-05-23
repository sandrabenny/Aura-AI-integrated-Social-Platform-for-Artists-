import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'search_page_widget.dart' show SearchPageWidget;

class SearchPageModel extends FlutterFlowModel<SearchPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for te widget.
  FocusNode? teFocusNode;
  TextEditingController? teTextController;
  String? Function(BuildContext, String?)? teTextControllerValidator;
  List<SignupRecord> simpleSearchResults = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    teFocusNode?.dispose();
    teTextController?.dispose();
  }
}
