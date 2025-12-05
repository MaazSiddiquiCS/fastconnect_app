# Feed Post Upload Feature - Implementation Guide

## Overview
Complete post upload functionality has been added to your Feed module with:
- Image selection from device gallery
- Post caption input
- Firestore integration for storing posts
- Real-time upload state management
- User feedback (success/error messages)

## Components Created

### 1. **Use Case Layer** (`domain/feed/usecases/upload_post.dart`)
- `UploadPost` - Business logic for uploading posts
- Accepts: userId, username, userImage, postImage, caption
- Returns: FeedPost entity on success

### 2. **Data Layer Updates**

#### Repository Interface (`domain/feed/repositories/feed_repository.dart`)
```dart
Future<FeedPost> uploadPost({
  required String userId,
  required String username,
  required String userImage,
  required String postImage,
  required String caption,
});
```

#### Remote Data Source (`data/feed/datasources/feed_remote_data_source.dart`)
- Firestore integration
- Creates new post document in 'posts' collection
- Automatically sets: id, createdAt, likes: 0, comments: 0, likedBy: []

#### Repository Implementation (`data/feed/repositories/feed_repository_impl.dart`)
- Converts models to entities
- Error handling

### 3. **Presentation Layer**

#### BLoC Events (`presentation/feed/bloc/feed_event.dart`)
```dart
class UploadPostEvent extends FeedEvent {
  final String userId;
  final String username;
  final String userImage;
  final String postImage;
  final String caption;
}
```

#### BLoC States (`presentation/feed/bloc/feed_state.dart`)
- `PostUploadLoading` - Upload in progress
- `PostUploadSuccess` - Upload complete
- `PostUploadError` - Upload failed

#### Upload Screen (`presentation/feed/screens/upload_post_screen.dart`)
Complete UI with:
- User profile info display
- Caption text input (5 lines)
- Image picker from gallery
- Image preview with remove button
- Upload button with loading indicator
- Error/success feedback

#### Feed Screen Updates (`presentation/feed/screens/feed_screen.dart`)
- Floating Action Button to navigate to upload screen
- Wraps content in Scaffold for FAB support

### 4. **Dependency Injection** (`core/di/service_locator.dart`)
- UploadPost use case registered
- FeedBloc updated with uploadPost dependency

## Usage

### From Feed Screen
```dart
// Click the floating action button (camera icon) in the bottom-right
// or programmatically:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const UploadPostScreen(
      userId: 'user_id',
      username: 'John Doe',
      userImage: 'https://example.com/image.jpg',
    ),
  ),
);
```

### From Code
```dart
// Trigger upload via BLoC
context.read<FeedBloc>().add(
  UploadPostEvent(
    userId: 'user_123',
    username: 'John Doe',
    userImage: 'https://example.com/john.jpg',
    postImage: '/path/to/image.jpg',
    caption: 'This is my post!',
  ),
);
```

## Firestore Data Structure

Posts are stored in the 'posts' collection with this structure:
```json
{
  "id": "auto-generated-by-firestore",
  "userId": "user_id",
  "username": "John Doe",
  "userImage": "https://example.com/john.jpg",
  "postImage": "/local/path/or/storage/url",
  "caption": "This is my post!",
  "likes": 0,
  "comments": 0,
  "createdAt": "2024-12-06T10:30:00.000Z",
  "likedBy": []
}
```

## Important Notes

### Image Handling
Currently, the upload screen uses local file paths. For production:
1. Implement Firebase Storage integration
2. Upload image to Firebase Storage
3. Get download URL
4. Store URL in Firestore instead of local path

### User Authentication
Update `UploadPostScreen` constructor calls to use actual logged-in user data:
```dart
// Get current user from auth
final user = context.read<AuthBloc>().state;
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UploadPostScreen(
      userId: user.userId,        // from auth
      username: user.username,    // from auth
      userImage: user.profileImage, // from auth
    ),
  ),
);
```

### Firestore Permissions
Ensure your Firestore rules allow authenticated users to create posts:
```javascript
match /posts/{postId} {
  allow read: if true;
  allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
  allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
}
```

## Error Handling

The upload feature handles:
- Empty caption
- No image selected
- Firestore upload errors
- Network errors

All errors are displayed via SnackBar with user-friendly messages.

## Next Steps

1. **Firebase Storage Integration**
   - Upload images to Firebase Storage
   - Replace local paths with storage download URLs

2. **User Profile Integration**
   - Link upload screen to logged-in user's info
   - Replace placeholder userId/username/userImage

3. **Image Compression**
   - Compress images before upload for better performance
   - Add image quality selection

4. **Tags & Mentions**
   - Allow users to mention other students
   - Add hashtag support

5. **Post Editing**
   - Allow users to edit captions
   - Image replacement

## Files Modified/Created

### Created:
- `lib/domain/feed/usecases/upload_post.dart`
- `lib/presentation/feed/screens/upload_post_screen.dart`

### Modified:
- `lib/domain/feed/repositories/feed_repository.dart`
- `lib/data/feed/datasources/feed_remote_data_source.dart`
- `lib/data/feed/repositories/feed_repository_impl.dart`
- `lib/presentation/feed/bloc/feed_event.dart`
- `lib/presentation/feed/bloc/feed_state.dart`
- `lib/presentation/feed/bloc/feed_bloc.dart`
- `lib/presentation/feed/screens/feed_screen.dart`
- `lib/core/di/service_locator.dart`

## Testing

1. Run the app: `flutter run -d chrome`
2. Navigate to Feed tab
3. Click camera button (FAB)
4. Select an image from gallery
5. Enter a caption
6. Click "Upload Post"
7. Post should appear at top of feed after refresh

## Troubleshooting

**Problem**: Upload button disabled
- Ensure caption is not empty
- Ensure image is selected
- Check for Firestore permission errors in console

**Problem**: Image not loading in upload screen
- Verify local path is correct
- Check file exists on device
- Ensure image_picker has permissions (iOS/Android)

**Problem**: Post not appearing in feed
- Refresh feed manually
- Check Firestore console for document creation
- Verify userId in Firestore security rules
