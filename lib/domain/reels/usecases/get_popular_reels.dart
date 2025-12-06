import '../entities/reel.dart';
import '../repositories/reel_repository.dart';

class GetPopularReels {
  final ReelsRepository repository;
  GetPopularReels(this.repository);

  Future<List<Reel>> call({int page = 1, int perPage = 12}) {
    return repository.fetchPopular(page: page, perPage: perPage);
  }
}
