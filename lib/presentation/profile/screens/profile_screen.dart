import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/profile/entities/profile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _bioCtrl;
  late TextEditingController _rollNumberCtrl;
  late TextEditingController _departmentCtrl;
  String? _currentUserId;
  String? _fullName;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _bioCtrl = TextEditingController();
    _rollNumberCtrl = TextEditingController();
    _departmentCtrl = TextEditingController();
    
    final user = FirebaseAuth.instance.currentUser;
    _currentUserId = user?.uid;
    _fullName = user?.displayName ?? 'User';
    
    if (_currentUserId != null && !_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProfileBloc>().add(GetProfileDetails(userId: _currentUserId!));
      });
    }
  }

  @override
  void dispose() {
    _bioCtrl.dispose();
    _rollNumberCtrl.dispose();
    _departmentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadProfilePicture() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && _currentUserId != null) {
      context.read<ProfileBloc>().add(
        UploadProfilePictureEvent(userId: _currentUserId!, filePath: image.path),
      );
    }
  }

  Future<void> _pickAndUploadCoverPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && _currentUserId != null) {
      context.read<ProfileBloc>().add(
        UploadCoverPhotoEvent(userId: _currentUserId!, filePath: image.path),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully'), backgroundColor: Colors.green),
            );
          } else if (state is UploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.type} photo uploaded successfully'),
                backgroundColor: Colors.green,
              ),
            );
            if (_currentUserId != null) {
              Future.delayed(const Duration(seconds: 1), () {
                context.read<ProfileBloc>().add(GetProfileDetails(userId: _currentUserId!));
              });
            }
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          Profile? profile;
          if (state is ProfileLoaded) {
            profile = state.profile;
          } else if (state is ProfileUpdateSuccess) {
            profile = state.profile;
          } else if (state is UploadSuccess) {
            return const SizedBox.shrink();
          }

          if (profile != null) {
            _bioCtrl.text = profile.bio ?? '';
            _rollNumberCtrl.text = profile.rollNumber ?? '';
            _departmentCtrl.text = profile.department ?? '';
            return _buildProfileForm(profile);
          }

          if (state is ProfileInitial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No profile data'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentUserId != null) {
                        context.read<ProfileBloc>().add(GetProfileDetails(userId: _currentUserId!));
                      }
                    },
                    child: const Text('Load Profile'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildProfileForm(Profile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Photo Section
          GestureDetector(
            onTap: _pickAndUploadCoverPhoto,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                image: (profile.coverPicUrl != null && profile.coverPicUrl!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(profile.coverPicUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (profile.coverPicUrl == null || profile.coverPicUrl!.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 48, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text('Tap to upload cover photo', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),

          // Profile Picture Section
          Center(
            child: GestureDetector(
              onTap: _pickAndUploadProfilePicture,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: (profile.profilePicUrl != null && profile.profilePicUrl!.isNotEmpty)
                        ? NetworkImage(profile.profilePicUrl!)
                        : null,
                    child: (profile.profilePicUrl == null || profile.profilePicUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Full Name (loaded from auth, read-only)
          TextFormField(
            initialValue: _fullName,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          const SizedBox(height: 12),

          // Email (read-only)
          TextFormField(
            initialValue: profile.email,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          const SizedBox(height: 12),

          // Role Type (read-only)
          TextFormField(
            initialValue: profile.roleType,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Role Type',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          const SizedBox(height: 12),

          // Roll Number (editable if student)
          TextFormField(
            controller: _rollNumberCtrl,
            decoration: InputDecoration(
              labelText: 'Roll Number',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 12),

          // Department (editable if faculty)
          TextFormField(
            controller: _departmentCtrl,
            decoration: InputDecoration(
              labelText: 'Department',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 12),

          // Bio (editable)
          TextFormField(
            controller: _bioCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final updatedProfile = profile.copyWith(
                  bio: _bioCtrl.text,
                  rollNumber: _rollNumberCtrl.text,
                  department: _departmentCtrl.text,
                );
                context.read<ProfileBloc>().add(UpdateProfileDetails(profile: updatedProfile));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Save Profile', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}