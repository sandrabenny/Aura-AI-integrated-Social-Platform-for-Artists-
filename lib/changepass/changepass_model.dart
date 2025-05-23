import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'changepass_widget.dart' show ChangepassWidget;

class ChangepassModel extends FlutterFlowModel<ChangepassWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for u_password widget.
  FocusNode? uPasswordFocusNode1;
  TextEditingController? uPasswordTextController1;
  late bool uPasswordVisibility1;
  String? Function(BuildContext, String?)? uPasswordTextController1Validator;
  // State field(s) for u_password widget.
  FocusNode? uPasswordFocusNode2;
  TextEditingController? uPasswordTextController2;
  late bool uPasswordVisibility2;
  String? Function(BuildContext, String?)? uPasswordTextController2Validator;

  @override
  void initState(BuildContext context) {
    uPasswordVisibility1 = false;
    uPasswordVisibility2 = false;
  }

  @override
  void dispose() {
    uPasswordFocusNode1?.dispose();
    uPasswordTextController1?.dispose();

    uPasswordFocusNode2?.dispose();
    uPasswordTextController2?.dispose();
  }
}
