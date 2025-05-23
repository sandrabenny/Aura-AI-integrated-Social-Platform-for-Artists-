import 'package:flutter/material.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/follow_service.dart';

class FollowButtonWidget extends StatefulWidget {
  const FollowButtonWidget({
    super.key,
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  _FollowButtonWidgetState createState() => _FollowButtonWidgetState();
}

class _FollowButtonWidgetState extends State<FollowButtonWidget> {
  bool? _isFollowing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    final userEmail = currentUser?.email;
    if (userEmail == null) return;
    
    final isFollowing = await FollowService.isFollowing(
      userEmail,
      widget.targetUserId,
    ).first;
    if (mounted) {
      setState(() => _isFollowing = isFollowing);
    }
  }

  Future<void> _toggleFollow() async {
    final userEmail = currentUser?.email;
    if (userEmail == null) return;
    
    setState(() => _isLoading = true);
    try {
      if (_isFollowing == true) {
        await FollowService.unfollowUser(
          userEmail,
          widget.targetUserId,
        );
      } else {
        await FollowService.followUser(
          userEmail,
          widget.targetUserId,
        );
      }
      await _checkFollowStatus();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 120,
        height: 40,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return ElevatedButton(
      onPressed: _toggleFollow,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFollowing == true
            ? FlutterFlowTheme.of(context).secondaryBackground
            : FlutterFlowTheme.of(context).primary,
        foregroundColor: _isFollowing == true
            ? FlutterFlowTheme.of(context).primary
            : FlutterFlowTheme.of(context).primaryText,
        minimumSize: const Size(120, 40),
      ),
      child: Text(_isFollowing == true ? 'Following' : 'Follow'),
    );
  }
} 