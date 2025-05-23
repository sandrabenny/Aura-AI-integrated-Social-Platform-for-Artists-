import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '/backend/schema/challenge_record.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';

class ChallengeTimerPage extends StatefulWidget {
  final ChallengeRecord challenge;

  const ChallengeTimerPage({
    super.key,
    required this.challenge,
  });

  @override
  State<ChallengeTimerPage> createState() => _ChallengeTimerPageState();
}

class _ChallengeTimerPageState extends State<ChallengeTimerPage> {
  late DateTime _endTime;
  late Timer _timer;
  String _timeLeft = '';
  bool _isSubmitting = false;
  final bool _isComplete = false;
  File? _selectedImage;
  final _submissionController = TextEditingController();
  final _criteria = {
    'creativity': 0.0,
    'execution': 0.0,
    'themeAdherence': 0.0,
    'technicalSkill': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _endTime = DateTime.now().add(Duration(minutes: widget.challenge.timeLimit ?? 30));
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(_endTime)) {
        _timer.cancel();
        _submitChallenge();
        return;
      }

      final difference = _endTime.difference(now);
      setState(() {
        _timeLeft = '${difference.inMinutes}:${(difference.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitChallenge() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final user = currentUser;
      if (user == null || user.uid == null) return;

      String? imageUrl;
      if (_selectedImage != null) {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('challenge_submissions/${widget.challenge.id}/${user.uid}');
        await storageRef.putFile(_selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      final submission = {
        'userId': user.uid,
        'content': _submissionController.text,
        'imageUrl': imageUrl,
        'submittedAt': FieldValue.serverTimestamp(),
      };

      await ChallengeRecord.collection.doc(widget.challenge.id).update({
        'submissions.${user.uid}': submission,
      });

      // Check if both participants have submitted
      final challengeDoc = await ChallengeRecord.collection.doc(widget.challenge.id).get();
      final challenge = ChallengeRecord.fromSnapshot(challengeDoc);
      final submissions = challenge.submissions ?? {};
      
      if (submissions.length == 2) {
        // Both participants have submitted, start judging
        _startJudging(challenge);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting challenge: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _startJudging(ChallengeRecord challenge) async {
    // Get both participants
    final participants = challenge.participants ?? {};
    final participantIds = participants.keys.toList();

    // Create a judging session
    await ChallengeRecord.collection.doc(challenge.id).update({
      'status': 'judging',
      'judgingStartedAt': FieldValue.serverTimestamp(),
    });

    // Show judging UI to both participants
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JudgingPage(
            challenge: challenge,
            participantIds: participantIds,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _submissionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.challenge.level} Challenge'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _timeLeft,
                style: FlutterFlowTheme.of(context).headlineMedium,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.challenge.title ?? '',
              style: FlutterFlowTheme.of(context).headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              widget.challenge.description ?? '',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Theme: ${widget.challenge.theme}',
              style: FlutterFlowTheme.of(context).bodyLarge,
            ),
            const SizedBox(height: 24),
            if (_selectedImage != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add Artwork'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _submissionController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Describe your artwork...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitChallenge,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit Challenge'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JudgingPage extends StatefulWidget {
  final ChallengeRecord challenge;
  final List<String> participantIds;

  const JudgingPage({
    super.key,
    required this.challenge,
    required this.participantIds,
  });

  @override
  State<JudgingPage> createState() => _JudgingPageState();
}

class _JudgingPageState extends State<JudgingPage> {
  final Map<String, Map<String, double>> _scores = {};
  bool _isSubmitting = false;

  Future<void> _submitScores() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final user = currentUser;
      if (user == null || user.uid == null) return;

      // Calculate total scores
      final totalScores = <String, double>{};
      for (final participantId in widget.participantIds) {
        final participantScores = _scores[participantId]?.values.toList() ?? [];
        totalScores[participantId] = participantScores.fold(0, (a, b) => a + b);
      }

      // Find winner
      final winnerId = totalScores.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

      // Update challenge with scores and winner
      await ChallengeRecord.collection.doc(widget.challenge.id).update({
        'scores': _scores,
        'winnerId': winnerId,
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Award badge to winner
      final wins = await _getUserWins(winnerId);
      await _awardBadge(winnerId, widget.challenge.level ?? 1, wins);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting scores: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<int> _getUserWins(String userId) async {
    final wins = await ChallengeRecord.collection
        .where('winnerId', isEqualTo: userId)
        .count()
        .get();
    return wins.count ?? 0;
  }

  Future<void> _awardBadge(String userId, int level, int wins) async {
    String badgeType;
    if (wins >= 10) {
      badgeType = 'gold';
    } else if (wins >= 5) {
      badgeType = 'silver';
    } else if (wins >= 3) {
      badgeType = 'bronze';
    } else {
      return;
    }

    final badge = {
      'userId': userId,
      'type': badgeType,
      'challengeLevel': level,
      'wins': wins,
      'earnedAt': FieldValue.serverTimestamp(),
      'imageUrl': 'assets/badges/${badgeType}_level_$level.png',
    };

    await FirebaseFirestore.instance.collection('badges').add(badge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Judge Submissions'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.participantIds.length,
        itemBuilder: (context, index) {
          final participantId = widget.participantIds[index];
          final submission = widget.challenge.submissions?[participantId];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (submission?['imageUrl'] != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(submission!['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    submission?['content'] ?? '',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Score Criteria:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildScoreSlider('Creativity', participantId, 'creativity'),
                  _buildScoreSlider('Execution', participantId, 'execution'),
                  _buildScoreSlider('Theme Adherence', participantId, 'themeAdherence'),
                  _buildScoreSlider('Technical Skill', participantId, 'technicalSkill'),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitScores,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isSubmitting
              ? const CircularProgressIndicator()
              : const Text('Submit Scores'),
        ),
      ),
    );
  }

  Widget _buildScoreSlider(String label, String participantId, String criteria) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: _scores[participantId]?[criteria] ?? 0,
          min: 0,
          max: 10,
          divisions: 10,
          label: (_scores[participantId]?[criteria] ?? 0).toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _scores[participantId] ??= {};
              _scores[participantId]![criteria] = value;
            });
          },
        ),
      ],
    );
  }
} 