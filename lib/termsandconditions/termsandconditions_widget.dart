
import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'termsandconditions_model.dart';

export 'termsandconditions_model.dart';

class TermsandconditionsWidget extends StatefulWidget {
  const TermsandconditionsWidget({super.key});

  static String routeName = 'termsandconditions';
  static String routePath = '/termsandconditions';

  @override
  State<TermsandconditionsWidget> createState() =>
      _TermsandconditionsWidgetState();
}

class _TermsandconditionsWidgetState extends State<TermsandconditionsWidget> {
  late TermsandconditionsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermsandconditionsModel());

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF15161E),
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Terms & Conditions',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: 'Outfit',
                  color: const Color(0xFF15161E),
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to Aura Terms and conditions',
                          style:
                              FlutterFlowTheme.of(context).labelLarge.override(
                                    fontFamily: 'Outfit',
                                    color: const Color(0xFF606A85),
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'These Terms and Conditions (\"Terms\") govern your use of AURA (\"the App\"),. By accessing or using the App, you agree to be bound by these Terms. If you disagree with any part of the Terms, you may not access the App.\n\n1. Account Registration\n\n1.1. To access certain features of the App, you may be required to create an account. You agree to provide accurate and complete information during the registration process.\n\n1.2. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.\n\n1.3. You must notify the Company immediately of any unauthorized use of your account or any other breach of security.\n\n2. User Content\n\n2.1. By submitting content (including but not limited to text, images, videos) to the App, you grant the Company a worldwide, non-exclusive, royalty-free license to use, reproduce, modify, adapt, publish, translate, and distribute such content.\n\n2.2. You agree not to submit any content that violates the rights of others, including copyright, trademark, privacy, publicity, or other personal or proprietary rights.\n\n3. Use of the App\n\n3.1. You agree to use the App only for lawful purposes and in accordance with these Terms.\n\n3.2. You agree not to engage in any conduct that could damage, disable, overburden, or impair the App or interfere with any other party\'s use of the App.\n\n4. Disclaimer of Warranty\n\n4.1. The App is provided on an \"as-is\" and \"as-available\" basis without any warranties of any kind, whether express or implied.\n\n4.2. The Company does not warrant that the App will be error-free, uninterrupted, secure, or free of viruses or other harmful components.\n\n5. Limitation of Liability\n\n5.1. In no event shall the Company be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to lost profits, arising out of or in connection with your use of the App.\n\n6. Modifications to the Terms\n\n6.1. The Company reserves the right to modify these Terms at any time without prior notice. The most current version of the Terms will supersede all previous versions.\n\n7. Governing Law\n\n7.1. These Terms shall be governed by and construed in accordance with the laws of [Your Jurisdiction], without regard to its conflict of law principles.\n\n8. Contact Us\n\nIf you have any questions about these Terms, please contact us at auragallery@gmail.com',
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w300,
                                ),
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
    );
  }
}
