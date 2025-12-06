import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/failure.dart';
import '../../../domain/reels/usecases/get_popular_reels.dart';
import '../../../domain/reels/entities/reel.dart';
import 'reel_event.dart';
import 'reel_state.dart';

class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final GetPopularReels getPopularReels;
  final SharedPreferences prefs;
  static const String likedKey = 'liked_reels';

  ReelsBloc({required this.getPopularReels, required this.prefs}) : super(ReelsInitial()) {
    on<LoadPopularReels>(_onLoadPopularReels);
    on<ToggleLikeReel>(_onToggleLikeReel);
  }

  Future<void> _onLoadPopularReels(LoadPopularReels event, Emitter<ReelsState> emit) async {
    emit(ReelsLoading());
    try {
      final reels = await getPopularReels.call(page: event.page);
      final likedSet = _loadLikedSet();
      emit(ReelsLoaded(reels: reels, likedIds: likedSet, page: event.page));
    } catch (e) {
      if (e is Failure) {
        emit(ReelsError(e.message));
      } else {
        emit(ReelsError(e.toString()));
      }
    }
  }

  Future<void> _onToggleLikeReel(ToggleLikeReel event, Emitter<ReelsState> emit) async {
    final stateNow = state;
    if (stateNow is! ReelsLoaded) return;
    final currentLikes = Set<int>.from(stateNow.likedIds);
    if (currentLikes.contains(event.reelId)) {
      currentLikes.remove(event.reelId);
    } else {
      currentLikes.add(event.reelId);
    }
    await prefs.setStringList(likedKey, currentLikes.map((e) => e.toString()).toList());
    emit(ReelsLoaded(reels: stateNow.reels, likedIds: currentLikes, page: stateNow.page));
  }

  Set<int> _loadLikedSet() {
    final list = prefs.getStringList(likedKey) ?? [];
    return list.map((s) => int.tryParse(s) ?? -1).where((v) => v != -1).toSet();
  }
}
