# Feed Upload Feature - Quick Start Guide

## 🎯 One-Minute Overview

Your Feed now has **full post upload functionality**! Users can:
- Pick images from device gallery
- Write captions
- Upload posts to Firestore
- See posts in real-time feed

## 🚀 Quick Start (3 steps)

### 1. Update Firestore Security Rules
Go to Firebase Console → Firestore → Rules tab and update:

```javascript
match /posts/{postId} {
  allow read: if true;
  allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
  allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
}
```

### 2. Run Your App
```bash
flutter run -d chrome
```

### 3. Test Upload
- Go to Feed tab
- Click **camera button** (FAB)
- Select image
- Enter caption
- Click Upload

Done! ✅

---

## 📱 UI Components

### Upload Screen
Located at: `lib/presentation/feed/screens/upload_post_screen.dart`

**Features:**
- User profile display
- Caption input (multi-line)
- Image picker from gallery
- Image preview with remove button
- Upload button with loading indicator

### Feed Screen Update
Located at: `lib/presentation/feed/screens/feed_screen.dart`

**Changes:**
- Added Floating Action Button (camera icon)
- Wrapped in Scaffold for FAB support
- Navigates to UploadPostScreen

---

## 🏗️ Architecture

```
FeedScreen (camera FAB)
    ↓
UploadPostScreen (UI)
    ↓
UploadPostEvent (BLoC)
    ↓
FeedBloc (state management)
    ↓
UploadPost UseCase (business logic)
    ↓
FeedRepository (interface)
    ↓
FeedRemoteDataSource (Firestore)
    ↓
Firestore Database
```

---

## 📝 Code Example

**Navigate to upload screen:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const UploadPostScreen(
      userId: 'user_123',
      username: 'John Doe',
      userImage: 'https://example.com/john.jpg',
    ),
  ),
);
```

**Listen to upload state:**
```dart
BlocListener<FeedBloc, FeedState>(
  listener: (context, state) {
    if (state is PostUploadSuccess) {
      print('Post uploaded!');
    } else if (state is PostUploadError) {
      print('Error: ${state.message}');
    }
  },
  child: // your widget
)
```

---

## 🔑 Key Files

| File | Purpose |
|------|---------|
| `upload_post_screen.dart` | Upload UI |
| `feed_bloc.dart` | Upload event handler |
| `feed_event.dart` | UploadPostEvent |
| `feed_state.dart` | Upload states |
| `upload_post.dart` | Use case |
| `feed_remote_data_source.dart` | Firestore upload |

---

## ⚠️ Important Notes

### Current Limitations
1. **Local File Paths** - Uses device path, not cloud storage
   - Should implement Firebase Storage integration

2. **Placeholder User Data** - Uses hardcoded values
   - Should link to authenticated user from AuthBloc

3. **No Compression** - Full-size images uploaded
   - Should add image compression for performance

### Production TODO
- [ ] Integrate Firebase Storage
- [ ] Get user data from AuthBloc
- [ ] Add image compression
- [ ] Add input validation
- [ ] Add retry mechanism

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Upload button disabled | Enter caption + select image |
| Permission denied error | Update Firestore rules (see above) |
| Image not showing | Ensure image format supported |
| Post not in feed | Check Firestore console |

---

## 🧪 Testing Checklist

- [ ] App runs without errors
- [ ] Camera FAB visible in feed
- [ ] Can select image from gallery
- [ ] Can enter caption
- [ ] Upload button shows loading
- [ ] Success message appears
- [ ] Navigates back to feed
- [ ] New post visible in feed
- [ ] Error shows when caption empty
- [ ] Error shows when no image selected

---

## 📚 Full Documentation

For detailed docs, see:
- `FEED_UPLOAD_FEATURE.md` - Complete implementation guide
- `FEED_UPLOAD_COMPLETE.md` - Architecture breakdown

---

## 💡 Next Steps

1. **Test Upload** - Follow "Quick Start" steps above
2. **Link Auth** - Update userId/username from AuthBloc
3. **Firebase Storage** - Upload images to storage
4. **Enhance** - Add filters, cropping, tags

---

## ✅ Status

- ✅ Upload UI complete
- ✅ BLoC integration done
- ✅ Firestore connection ready
- ✅ Error handling implemented
- ✅ Loading states included
- ⏳ Firebase Storage (next phase)
- ⏳ Auth integration (next phase)

**You're ready to test!** 🚀
