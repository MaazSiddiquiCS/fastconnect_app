import 'package:flutter/material.dart';
import '../../../domain/profile/entities/profile.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final VoidCallback onEditCover;
  final VoidCallback onEditProfile;

  const ProfileHeader({
    Key? key,
    required this.profile,
    required this.onEditCover,
    required this.onEditProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cover Photo
        Stack(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: (profile.coverPicUrl != null && profile.coverPicUrl!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(profile.coverPicUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (profile.coverPicUrl == null || profile.coverPicUrl!.isEmpty)
                  ? Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey[600]),
                    )
                  : null,
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: FloatingActionButton.small(
                onPressed: onEditCover,
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Profile Picture and Info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Profile Picture
              Stack(
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
                    child: FloatingActionButton.small(
                      onPressed: onEditProfile,
                      child: const Icon(Icons.camera_alt, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.roleType,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    if (profile.bio != null && profile.bio!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          profile.bio!,
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}