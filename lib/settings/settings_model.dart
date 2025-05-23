import 'package:flutter/material.dart';

import '/components/settingsnav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'settings_widget.dart' show SettingsWidget;

class SettingsModel extends FlutterFlowModel<SettingsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for settingsnav component.
  late SettingsnavModel settingsnavModel;

  @override
  void initState(BuildContext context) {
    settingsnavModel = createModel(context, () => SettingsnavModel());
  }

  @override
  void dispose() {
    settingsnavModel.dispose();
  }
}
