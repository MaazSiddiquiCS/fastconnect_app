import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../data/reels/datasources/reels_remote_data_source.dart';
import '../../../data/reels/repositories/reel_repository_impl.dart';
import '../../../domain/reels/usecases/get_popular_reels.dart';

import '../bloc/reel_bloc.dart';
import '../bloc/reel_event.dart';
import '../bloc/reel_state.dart';
import '../widgets/reel_item.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late final PageController _pageController;
  ReelsBloc? _bloc;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final apiClient = ApiClient(baseUrl: 'https://api.pexels.com', client: http.Client());
    final remote = ReelsRemoteDataSourceImpl(client: apiClient);
    final repo = ReelsRepositoryImpl(remote: remote);
    final usecase = GetPopularReels(repo);
    _bloc = ReelsBloc(getPopularReels: usecase, prefs: _prefs!);
    _bloc!.add(const LoadPopularReels(page: 1));
    setState(() {}); // rebuild with bloc
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_bloc == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: BlocBuilder<ReelsBloc, ReelsState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is ReelsLoading || state is ReelsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReelsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ReelsLoaded) {
            final reels = state.reels;
            return PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: reels.length,
              itemBuilder: (context, index) {
                final r = reels[index];
                final liked = state.likedIds.contains(r.id);
                return ReelItem(reel: r, isLiked: liked, onToggleLike: () {
                  _bloc!.add(ToggleLikeReel(r.id));
                });
              },
              onPageChanged: (index) {
                // simple lazy loading next page
                if (index >= reels.length - 3) {
                  final nextPage = state.page + 1;
                  _bloc!.add(LoadPopularReels(page: nextPage));
                }
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
