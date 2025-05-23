import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/services/notification_service.dart';

class LiveAuctionWidget extends StatefulWidget {
  const LiveAuctionWidget({
    super.key,
    required this.auctionId,
    required this.isOwner,
    required this.postImage,
  });

  final String auctionId;
  final bool isOwner;
  final String postImage;

  @override
  State<LiveAuctionWidget> createState() => _LiveAuctionWidgetState();
}

class _LiveAuctionWidgetState extends State<LiveAuctionWidget> {
  final TextEditingController _bidController = TextEditingController();
  bool _isLoading = false;
  bool _isCameraActive = false;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        title: Text(
          'Live Auction',
          style: FlutterFlowTheme.of(context).titleMedium,
        ),
        actions: [
          if (widget.isOwner)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('End Auction'),
                    content: const Text('Are you sure you want to end this auction?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _endAuction();
                        },
                        child: const Text('End'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Live preview section
          SizedBox(
            height: 300,
            child: _isCameraActive && _cameraController != null
                ? CameraPreview(_cameraController!)
                : Image.network(
                    widget.postImage,
                    fit: BoxFit.cover,
                  ),
          ),
          // Camera toggle button
          if (widget.isOwner)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: _toggleCamera,
                icon: Icon(_isCameraActive ? Icons.image : Icons.camera_alt),
                label: Text(_isCameraActive ? 'Show Post' : 'Use Camera'),
              ),
            ),
          // Rest of the auction UI
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('liveAuctions')
                  .doc(widget.auctionId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;
                if (data == null || !data['isActive']) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.tv_off,
                          size: 64,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Auction Ended',
                          style: FlutterFlowTheme.of(context).headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This auction has ended. The winner was ${data?['currentBidderName'] ?? 'No one'} with a bid of \$${data?['currentBid']?.toStringAsFixed(2) ?? "0.00"}',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                final isActive = data['isActive'] as bool? ?? false;
                final currentBid = data['currentBid'] as double? ?? 0.0;
                final currentBidderName = data['currentBidderName'] as String?;
                final currentBidderPic = data['currentBidderPic'] as String?;
                final bidders = List<String>.from(data['bidders'] ?? []);
                final bidAmounts = List<double>.from(data['bidAmounts'] ?? []);
                final bidderNames = List<String>.from(data['bidderNames'] ?? []);
                final bidderPics = List<String>.from(data['bidderPics'] ?? []);
                final bidTimes = List<Timestamp>.from(data['bidTimes'] ?? []);

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      child: Column(
                        children: [
                          Text(
                            'Current Bid',
                            style: FlutterFlowTheme.of(context).labelMedium,
                          ),
                          Text(
                            '\$${currentBid.toStringAsFixed(2)}',
                            style: FlutterFlowTheme.of(context).headlineMedium,
                          ),
                          if (currentBidderName != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(currentBidderPic ?? ''),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  currentBidderName,
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: bidders.length,
                        itemBuilder: (context, index) {
                          final bidAmount = bidAmounts[index];
                          final bidderName = bidderNames[index];
                          final bidderPic = bidderPics[index];
                          final bidTime = bidTimes[index].toDate();

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(bidderPic),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bidderName,
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                      ),
                                      Text(
                                        '\$${bidAmount.toStringAsFixed(2)}',
                                        style: FlutterFlowTheme.of(context).titleSmall,
                                      ),
                                      Text(
                                        _formatTimeAgo(bidTime),
                                        style: FlutterFlowTheme.of(context).bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (!widget.isOwner) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _bidController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter bid amount',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixText: '\$',
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _placeBid(context, currentBid),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Place Bid'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleCamera() async {
    if (_isCameraActive) {
      await _cameraController?.dispose();
      setState(() => _isCameraActive = false);
    } else {
      if (_cameraController != null) {
        await _cameraController!.initialize();
        setState(() => _isCameraActive = true);
      }
    }
  }

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Future<void> _placeBid(BuildContext context, double currentBid) async {
    if (_bidController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a bid amount')),
      );
      return;
    }

    final bidAmount = double.tryParse(_bidController.text);
    if (bidAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (bidAmount <= currentBid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bid must be higher than current bid')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      await placeBid(
        auctionId: widget.auctionId,
        bidderId: user.uid ?? '',
        bidderName: user.displayName ?? 'Anonymous',
        bidderPic: user.photoUrl ?? '',
        bidAmount: bidAmount,
      );

      _bidController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing bid: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _endAuction() async {
    try {
      final auctionRef = FirebaseFirestore.instance.collection('liveAuctions').doc(widget.auctionId);
      final auctionDoc = await auctionRef.get();
      
      if (auctionDoc.exists) {
        final data = auctionDoc.data()!;
        final currentBid = data['currentBid'] as num?;
        final currentBidderId = data['currentBidderId'] as String?;
        
        if (currentBid != null && currentBidderId != null) {
          // Create booking record
          await FirebaseFirestore.instance.collection('bookings').add({
            'postimage': widget.postImage,
            'postid': data['postId'],
            'userid': currentBidderId,
            'price': currentBid,
            'timestamp': FieldValue.serverTimestamp(),
          });
          
          // Update post status
          await FirebaseFirestore.instance.collection('postImage').doc(data['postId']).update({
            'isSold': true,
          });
        }
        
        // Update auction status
        await auctionRef.update({
          'isActive': false,
          'endedAt': FieldValue.serverTimestamp(),
        });
        
        // Notify all participants
        final participants = data['participants'] as List<dynamic>? ?? [];
        for (final userId in participants) {
          await FirebaseFirestore.instance.collection('notifications').add({
            'user_id': userId,
            'type': 'auction_ended',
            'title': 'Auction Ended',
            'message': 'The auction for "${data['postTitle']}" has ended.',
            'timestamp': FieldValue.serverTimestamp(),
            'is_read': false,
          });
        }
      }
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error ending auction: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error ending auction: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _bidController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }
} 