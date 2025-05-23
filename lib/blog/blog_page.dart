import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '/backend/schema/blog_record.dart';
import 'package:share_plus/share_plus.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _searchController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;
  BlogRecord? _editingBlog;
  final bool _isSearching = false;
  final String _currentChallengeId = '';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _createBlog() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = currentUser;
      if (user == null) throw Exception('User not logged in');

      String? imageUrl;
      if (_selectedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('blog_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_selectedImage!);
        imageUrl = await ref.getDownloadURL();
      }

      final blogRecord = BlogRecord(
        title: _titleController.text,
        content: _contentController.text,
        imageUrl: imageUrl,
        authorId: user.uid,
        authorName: user.displayName ?? 'Anonymous',
        authorPic: user.photoUrl ?? '',
        createdAt: DateTime.now(),
        likes: 0,
        shares: 0,
        likedBy: [],
      );

      await BlogRecord.collection.add(blogRecord.toMap());

      _resetForm();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blog created successfully')),
        );
      }
    } catch (e) {
      print('Error creating blog: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating blog: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateBlog() async {
    if (_editingBlog == null) return;

    setState(() => _isLoading = true);

    try {
      final user = currentUser;
      if (user == null) throw Exception('User not logged in');

      String? imageUrl = _editingBlog!.imageUrl;
      if (_selectedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('blog_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_selectedImage!);
        imageUrl = await ref.getDownloadURL();
      }

      final updatedBlog = BlogRecord(
        id: _editingBlog!.id,
        title: _titleController.text,
        content: _contentController.text,
        imageUrl: imageUrl,
        authorId: user.uid,
        authorName: user.displayName ?? 'Anonymous',
        authorPic: user.photoUrl ?? '',
        createdAt: _editingBlog!.createdAt,
        likes: _editingBlog!.likes,
        comments: _editingBlog!.comments,
        shares: _editingBlog!.shares,
        likedBy: _editingBlog!.likedBy,
      );

      await BlogRecord.collection.doc(_editingBlog!.id).update(updatedBlog.toMap());

      _resetForm();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blog updated successfully')),
        );
      }
    } catch (e) {
      print('Error updating blog: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating blog: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteBlog(BlogRecord blog) async {
    try {
      await BlogRecord.collection.doc(blog.id).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blog deleted successfully')),
        );
      }
    } catch (e) {
      print('Error deleting blog: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting blog: $e')),
        );
      }
    }
  }

  Future<void> _toggleLike(BlogRecord blog) async {
    final user = currentUser;
    if (user == null || user.uid == null) return;

    final isLiked = blog.isLikedBy(user.uid!);
    final newLikedBy = List<String>.from(blog.likedBy ?? []);
    
    if (isLiked) {
      newLikedBy.remove(user.uid);
    } else {
      newLikedBy.add(user.uid!);
    }

    await BlogRecord.collection.doc(blog.id).update({
      'likes': isLiked ? (blog.likes ?? 0) - 1 : (blog.likes ?? 0) + 1,
      'likedBy': newLikedBy,
    });
  }

  Future<void> _shareBlog(BlogRecord blog) async {
    final shareText = '''
${blog.title}

${blog.content}

Shared via AURA
''';

    await Share.share(shareText);
    
    // Update share count
    await BlogRecord.collection.doc(blog.id).update({
      'shares': (blog.shares ?? 0) + 1,
    });
  }

  void _resetForm() {
    _titleController.clear();
    _contentController.clear();
    setState(() {
      _selectedImage = null;
      _editingBlog = null;
    });
  }

  void _editBlog(BlogRecord blog) {
    setState(() {
      _editingBlog = blog;
      _titleController.text = blog.title ?? '';
      _contentController.text = blog.content ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        title: Text(
          'Art Blogs',
          style: FlutterFlowTheme.of(context).titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: BlogRecord.collection
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final blogs = snapshot.data!.docs.map((doc) => BlogRecord.fromSnapshot(doc)).toList();

          if (blogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No blogs yet',
                    style: FlutterFlowTheme.of(context).titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first to share your thoughts!',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              final isOwner = blog.authorId == currentUser?.uid;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => _showBlogDetails(context, blog),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (blog.imageUrl != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                blog.imageUrl!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: FlutterFlowTheme.of(context).alternate,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                    ),
                                  );
                                },
                              ),
                              if (isOwner)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.white),
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('Delete', style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editBlog(blog);
                                        _showBlogForm(context);
                                      } else if (value == 'delete') {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete Blog'),
                                            content: const Text('Are you sure you want to delete this blog?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _deleteBlog(blog);
                                                },
                                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: blog.authorPic != null && blog.authorPic!.isNotEmpty
                                      ? NetworkImage(blog.authorPic!)
                                      : null,
                                  radius: 20,
                                  child: blog.authorPic == null || blog.authorPic!.isEmpty
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        blog.authorName ?? 'Anonymous',
                                        style: FlutterFlowTheme.of(context).titleSmall,
                                      ),
                                      Text(
                                        _formatTimeAgo(blog.createdAt ?? DateTime.now()),
                                        style: FlutterFlowTheme.of(context).bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              blog.title ?? '',
                              style: FlutterFlowTheme.of(context).titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              blog.content ?? '',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    blog.isLikedBy(currentUser?.uid ?? '') 
                                        ? Icons.favorite 
                                        : Icons.favorite_border,
                                    color: blog.isLikedBy(currentUser?.uid ?? '') 
                                        ? Colors.red 
                                        : null,
                                  ),
                                  onPressed: () => _toggleLike(blog),
                                ),
                                Text('${blog.likes ?? 0}'),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: const Icon(Icons.share_outlined),
                                  onPressed: () => _shareBlog(blog),
                                ),
                                Text('${blog.shares ?? 0}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBlogForm(context),
        child: Icon(_editingBlog != null ? Icons.edit : Icons.add),
      ),
    );
  }

  void _showBlogForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _editingBlog != null ? 'Edit Blog' : 'Create New Blog',
                      style: FlutterFlowTheme.of(context).titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _resetForm();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    expands: true,
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedImage != null)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() => _selectedImage = null);
                          },
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Add Image'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : (_editingBlog != null ? _updateBlog : _createBlog),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Text(_editingBlog != null ? 'Update' : 'Publish'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBlogDetails(BuildContext context, BlogRecord blog) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (blog.imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      blog.imageUrl!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 300,
                          color: FlutterFlowTheme.of(context).alternate,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: blog.authorPic != null && blog.authorPic!.isNotEmpty
                                ? NetworkImage(blog.authorPic!)
                                : null,
                            radius: 24,
                            child: blog.authorPic == null || blog.authorPic!.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  blog.authorName ?? 'Anonymous',
                                  style: FlutterFlowTheme.of(context).titleMedium,
                                ),
                                Text(
                                  _formatTimeAgo(blog.createdAt ?? DateTime.now()),
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        blog.title ?? '',
                        style: FlutterFlowTheme.of(context).headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        blog.content ?? '',
                        style: FlutterFlowTheme.of(context).bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              blog.isLikedBy(currentUser?.uid ?? '') 
                                  ? Icons.favorite 
                                  : Icons.favorite_border,
                              color: blog.isLikedBy(currentUser?.uid ?? '') 
                                  ? Colors.red 
                                  : null,
                            ),
                            onPressed: () => _toggleLike(blog),
                          ),
                          Text('${blog.likes ?? 0}'),
                          IconButton(
                            icon: const Icon(Icons.share_outlined),
                            onPressed: () => _shareBlog(blog),
                          ),
                          Text('${blog.shares ?? 0}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    _titleController.dispose();
    _contentController.dispose();
    _searchController.dispose();
    super.dispose();
  }
} 