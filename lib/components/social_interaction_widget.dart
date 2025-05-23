import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

import '../backend/schema/social_interaction_record.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../services/social_interaction_service.dart';

class SocialInteractionWidget extends StatefulWidget {
  final String postId;
  final String postImageUrl;

  const SocialInteractionWidget({
    super.key,
    required this.postId,
    required this.postImageUrl,
  });

  @override
  _SocialInteractionWidgetState createState() => _SocialInteractionWidgetState();
}

class _SocialInteractionWidgetState extends State<SocialInteractionWidget>
    with SingleTickerProviderStateMixin {
  final SocialInteractionService _socialService = SocialInteractionService();
  late AnimationController _likeAnimationController;
  bool _isLikeAnimating = false;
  final TextEditingController _commentController = TextEditingController();
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  void _handleLikeAnimation() {
    setState(() {
      _isLikeAnimating = true;
    });
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reset();
      setState(() {
        _isLikeAnimating = false;
      });
    });
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Like, Comment, Share buttons row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Like Button with Animation
            StreamBuilder<bool>(
              stream: _socialService.hasUserLiked(widget.postId),
              builder: (context, snapshot) {
                final hasLiked = snapshot.data ?? false;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        hasLiked ? Icons.favorite : Icons.favorite_border,
                        color: hasLiked
                            ? FlutterFlowTheme.of(context).tertiary
                            : FlutterFlowTheme.of(context).secondaryText,
                      ),
                      onPressed: () async {
                        final liked = await _socialService.toggleLike(widget.postId);
                        if (liked) _handleLikeAnimation();
                      },
                    ),
                    if (_isLikeAnimating)
                      LottieBuilder.asset(
                        'assets/lottie/like_animation.json',
                        controller: _likeAnimationController,
                        width: 100,
                        height: 100,
                      ),
                  ],
                );
              },
            ),
            // Comment Button
            IconButton(
              icon: const Icon(Icons.comment_outlined),
              onPressed: () {
                setState(() {
                  _showComments = !_showComments;
                });
              },
            ),
            // Share Button
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () async {
                await Share.share(
                  'Check out this amazing artwork on AURA!',
                  subject: 'AURA Artwork Share',
                );
                await _socialService.sharePost(widget.postId, 'external');
              },
            ),
          ],
        ),
        // Like Count
        StreamBuilder<int>(
          stream: _socialService.getLikeCount(widget.postId),
          builder: (context, snapshot) {
            final likeCount = snapshot.data ?? 0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$likeCount likes',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
            );
          },
        ),
        // Comments Section
        if (_showComments) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: FlutterFlowTheme.of(context).tertiary,
                  onPressed: () {
                    if (_commentController.text.trim().isNotEmpty) {
                      _socialService.addComment(
                        widget.postId,
                        _commentController.text,
                      );
                      _commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          StreamBuilder<List<SocialInteractionRecord>>(
            stream: _socialService.getComments(widget.postId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final comments = snapshot.data ?? [];
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    title: Text(comment.commentText ?? ''),
                    subtitle: Text(
                      'Posted ${_getTimeAgo(comment.timestamp)}',
                      style: FlutterFlowTheme.of(context).bodySmall,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete Comment'),
                                onTap: () {
                                  if (comment.id != null) {
                                    _socialService.deleteComment(comment.id!);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ],
    );
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
} 