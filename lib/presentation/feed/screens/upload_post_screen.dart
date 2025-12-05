import 'package:flutter/foundation.dart'; // ✅ Ye zaroori hai Web check karne ke liye
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';

class UploadPostScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String userImage;

  const UploadPostScreen({
    Key? key,
    required this.userId,
    required this.username,
    required this.userImage,
  }) : super(key: key);

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final _captionController = TextEditingController();
  final _imagePicker = ImagePicker();
  XFile? _pickedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  Future<String> _uploadImageToFirebase(String imagePath) async {
    // For now, we'll use the local file path as a placeholder
    // In production, you would upload to Firebase Storage and get a download URL
    return imagePath;
  }

  void _uploadPost() async {
    if (_captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a caption')),
      );
      return;
    }

    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload image to Firebase Storage (or use local path for now)
      final imageUrl = await _uploadImageToFirebase(_pickedImage!.path);

      if (mounted) {
        context.read<FeedBloc>().add(
              UploadPostEvent(
                userId: widget.userId,
                username: widget.username,
                userImage: widget.userImage,
                postImage: imageUrl,
                caption: _captionController.text,
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        centerTitle: true,
      ),
      body: BlocListener<FeedBloc, FeedState>(
        listener: (context, state) {
          if (state is PostUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post uploaded successfully!')),
            );
            Navigator.pop(context);
          } else if (state is PostUploadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
            setState(() => _isLoading = false);
          } else if (state is PostUploadLoading) {
            setState(() => _isLoading = true);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(widget.userImage),
                    onBackgroundImageError: (_, __) {},
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${widget.userId.substring(0, 5)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Caption Input
              TextField(
                controller: _captionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),

              // Image Selection
              if (_pickedImage == null)
                GestureDetector(
                  onTap: _isLoading ? null : _pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to select image',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          // ✅ WEB FIX: Agar Web hai to Network image use karo (Blob URL)
                          ? Image.network(
                              _pickedImage!.path,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          // ✅ MOBILE FIX: Agar Mobile hai to File use karo
                          : Image.file(
                              File(_pickedImage!.path),
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                setState(() => _pickedImage = null);
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 32),

              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadPost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Upload Post',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}