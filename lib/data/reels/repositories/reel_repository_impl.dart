import '../../../core/utils/failure.dart';
import '../../../domain/reels/entities/reel.dart';
import '../../../domain/reels/repositories/reel_repository.dart';
import '../datasources/reels_remote_data_source.dart';

class ReelsRepositoryImpl implements ReelsRepository {
  final ReelsRemoteDataSource remote;

  ReelsRepositoryImpl({required this.remote});

  @override
  Future<List<Reel>> fetchPopular({int page = 1, int perPage = 12}) async {
    try {
      final models = await remote.fetchPopular(page: page, perPage: perPage);
      return models;
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(e.toString());
    }
  }
}
