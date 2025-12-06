import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../domain/reels/entities/reel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReelItem extends StatefulWidget {
  final Reel reel;
  final bool isLiked;
  final VoidCallback onToggleLike;

  const ReelItem({
    Key? key,
    required this.reel,
    required this.isLiked,
    required this.onToggleLike,
  }) : super(key: key);

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.reel.videoUrl)
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isReady = true;
            _controller.play();
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        // video
        if (_isReady)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          )
        else if (widget.reel.thumbnail.isNotEmpty)
          CachedNetworkImage(
            imageUrl: widget.reel.thumbnail,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (c, s) => Container(color: theme.colorScheme.surface),
            errorWidget: (c, s, e) => Container(color: theme.colorScheme.surface),
          )
        else
          Container(color: theme.colorScheme.surface),

        // bottom gradient and controls
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Row(
              children: [
                // left: user info
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.reel.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('@${widget.reel.userName.replaceAll(' ', '').toLowerCase()}', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                // right: like button
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: widget.onToggleLike,
                      icon: Icon(widget.isLiked ? Icons.favorite : Icons.favorite_border),
                      color: widget.isLiked ? Colors.redAccent : Colors.white,
                      iconSize: 34,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
