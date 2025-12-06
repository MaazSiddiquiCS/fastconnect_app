import '../../../domain/reels/entities/reel.dart';

class ReelModel extends Reel {
  const ReelModel({
    required int id,
    required String videoUrl,
    required String thumbnail,
    required String userName,
    required int width,
    required int height,
  }) : super(id: id, videoUrl: videoUrl, thumbnail: thumbnail, userName: userName, width: width, height: height);

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    // json corresponds to Pexels video object
    // Find best MP4 progressive video (file_type may be 'video/mp4' or file link ends with .mp4)
    String selectedUrl = '';
    try {
      final files = (json['video_files'] as List<dynamic>?) ?? [];
      if (files.isNotEmpty) {
        // Pick the file with largest width (best quality) that is mp4
        files.sort((a, b) => ((b['width'] ?? 0) as int).compareTo((a['width'] ?? 0) as int));
        final file = files.firstWhere((f) {
          final type = (f['file_type'] ?? '').toString().toLowerCase();
          final link = (f['link'] ?? '').toString();
          return type.contains('mp4') || link.endsWith('.mp4');
        }, orElse: () => files.first);
        selectedUrl = file['link'] ?? '';
      }
    } catch (_) {
      selectedUrl = '';
    }

    String thumb = '';
    try {
      final pictures = (json['video_pictures'] as List<dynamic>?) ?? [];
      if (pictures.isNotEmpty) thumb = pictures.first['picture'] ?? '';
    } catch (_) {}

    final userName = (json['user'] != null ? (json['user']['name'] ?? '') : '');

    return ReelModel(
      id: json['id'] ?? 0,
      videoUrl: selectedUrl,
      thumbnail: thumb,
      userName: userName,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}
