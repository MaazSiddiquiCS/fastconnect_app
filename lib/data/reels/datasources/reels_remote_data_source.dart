import '../../../core/network/api_client.dart';
import '../models/reel_model.dart';

abstract class ReelsRemoteDataSource {
  Future<List<ReelModel>> fetchPopular({int page = 1, int perPage = 12});
}

class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final ApiClient client;

  ReelsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ReelModel>> fetchPopular({int page = 1, int perPage = 12}) async {
    final json = await client.get('/videos/popular', params: {
      'per_page': perPage.toString(),
      'page': page.toString(),
    });

    final videos = (json['videos'] as List<dynamic>?) ?? [];
    return videos.map((v) => ReelModel.fromJson(v as Map<String, dynamic>)).toList();
  }
}
