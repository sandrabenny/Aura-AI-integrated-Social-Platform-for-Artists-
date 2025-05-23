import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/ai_analysis_service.dart';

class ArtDetailsWidget extends StatefulWidget {
  const ArtDetailsWidget({
    super.key,
    required this.artRef,
  });

  final String artRef;
  static const String routeName = 'ArtDetails';
  static const String routePath = '/art-details/:artRef';

  @override
  _ArtDetailsWidgetState createState() => _ArtDetailsWidgetState();
}

class _ArtDetailsWidgetState extends State<ArtDetailsWidget> {
  String? aiAnalysis;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAiAnalysis();
  }

  Future<void> _loadAiAnalysis() async {
    setState(() => isLoading = true);
    try {
      final analysis = await AiAnalysisService.analyzeArtwork(widget.artRef);
      setState(() {
        aiAnalysis = analysis;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        aiAnalysis = 'Failed to analyze artwork. Please try again later.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: const Text('Art Analysis'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.artRef,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (aiAnalysis != null)
              Text(
                aiAnalysis!,
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
} 