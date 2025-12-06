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
        context.read<ProfileBloc>().add(
              GetProfileDetails(userId: _currentUserId!),
            );
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
            UploadProfilePictureEvent(
              userId: _currentUserId!,
              filePath: image.path,
            ),
          );
    }
  }

  Future<void> _pickAndUploadCoverPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && _currentUserId != null) {
      context.read<ProfileBloc>().add(
            UploadCoverPhotoEvent(
              userId: _currentUserId!,
              filePath: image.path,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // <- your requirement

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          } else if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Profile updated successfully"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is UploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${state.type} uploaded successfully"),
                backgroundColor: Colors.green,
              ),
            );
            if (_currentUserId != null) {
              Future.delayed(const Duration(milliseconds: 600), () {
                context.read<ProfileBloc>().add(
                      GetProfileDetails(userId: _currentUserId!),
                    );
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
          }

          if (profile != null) {
            _bioCtrl.text = profile.bio ?? '';
            _rollNumberCtrl.text = profile.rollNumber ?? '';
            _departmentCtrl.text = profile.department ?? '';

            return _buildProfileForm(context, theme, profile);
          }

          return const Center(child: Text("No profile data"));
        },
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context, ThemeData theme, Profile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // -------------------------------------------
          //                   COVER PHOTO
          // -------------------------------------------
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                  image: (profile.coverPicUrl?.isNotEmpty ?? false)
                      ? DecorationImage(
                          image: NetworkImage(profile.coverPicUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),

              // Add button (never removed)
              Positioned(
                right: 12,
                bottom: 12,
                child: GestureDetector(
                  onTap: _pickAndUploadCoverPhoto,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.primary,
                    child: Icon(
                      Icons.add,
                      size: 22,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // -------------------------------------------
          //               PROFILE PICTURE
          // -------------------------------------------
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  backgroundImage: (profile.profilePicUrl?.isNotEmpty ?? false)
                      ? NetworkImage(profile.profilePicUrl!)
                      : null,
                  child: (profile.profilePicUrl == null ||
                          profile.profilePicUrl!.isEmpty)
                      ? Icon(Icons.person,
                          size: 55, color: theme.colorScheme.outline)
                      : null,
                ),

                // Add button on profile pic
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickAndUploadProfilePicture,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.add,
                        size: 22,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // -------------------------------------------
          //           READ-ONLY FIELDS
          // -------------------------------------------
          _readonlyField("Full Name", _fullName ?? "", theme),
          const SizedBox(height: 12),
          _readonlyField("Email", profile.email ?? "", theme),
          const SizedBox(height: 12),
          _readonlyField("Role Type", profile.roleType ?? "", theme),
          const SizedBox(height: 20),

          // -------------------------------------------
          //            EDITABLE FIELDS
          // -------------------------------------------
          _editableField("Roll Number", _rollNumberCtrl, theme),
          const SizedBox(height: 12),
          _editableField("Department", _departmentCtrl, theme),
          const SizedBox(height: 12),
          _editableField("Bio", _bioCtrl, theme, maxLines: 3),
          const SizedBox(height: 22),

          // -------------------------------------------
          //             SAVE BUTTON
          // -------------------------------------------
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final updated = profile.copyWith(
                  bio: _bioCtrl.text.trim(),
                  rollNumber: _rollNumberCtrl.text.trim(),
                  department: _departmentCtrl.text.trim(),
                );
                context.read<ProfileBloc>().add(
                      UpdateProfileDetails(profile: updated),
                    );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Save Profile", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------
  //              UI HELPER WIDGETS
  // -------------------------------------------

  Widget _readonlyField(String label, String value, ThemeData theme) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _editableField(String label, TextEditingController ctrl, ThemeData theme,
      {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
