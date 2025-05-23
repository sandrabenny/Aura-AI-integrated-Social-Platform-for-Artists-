import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/backend/schema/challenge_record.dart';
import '/backend/schema/badge_record.dart';
import 'dart:math';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  final List<Map<String, dynamic>> _challengeLevels = [
    {
      'level': 1,
      'title': 'Speed Sketch Master',
      'description': 'Create a detailed sketch in under 5 minutes',
      'timeLimit': 300,
      'theme': 'Urban Landscape',
    },
    {
      'level': 2,
      'title': 'Color Theory Challenge',
      'description': 'Create a piece using only complementary colors',
      'timeLimit': 600,
      'theme': 'Complementary Colors',
    },
    {
      'level': 3,
      'title': 'Digital Art Fusion',
      'description': 'Combine traditional and digital techniques',
      'timeLimit': 900,
      'theme': 'Mixed Media',
    },
    {
      'level': 4,
      'title': 'Character Design Sprint',
      'description': 'Design a unique character with backstory',
      'timeLimit': 1200,
      'theme': 'Character Design',
    },
    {
      'level': 5,
      'title': 'Environmental Storytelling',
      'description': 'Create an environment that tells a story',
      'timeLimit': 1500,
      'theme': 'Environmental Art',
    },
    {
      'level': 6,
      'title': 'Style Transfer Challenge',
      'description': 'Reinterpret a famous artwork in your style',
      'timeLimit': 1800,
      'theme': 'Style Transfer',
    },
    {
      'level': 7,
      'title': 'Concept Art Mastery',
      'description': 'Create a concept piece for a game or movie',
      'timeLimit': 2100,
      'theme': 'Concept Art',
    },
    {
      'level': 8,
      'title': 'Portfolio Showcase',
      'description': 'Create a piece worthy of a professional portfolio',
      'timeLimit': 2400,
      'theme': 'Portfolio Piece',
    },
  ];

  bool _isSearching = false;
  String? _currentChallengeId;
  int _highestUnlockedLevel = 1; // Track highest unlocked level
  final TextEditingController _roomCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    final user = currentUser;
    if (user == null || user.uid == null) return;

    // Get user's completed challenges
    final completedChallenges = await ChallengeRecord.collection
        .where('participants.${user.uid}.status', isEqualTo: 'completed')
        .get();

    setState(() {
      _highestUnlockedLevel = completedChallenges.docs.length + 1;
    });
  }

  String _getThemeForLevel(int level) {
    switch (level) {
      case 1:
        return 'Nature';
      case 2:
        return 'Urban Life';
      case 3:
        return 'Fantasy';
      case 4:
        return 'Abstract';
      case 5:
        return 'Portrait';
      case 6:
        return 'Sci-Fi';
      case 7:
        return 'Mythology';
      case 8:
        return 'Surrealism';
      default:
        return 'Creative Challenge';
    }
  }

  int _getTimeLimitForLevel(int level) {
    switch (level) {
      case 1:
        return 30;
      case 2:
        return 45;
      case 3:
        return 60;
      case 4:
        return 75;
      case 5:
        return 90;
      case 6:
        return 120;
      case 7:
        return 150;
      case 8:
        return 180;
      default:
        return 60;
    }
  }

  Future<void> _createRoom(int level) async {
    if (level > _highestUnlockedLevel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete previous levels first!')),
      );
      return;
    }

    try {
      final user = currentUser;
      if (user == null || user.uid == null) return;

      // Generate a random 6-digit code
      final roomCode = (100000 + Random().nextInt(900000)).toString();
      
      final challenge = ChallengeRecord(
        title: 'Level $level Challenge',
        description: 'Create artwork based on the theme',
        level: level,
        theme: _getThemeForLevel(level),
        timeLimit: _getTimeLimitForLevel(level),
        createdAt: DateTime.now(),
        participants: {
          user.uid!: {
            'joinedAt': FieldValue.serverTimestamp(),
            'status': 'ready',
            'isHost': true,
          }
        },
        status: 'waiting',
        roomCode: roomCode,
      );

      final docRef = await ChallengeRecord.collection.add(challenge.toMap());
      _showRoomCodeDialog(docRef.id, roomCode);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating room: $e')),
        );
      }
    }
  }

  Future<void> _joinRoom(int level) async {
    if (level > _highestUnlockedLevel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete previous levels first!')),
      );
      return;
    }

    final roomCode = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Room'),
        content: TextField(
          controller: _roomCodeController,
          decoration: const InputDecoration(
            labelText: 'Enter 6-digit Room Code',
            hintText: '000000',
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _roomCodeController.text),
            child: const Text('Join'),
          ),
        ],
      ),
    );

    if (roomCode == null || roomCode.isEmpty) return;

    try {
      final user = currentUser;
      if (user == null || user.uid == null) return;

      // Find challenge with matching room code
      final challenges = await ChallengeRecord.collection
          .where('roomCode', isEqualTo: roomCode)
          .where('level', isEqualTo: level)
          .where('status', isEqualTo: 'waiting')
          .get();

      if (challenges.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid room code')),
          );
        }
        return;
      }

      final challenge = challenges.docs.first;
      final challengeData = challenge.data() as Map<String, dynamic>;
      final participants = challengeData['participants'] as Map<String, dynamic>? ?? {};
      
      if (participants.length >= 2) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Room is full')),
          );
        }
        return;
      }

      if (participants.containsKey(user.uid)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You are already in this room')),
          );
        }
        return;
      }

      await ChallengeRecord.collection.doc(challenge.id).update({
        'participants.${user.uid}': {
          'joinedAt': FieldValue.serverTimestamp(),
          'status': 'ready',
          'isHost': false,
        },
      });

      _startChallengeTimer(ChallengeRecord.fromSnapshot(challenge));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error joining room: $e')),
        );
      }
    }
  }

  void _showRoomCodeDialog(String challengeId, String roomCode) {
    setState(() {
      _isSearching = true;
      _currentChallengeId = challengeId;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StreamBuilder<DocumentSnapshot>(
        stream: ChallengeRecord.collection.doc(challengeId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final challenge = ChallengeRecord.fromSnapshot(snapshot.data!);
          final participants = challenge.participants ?? {};
          
          if (participants.length == 2) {
            // Both players joined
            Navigator.pop(context); // Close dialog
            _startChallengeTimer(challenge);
            return const SizedBox.shrink();
          }

          return AlertDialog(
            title: const Text('Room Created'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Share this code with your opponent:',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    roomCode,
                    style: FlutterFlowTheme.of(context).headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Waiting for opponent to join...\n${participants.length}/2 players',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _cancelChallenge();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _startChallengeTimer(ChallengeRecord challenge) async {
    // Start the challenge timer and update status
    await ChallengeRecord.collection.doc(challenge.id).update({
      'status': 'active',
      'startedAt': FieldValue.serverTimestamp(),
    });

    // Show challenge UI
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChallengeTimerPage(challenge: challenge),
        ),
      );
    }
  }

  Future<void> _cancelChallenge() async {
    if (_currentChallengeId == null || _currentChallengeId!.isEmpty) return;

    try {
      final user = currentUser;
      if (user == null || user.uid == null) return;

      // Remove user from participants
      await ChallengeRecord.collection.doc(_currentChallengeId).update({
        'participants.${user.uid}': FieldValue.delete(),
      });

      // Check if there are any participants left
      final doc = await ChallengeRecord.collection.doc(_currentChallengeId).get();
      final challenge = ChallengeRecord.fromSnapshot(doc);
      final participants = challenge.participants ?? {};

      // If no participants left, delete the challenge
      if (participants.isEmpty) {
        await ChallengeRecord.collection.doc(_currentChallengeId).delete();
      }

      setState(() {
        _isSearching = false;
        _currentChallengeId = '';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error canceling challenge: $e')),
        );
      }
    }
  }

  Future<void> _awardBadge(String userId, int level, int wins) async {
    String badgeType;
    if (wins >= 10) {
      badgeType = 'bronze';
    } else if (wins >= 5) {
      badgeType = 'silver';
    } else if (wins >= 3) {
      badgeType = 'gold';
    } else {
      return;
    }

    final badge = BadgeRecord(
      userId: userId,
      type: badgeType,
      challengeLevel: level.toString(),
      wins: wins,
      earnedAt: DateTime.now(),
      imageUrl: 'assets/badges/${badgeType}_level_$level.png',
    );

    await BadgeRecord.collection.add(badge.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        title: Text(
          'Artistic Challenges',
          style: FlutterFlowTheme.of(context).titleMedium,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _challengeLevels.length,
        itemBuilder: (context, index) {
          final level = _challengeLevels[index];
          final isUnlocked = level['level'] <= _highestUnlockedLevel;
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFA500), // Orange
                    Color(0xFF808080), // Grey
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isUnlocked 
                                ? const Color(0xFFFFA500) // Orange
                                : const Color(0xFF808080), // Grey
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Level ${level['level']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            level['title'],
                            style: FlutterFlowTheme.of(context).titleMedium,
                          ),
                        ),
                        if (!isUnlocked)
                          const Icon(
                            Icons.lock,
                            color: Color(0xFF808080), // Grey
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      level['description'],
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 16,
                          color: Color(0xFF808080), // Grey
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${level['timeLimit'] ~/ 60} minutes',
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isUnlocked)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isSearching ? null : () => _createRoom(level['level']),
                              icon: const Icon(Icons.add),
                              label: const Text('Create Room'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFA500), // Orange
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isSearching ? null : () => _joinRoom(level['level']),
                              icon: const Icon(Icons.login),
                              label: const Text('Join Room'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF808080), // Grey
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF808080), // Grey
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Locked'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

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
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _endTime = DateTime.now().add(Duration(seconds: widget.challenge.timeLimit ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        title: Text(
          widget.challenge.title ?? 'Challenge',
          style: FlutterFlowTheme.of(context).titleMedium,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: FlutterFlowTheme.of(context).primaryBackground,
            child: Column(
              children: [
                Text(
                  widget.challenge.theme ?? '',
                  style: FlutterFlowTheme.of(context).titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.challenge.description ?? '',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isComplete)
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        final remaining = _endTime.difference(DateTime.now());
                        if (remaining.isNegative) {
                          _isComplete = true;
                          _submitArtwork();
                        }
                        return Text(
                          '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: FlutterFlowTheme.of(context).headlineLarge,
                        );
                      },
                    )
                  else
                    const Text(
                      'Time\'s Up!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isComplete ? null : _submitArtwork,
              child: Text(_isComplete ? 'Submit Artwork' : 'Submit Early'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitArtwork() async {
    // TODO: Implement artwork submission
    // This would involve:
    // 1. Image picker
    // 2. Upload to Firebase Storage
    // 3. Update challenge record with submission
    // 4. Check if both participants have submitted
    // 5. If both submitted, trigger voting/judging
  }
} 