import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/feed/entities/feed_post.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';
import '../widgets/post_tile.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as feed_widgets;
import '../widgets/empty_widget.dart';
import 'upload_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late ScrollController _scrollController;
  int _currentOffset = 0;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<FeedBloc>().add(
      const FetchFeedPosts(limit: _pageSize, offset: 0),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMorePosts();
    }
  }

  void _loadMorePosts() {
    _currentOffset += _pageSize;
    context.read<FeedBloc>().add(
      FetchFeedPosts(limit: _pageSize, offset: _currentOffset),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _currentOffset = 0;
          context.read<FeedBloc>().add(const RefreshFeed());
        },
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedLoading && _currentOffset == 0) {
              return const LoadingWidget();
            } else if (state is FeedError) {
              return feed_widgets.FeedErrorWidget(
                message: state.message,
                onRetry: () {
                  _currentOffset = 0;
                  context.read<FeedBloc>().add(
                    const FetchFeedPosts(limit: _pageSize, offset: 0),
                  );
                },
              );
            } else if (state is FeedLoaded) {
              if (state.posts.isEmpty && _currentOffset == 0) {
                return const EmptyWidget();
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: state.posts.length +
                    (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index < state.posts.length) {
                    return PostTile(post: state.posts[index]);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            }
            return const LoadingWidget();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to upload screen
          // Note: You'll need to pass user info - for now using placeholder values
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UploadPostScreen(
                userId: 'current_user_id',
                username: 'Current User',
                userImage: 'https://via.placeholder.com/150',
              ),
            ),
          );
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
