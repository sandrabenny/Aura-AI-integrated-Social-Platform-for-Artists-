import 'package:flutter/material.dart';

import '../components/postnav_widget.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../index.dart';

class FormListFieldController<T> {
  List<T>? value;
  FormListFieldController(this.value);
}

class PostModel extends FlutterFlowModel<PostWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  TextEditingController? titleTextController;
  FocusNode? titleFocusNode;
  String? Function(String?)? titleTextControllerValidator;
  // State field(s) for TextField widget.
  TextEditingController? descriptionTextController;
  FocusNode? descriptionFocusNode;
  String? Function(String?)? descriptionTextControllerValidator;
  // State field(s) for TextField widget.
  TextEditingController? textController3;
  FocusNode? textFieldFocusNode;
  String? Function(String?)? textController3Validator;
  // State field(s) for DropDown widget.
  List<String>? dropDownValue;
  FormListFieldController<String>? dropDownValueController;
  // State field(s) for Postnav widget.
  late PostnavModel postnavModel;
  // State field(s) for uploaded file
  bool isDataUploading1 = false;
  FFUploadedFile? uploadedLocalFile1;
  String uploadedFileUrl1 = '';
  // State field(s) for uploaded file
  bool isDataUploading2 = false;
  FFUploadedFile? uploadedLocalFile2;
  String uploadedFileUrl2 = '';
  // State field(s) for social interactions
  String postId = '';
  String postUserId = '';
  String postUserName = '';
  String postUserAvatar = '';

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    postnavModel = createModel(context, () => PostnavModel());
    titleTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    textController3 = TextEditingController();
    titleFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    titleFocusNode?.dispose();
    titleTextController?.dispose();
    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
    textFieldFocusNode?.dispose();
    textController3?.dispose();
    postnavModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
