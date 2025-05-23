import 'package:flutter/material.dart';

import '/components/cartnav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'bookingdetails_widget.dart' show BookingdetailsWidget;

class BookingdetailsModel extends FlutterFlowModel<BookingdetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for cartnav component.
  late CartnavModel cartnavModel;

  @override
  void initState(BuildContext context) {
    cartnavModel = createModel(context, () => CartnavModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    cartnavModel.dispose();
  }
}
