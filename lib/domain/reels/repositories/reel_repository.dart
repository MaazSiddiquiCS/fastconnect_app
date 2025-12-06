
import '../entities/reel.dart';

abstract class ReelsRepository {
  /// Fetch popular reels; throws Failure on error
  Future<List<Reel>> fetchPopular({int page = 1, int perPage = 12});
}
