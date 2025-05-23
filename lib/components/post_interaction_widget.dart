import 'package:flutter/material.dart';
import '/backend/schema/social_interaction_record.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:share_plus/share_plus.dart';
import '/backend/backend.dart';
import '/components/live_auction_widget.dart';
import '/services/notification_service.dart';
import '/services/image_security_service.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PostInteractionWidget extends StatefulWidget {
  final String postId;
  final String postUserId;
  final String postUserName;
  final String postUserAvatar;
  final String postImage;
  final String postTitle;
  final String postDescription;
  final String postPrice;

  const PostInteractionWidget({
    super.key,
    required this.postId,
    required this.postUserId,
    required this.postUserName,
    required this.postUserAvatar,
    required this.postImage,
    required this.postTitle,
    required this.postDescription,
    required this.postPrice,
  });

  @override
  State<PostInteractionWidget> createState() => _PostInteractionWidgetState();
}

class _PostInteractionWidgetState extends State<PostInteractionWidget> {
  final bool _isLiked = false;
  final bool _isLoading = false;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Stream<List<SocialInteractionRecord>> querySocialInteractionRecord({
    Query Function(Query)? queryBuilder,
    int limit = -1,
    bool singleRecord = false,
  }) {
    Query query = FirebaseFirestore.instance.collection('social_interactions');
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (limit > 0) {
      query = query.limit(limit);
    }
    return query.snapshots().map((snapshot) => snapshot.docs.map((d) => SocialInteractionRecord.fromSnapshot(d)).toList());
  }

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'just now';
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Like button
              StreamBuilder<bool>(
                stream: querySocialInteractionRecord(
                  queryBuilder: (query) => query
                    .where('post_id', isEqualTo: widget.postId)
                    .where('user_id', isEqualTo: currentUserReference?.id)
                    .where('type', isEqualTo: 'like'),
                  singleRecord: true,
                ).map((records) => records.isNotEmpty),
                builder: (context, snapshot) {
                  final hasLiked = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(
                      hasLiked ? Icons.favorite : Icons.favorite_border,
                      color: hasLiked ? FlutterFlowTheme.of(context).tertiary : FlutterFlowTheme.of(context).secondaryText,
                      size: 28,
                    ),
                    onPressed: () async {
                      if (hasLiked) {
                        final likeDoc = await querySocialInteractionRecord(
                          queryBuilder: (query) => query
                            .where('post_id', isEqualTo: widget.postId)
                            .where('user_id', isEqualTo: currentUserReference?.id)
                            .where('type', isEqualTo: 'like'),
                        ).first;
                        if (likeDoc.isNotEmpty) {
                          await FirebaseFirestore.instance.collection('social_interactions').doc(likeDoc.first.id).delete();
                        }
                      } else {
                        await SocialInteractionRecord.collection.add({
                          'post_id': widget.postId,
                          'user_id': currentUserReference?.id,
                          'type': 'like',
                          'timestamp': FieldValue.serverTimestamp(),
                          'userName': currentUserDisplayName,
                          'userAvatar': currentUserPhoto,
                        });
                      }
                    },
                  );
                },
              ),
              // Comment button
              IconButton(
                icon: Icon(
                  Icons.comment_outlined,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 28,
                ),
                onPressed: () {
                  _showCommentsBottomSheet(context);
                },
              ),
              // Share button
              IconButton(
                icon: Icon(
                  Icons.share_outlined,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 28,
                ),
                onPressed: () async {
                  _sharePost(context);
                },
              ),
              if (currentUserEmail == widget.postUserId)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('bookings')
                      .where('postimage', isEqualTo: widget.postImage)
                      .snapshots(),
                  builder: (context, bookingSnapshot) {
                    final isSold = bookingSnapshot.hasData && bookingSnapshot.data!.docs.isNotEmpty;
                    
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('liveAuctions')
                          .where('postId', isEqualTo: widget.postId)
                          .where('isActive', isEqualTo: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, auctionSnapshot) {
                        final hasActiveAuction = auctionSnapshot.hasData && auctionSnapshot.data!.docs.isNotEmpty;
                        
                        if (isSold) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'SOLD',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        
                        return IconButton(
                          icon: Icon(
                            hasActiveAuction ? Icons.live_tv : Icons.live_tv_outlined,
                            color: hasActiveAuction ? Colors.red : null,
                          ),
                          onPressed: () async {
                            if (hasActiveAuction) {
                              final auctionDoc = auctionSnapshot.data!.docs.first;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LiveAuctionWidget(
                                    auctionId: auctionDoc.id,
                                    isOwner: currentUserEmail == widget.postUserId,
                                    postImage: widget.postImage,
                                  ),
                                ),
                              );
                            } else {
                              await _startLiveAuction(context);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
        // Like, Comment, Share counts
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              StreamBuilder<List<SocialInteractionRecord>>(
                stream: querySocialInteractionRecord(
                  queryBuilder: (query) => query
                    .where('post_id', isEqualTo: widget.postId)
                    .where('type', isEqualTo: 'like'),
                ),
                builder: (context, snapshot) {
                  final likes = snapshot.data?.length ?? 0;
                  return Text(
                    '$likes likes',
                    style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              StreamBuilder<List<SocialInteractionRecord>>(
                stream: querySocialInteractionRecord(
                  queryBuilder: (query) => query
                    .where('post_id', isEqualTo: widget.postId)
                    .where('type', isEqualTo: 'comment'),
                ),
                builder: (context, snapshot) {
                  final comments = snapshot.data?.length ?? 0;
                  return Text(
                    '$comments comments',
                    style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              StreamBuilder<List<SocialInteractionRecord>>(
                stream: querySocialInteractionRecord(
                  queryBuilder: (query) => query
                    .where('post_id', isEqualTo: widget.postId)
                    .where('type', isEqualTo: 'share'),
                ),
                builder: (context, snapshot) {
                  final shares = snapshot.data?.length ?? 0;
                  return Text(
                    '$shares shares',
                    style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Comments',
                  style: FlutterFlowTheme.of(context).titleMedium,
                ),
              ),
              Expanded(
                child: StreamBuilder<List<SocialInteractionRecord>>(
                  stream: querySocialInteractionRecord(
                    queryBuilder: (query) => query
                        .where('post_id', isEqualTo: widget.postId)
                        .where('type', isEqualTo: 'comment')
                        .orderBy('timestamp', descending: true),
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final comments = snapshot.data!;
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(comment.userAvatar ?? ''),
                          ),
                          title: Text(comment.userName ?? ''),
                          subtitle: Text(comment.commentText ?? ''),
                          trailing: Text(
                            _formatTimeAgo(comment.timestamp ?? DateTime.now()),
                            style: FlutterFlowTheme.of(context).bodySmall,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          _addComment();
                          _commentController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startLiveAuction(BuildContext context) async {
    final user = currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to start an auction')),
      );
      return;
    }

    if (user.uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found')),
      );
      return;
    }

    try {
      // Check if post is already sold
      final bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('postid', isEqualTo: widget.postId)
          .get();

      if (bookingSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This artwork has already been sold')),
        );
        return;
      }

      // Create live auction
      final auctionRef = await FirebaseFirestore.instance.collection('liveAuctions').add({
        'postId': widget.postId,
        'postTitle': widget.postTitle,
        'postImage': widget.postImage,
        'ownerId': user.uid,
        'ownerName': user.displayName ?? 'Anonymous',
        'ownerPic': user.photoUrl ?? '',
        'startingPrice': double.tryParse(widget.postPrice) ?? 0.0,
        'currentBid': double.tryParse(widget.postPrice) ?? 0.0,
        'currentBidderId': null,
        'currentBidderName': null,
        'currentBidderPic': null,
        'bidders': [],
        'bidAmounts': [],
        'bidderNames': [],
        'bidderPics': [],
        'bidTimes': [],
        'participants': [],
        'isActive': true,
        'startedAt': FieldValue.serverTimestamp(),
      });

      // Notify followers
      await NotificationService.notifyFollowersOfLiveAuction(
        artistId: user.uid ?? '',
        artistName: user.displayName ?? 'Anonymous',
        postId: widget.postId,
        postTitle: widget.postTitle,
        postImage: widget.postImage,
        auctionId: auctionRef.id,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LiveAuctionWidget(
              auctionId: auctionRef.id,
              isOwner: true,
              postImage: widget.postImage,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error starting live auction: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting live auction: $e')),
        );
      }
    }
  }

  Future<void> _addComment() async {
    final user = currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to comment')),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a comment')),
      );
      return;
    }

    try {
      await SocialInteractionRecord.collection.add({
        'post_id': widget.postId,
        'user_id': user.uid,
        'type': 'comment',
        'commentText': _commentController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'userName': user.displayName ?? 'Anonymous',
        'userAvatar': user.photoUrl ?? '',
      });

      _commentController.clear();
    } catch (e) {
      print('Error adding comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment: $e')),
      );
    }
  }

  Future<void> _sharePost(BuildContext context) async {
    try {
      final user = currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to share')),
        );
        return;
      }

      // Create shareable link
      final shareUrl = 'https://yourapp.com/post/${widget.postId}';
      
      // Share the post
      await Share.share(
        'Check out this artwork: ${widget.postTitle}\n$shareUrl',
        subject: widget.postTitle,
      );

      // Record share in social interactions
      await SocialInteractionRecord.collection.add({
        'post_id': widget.postId,
        'user_id': user.uid,
        'type': 'share',
        'timestamp': FieldValue.serverTimestamp(),
        'userName': user.displayName ?? 'Anonymous',
        'userAvatar': user.photoUrl ?? '',
      });
    } catch (e) {
      print('Error sharing post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing post: $e')),
      );
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

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
} 