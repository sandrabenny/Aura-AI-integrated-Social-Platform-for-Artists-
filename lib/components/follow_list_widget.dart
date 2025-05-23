import 'package:flutter/material.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/follow_service.dart';

class FollowListWidget extends StatelessWidget {
  final String userId;
  final bool isFollowers; // true for followers list, false for following list

  const FollowListWidget({
    super.key,
    required this.userId,
    required this.isFollowers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          isFollowers ? 'Followers' : 'Following',
          style: FlutterFlowTheme.of(context).titleLarge,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<List<String>>(
        stream: isFollowers
            ? FollowService.getFollowers(userId)
            : FollowService.getFollowing(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No ${isFollowers ? 'followers' : 'following'} yet',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final userId = snapshot.data![index];
              return StreamBuilder<List<SignupRecord>>(
                stream: querySignupRecord(
                  queryBuilder: (query) => query.where('email', isEqualTo: userId),
                  singleRecord: true,
                ),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
                    return const SizedBox();
                  }

                  final user = userSnapshot.data!.first;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilepic),
                    ),
                    title: Text(user.username),
                    subtitle: Text(user.email),
                    trailing: currentUser?.email != userId
                        ? StreamBuilder<bool>(
                            stream: FollowService.isFollowing(
                              currentUser?.email ?? '',
                              userId,
                            ),
                            builder: (context, isFollowingSnapshot) {
                              final isFollowing = isFollowingSnapshot.data ?? false;
                              if (isFollowing) {
                                return ElevatedButton(
                                  onPressed: () => FollowService.unfollowUser(
                                    currentUser?.email ?? '',
                                    userId,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  child: const Text('Unfollow'),
                                );
                              }

                              return StreamBuilder<bool>(
                                stream: FollowService.isFollowing(
                                  userId,
                                  currentUser?.email ?? '',
                                ),
                                builder: (context, isFollowedBySnapshot) {
                                  final isFollowedBy =
                                      isFollowedBySnapshot.data ?? false;
                                  return ElevatedButton(
                                    onPressed: () => FollowService.followUser(
                                      currentUser?.email ?? '',
                                      userId,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isFollowedBy
                                          ? FlutterFlowTheme.of(context).primary
                                          : Colors.blue,
                                    ),
                                    child: Text(
                                      isFollowedBy ? 'Follow Back' : 'Follow',
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : null,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'myprofileuserpov',
                        arguments: {
                          'name': user.username,
                          'profilepic': user.profilepic,
                          'email': user.email,
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
} 