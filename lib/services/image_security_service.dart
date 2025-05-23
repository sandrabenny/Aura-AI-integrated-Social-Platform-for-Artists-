import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class ImageSecurityService {
  static const double SIMILARITY_THRESHOLD = 0.90; // 90% similarity threshold
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> processImage({
    required String imageUrl,
    required String artistId,
    required String artworkId,
  }) async {
    try {
      print('Processing image for security:');
      print('  URL: $imageUrl');
      print('  Artist ID: $artistId');
      print('  Artwork ID: $artworkId');

      final response = await http.get(Uri.parse(imageUrl));
      final imageBytes = response.bodyBytes;

      // Generate robust hash
      final imageHash = _generateRobustImageHash(imageBytes);
      print('Generated image hash: $imageHash');

      // Store in artwork_security collection
      print('Storing security data in artwork_security collection...');
      await _firestore.collection('artwork_security').doc(artworkId).set({
        'artistId': artistId,
        'imageHash': imageHash,
        'timestamp': FieldValue.serverTimestamp(),
        'imageUrl': imageUrl,
      });

      // Also store in images collection for faster lookup
      print('Storing security data in images collection...');
      await _firestore.collection('images').add({
        'imageHash': imageHash,
        'artworkId': artworkId,
        'artistId': artistId,
        'timestamp': FieldValue.serverTimestamp(),
        'imageUrl': imageUrl,
      });

      print('Successfully stored image security data in both collections');
      return {
        'success': true,
        'imageHash': imageHash,
      };
    } catch (e) {
      print('Error in processImage: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  String _generateImageHash(Uint8List imageBytes) {
    // Convert to Image object
    final image = img.decodeImage(imageBytes);
    
    // Generate hash (simple implementation)
    return image.hashCode.toString();
  }

  Future<bool> _checkForDuplicate(String imageHash) async {
    final query = await _firestore
        .collection('images')
        .where('imageHash', isEqualTo: imageHash)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  Future<void> uploadImage(Uint8List imageBytes, String userId) async {
    try {
      // Generate more robust hash
      final imageHash = _generateRobustImageHash(imageBytes);
      print('Generated hash: $imageHash');

      // Check for duplicates with stricter comparison
      final duplicate = await _checkForDuplicate(imageHash);
      print('Duplicate check result: $duplicate');

      if (duplicate) {
        throw Exception('Duplicate image detected. This image has already been uploaded.');
      }

      // Upload to Firestore
      final ref = _storage.ref().child('user_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putData(imageBytes);

      // Store metadata
      await _firestore.collection('images').add({
        'userId': userId,
        'imageHash': imageHash,
        'timestamp': FieldValue.serverTimestamp(),
        'storagePath': ref.fullPath,
      });
    } catch (e) {
      print('Error in uploadImage: $e');
      rethrow;
    }
  }

  String _generateRobustImageHash(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    // Resize to consistent dimensions
    final resized = img.copyResize(image, width: 64, height: 64);
  
    // Convert to grayscale
    final grayscale = img.grayscale(resized);
  
    // Calculate average pixel value
    int total = 0;
    for (var y = 0; y < grayscale.height; y++) {
      for (var x = 0; x < grayscale.width; x++) {
        total += grayscale.getPixel(x, y).r.toInt();
      }
    }
    final average = total ~/ (grayscale.width * grayscale.height);
  
    // Generate hash based on pixel values
    final hash = StringBuffer();
    for (var y = 0; y < grayscale.height; y++) {
      for (var x = 0; x < grayscale.width; x++) {
        hash.write(grayscale.getPixel(x, y).r > average ? '1' : '0');
      }
    }

    print('Generated hash value: ${hash.toString()}');
    return hash.toString();
  }

  Future<Map<String, dynamic>> extractWatermark({
    required String imageUrl,
  }) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final imageBytes = response.bodyBytes;
      final image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('Failed to decode image');

      // Extract watermark from image
      final extractedData = _extractDCTWatermarkMultiChannel(image);

      return {
        'success': true,
        'watermarkData': extractedData,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Map<String, dynamic> _extractDCTWatermarkMultiChannel(img.Image image) {
    final width = image.width;
    final height = image.height;
    final extractedBits = <int>[];

    // Extract from multiple channels
    for (var i = 0; i < width * height; i++) {
      final x = i % width;
      final y = i ~/ width;
      if (y < height) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt() & 0x01;
        final g = (pixel.g.toInt() & 0x01) << 1;
        final b = (pixel.b.toInt() & 0x01) << 2;
        extractedBits.add(r | g | b);
      }
    }

    return _decodeWatermarkData(extractedBits);
  }

  Future<void> editPost({
    required String postId,
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    // Verify user owns the post
    final post = await _firestore.collection('posts').doc(postId).get();
    if (post['userId'] != userId) {
      throw Exception('You can only edit your own posts');
    }
  
    // Apply updates
    await _firestore.collection('posts').doc(postId).update({
      ...updates,
      'lastEdited': FieldValue.serverTimestamp(),
    });
  }
  
  Future<void> deletePost({
    required String postId,
    required String userId,
  }) async {
    // Verify user owns the post
    final post = await _firestore.collection('posts').doc(postId).get();
    if (post['userId'] != userId) {
      throw Exception('You can only delete your own posts');
    }
  
    // Archive post
    await _firestore.collection('deleted_posts').doc(postId).set({
      ...?post.data(),
      'deletedAt': FieldValue.serverTimestamp(),
    });
  
    // Remove from active posts
    await _firestore.collection('posts').doc(postId).delete();
  
    // Optionally delete associated image
    final imagePath = post['imagePath'];
    if (imagePath != null) {
      await _storage.ref(imagePath).delete();
    }
  }

  Map<String, dynamic> _decodeWatermarkData(List<int> binaryData) {
    try {
      // Convert binary data back to string
      final jsonString = utf8.decode(binaryData);
      return jsonDecode(jsonString);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to decode watermark data',
      };
    }
  }

  Map<String, dynamic> _generateInvisibleWatermark(Uint8List imageBytes, Map<String, dynamic> metadata) {
    final image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    // Convert metadata to binary
    final jsonString = jsonEncode(metadata);
    final binaryData = utf8.encode(jsonString);
    
    // Create a copy of the image to embed watermark
    final watermarked = img.Image.from(image);
    
    // Embed watermark in LSB of each channel
    for (var i = 0; i < binaryData.length; i++) {
      final x = i % watermarked.width;
      final y = i ~/ watermarked.width;
      if (y < watermarked.height) {
        final pixel = watermarked.getPixel(x, y);
        final bit = binaryData[i];
        
        // Embed in LSB of each channel
        final r = (pixel.r.toInt() & 0xFE) | (bit & 0x01);
        final g = (pixel.g.toInt() & 0xFE) | ((bit >> 1) & 0x01);
        final b = (pixel.b.toInt() & 0xFE) | ((bit >> 2) & 0x01);
        
        watermarked.setPixelRgb(x, y, r, g, b);
      }
    }

    // Return both the watermarked image and the original metadata
    return {
      'watermarkedImage': img.encodeJpg(watermarked),
      'metadata': metadata,
    };
  }

  Future<Map<String, dynamic>> checkImageForgery(String imageUrl) async {
    try {
      print('Starting forgery check for image: $imageUrl');
      final response = await http.get(Uri.parse(imageUrl));
      final imageBytes = response.bodyBytes;
      final newImageHash = _generateRobustImageHash(imageBytes);
      print('Generated hash for new image: $newImageHash');

      // Query Firestore for all existing image hashes
      print('Querying Firestore for existing hashes...');
      final querySnapshot = await _firestore
          .collection('artwork_security')
          .get();

      print('Found ${querySnapshot.docs.length} existing artworks to compare');
      
      for (var doc in querySnapshot.docs) {
        final existingHash = doc.data()['imageHash'] as String;
        final similarity = _calculateHashSimilarity(newImageHash, existingHash);
        print('Comparing with artwork ${doc.id}:');
        print('  Existing hash: $existingHash');
        print('  Similarity score: ${(similarity * 100).toStringAsFixed(2)}%');
        
        if (similarity >= SIMILARITY_THRESHOLD) {
          print('DUPLICATE DETECTED! Similarity: ${(similarity * 100).toStringAsFixed(2)}%');
          return {
            'isDuplicate': true,
            'similarityScore': similarity,
            'originalArtworkId': doc.id,
          };
        }
      }

      print('No duplicates found - image appears to be original');
      return {
        'isDuplicate': false,
        'similarityScore': 0.0,
      };
    } catch (e) {
      print('Error in checkImageForgery: $e');
      return {
        'error': e.toString(),
        'isDuplicate': false,
        'similarityScore': 0.0,
      };
    }
  }

  double _calculateHashSimilarity(String hash1, String hash2) {
    if (hash1.length != hash2.length) return 0.0;
    
    int matchingBits = 0;
    for (int i = 0; i < hash1.length; i++) {
      if (hash1[i] == hash2[i]) {
        matchingBits++;
      }
    }
    
    return matchingBits / hash1.length;
  }
}