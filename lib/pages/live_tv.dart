import 'package:flutter_news_app/pages/youtube.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_news_app/resources/strings.dart';
import 'package:flutter_news_app/utils/methods.dart';
import 'package:flutter/material.dart';

import '../apiservice/apiclient.dart';
import '../items/itemLiveTV.dart';
import '../models/appbar_model.dart';
import '../utils/constants.dart';

// ignore: must_be_immutable
class LiveTV extends StatelessWidget {
  bool isInternet = false;
  LiveTV({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Methods.getPageBgBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarCustom(appBarTitle: Strings.live_tv, isSettings: true),
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: FutureBuilder<ItemLiveTV?>(
            future: loadLiveTV(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                ItemLiveTV itemLiveTv = snapshot.data;
                return itemLiveTv.type == 'youtube' ? YoutubeUI(itemLiveTV: itemLiveTv) : LiveTvUI(itemLiveTV: itemLiveTv);
              } else if (snapshot.hasError) {
                if (isInternet) {
                  return Methods.getErrorEmpty(Strings.err_connecting_server);
                } else {
                  return Methods.getErrorEmpty(Strings.err_internet_not_connected);
                }
              } else {
                return CustomProgressBar();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<ItemLiveTV?> loadLiveTV() async {
    isInternet = await Methods.checkConnectivity();
    return await new ApiCLient().getLiveTV(Constants.METHOD_LIVE_TV);
  }
}

// ignore: must_be_immutable
class LiveTvUI extends StatefulWidget {
  ItemLiveTV itemLiveTV;
  LiveTvUI({super.key, required this.itemLiveTV});

  @override
  State<LiveTvUI> createState() => _LiveTvUIState();
}

class _LiveTvUIState extends State<LiveTvUI> {
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;
  double aspectRatio = 1;
  bool isVideoInitialized = false;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.itemLiveTV.url);
    videoPlayerController.initialize().then((value) {
      setState(() {
        aspectRatio = videoPlayerController.value.aspectRatio;

        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: false,
          isLive: true,
          aspectRatio: aspectRatio,
          deviceOrientationsAfterFullScreen:[DeviceOrientation.portraitUp],
        );
        isVideoInitialized = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: VisibilityDetector(
        key: Key('uniq'),
        onVisibilityChanged: (info) {
          try {
            if (info.visibleFraction == 0) {
              chewieController.pause();
            }
          } catch (e){
          }
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          isVideoInitialized
              ? AspectRatio(aspectRatio: aspectRatio, child: Chewie(controller: chewieController))
              : SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: CustomProgressBar(),
                ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.itemLiveTV.name,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Html(data: widget.itemLiveTV.description),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    chewieController.dispose();
    videoPlayerController.dispose();
  }
}

class YoutubeUI extends StatelessWidget {
  final ItemLiveTV itemLiveTV;
  const YoutubeUI({super.key, required this.itemLiveTV});

  @override
  Widget build(BuildContext context) {
    // final YoutubePlayerController _controller = YoutubePlayerController(
    //   initialVideoId: itemLiveTV.url,
    //   flags: YoutubePlayerFlags(
    //     autoPlay: true,
    //     mute: false,
    //   ),
    // );
    // controller.cueVideoById(videoId: itemLiveTV.url);
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        AspectRatio(
            aspectRatio: 16 / 9,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return YoutubePlay(videoId: itemLiveTV.url);
                }));
              },
              child: Stack(
                children: [
                  Image(
                    width: double.infinity,
                    image: NetworkImage('https://img.youtube.com/vi/' + itemLiveTV.url + '/0.jpg'),
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Icon(
                      size: 60,
                      Icons.play_circle_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            itemLiveTV.name,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Html(data: itemLiveTV.description),
      ]),
    );

    // return YoutubePlayer(
    //   controller: _controller,
    //   showVideoProgressIndicator: true,
    // );
  }
}
