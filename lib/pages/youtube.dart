import 'dart:math';

import 'package:flutter_news_app/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlay extends StatefulWidget {
  final String videoId;
  const YoutubePlay({super.key, required this.videoId});

  @override
  State<YoutubePlay> createState() => _YoutubePlayState();
}

class _YoutubePlayState extends State<YoutubePlay> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    )..addListener(_listener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return YoutubePlayer(
    //   controller: _controller,
    //   showVideoProgressIndicator: true,
    // );
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        if (_controller.value.isFullScreen) {
          _controller.toggleFullScreenMode();
          return false;
        }
        return true;
      },
      child: Container(
        decoration: Methods.getPageBgBoxDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _isFullScreen
              ? null
              : AppBar(
                  title: Text(''),
                ),
          body: Container(
            child: Center(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  // _controller.toggleFullScreenMode();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _listener() {
    if (_controller.value.isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = _controller.value.isFullScreen;
      });
    }
  }
}
