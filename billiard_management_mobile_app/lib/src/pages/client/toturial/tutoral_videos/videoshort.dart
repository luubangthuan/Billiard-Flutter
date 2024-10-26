import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoShortPage extends StatefulWidget {
  @override
  _VideoShortPageState createState() => _VideoShortPageState();
}

class _VideoShortPageState extends State<VideoShortPage> {
  final List<Map<String, String>> videos = [
    {
      'title': '3 simple shots',
      'description': '',
      'url': 'https://www.youtube.com/shorts/bz6EWCLFgBs',
    },
    {
      'title': 'Learn how to play bank shot like a professional',
      'description': '',
      'url': 'https://www.youtube.com/shorts/irA54Rwvcrk',
    },
    {
      'title': 'Fantastic Pool Shot - Option 6',
      'description': '',
      'url': 'https://www.youtube.com/shorts/jaJCJ6ZpteY',
    },
    {
      'title': 'Why I Recommend Closed Bridge For Long Shots In Pool',
      'description': '',
      'url': 'https://www.youtube.com/shorts/W6JIYgiCSHI',
    },
    {
      'title': 'Mastering Billiards: Rules and Tricks',
      'description': '',
      'url': 'https://www.youtube.com/shorts/24A9FtyXh5E',
    },
    {
      'title': 'Learn Billiards: Basic Shots',
      'description': '',
      'url': 'https://www.youtube.com/shorts/YHkVNfkAo5U',
    },
    {
      'title': 'Amazing billiards tips and tricks ',
      'description': '',
      'url': 'https://www.youtube.com/shorts/lozQ8YYY8Zc',
    },
    {
      'title': 'How To Aim In Pool For Beginners',
      'description': '',
      'url': 'https://www.youtube.com/shorts/ag1syfv6KJM',
    },
    {
      'title': 'Billiards Masse Shot',
      'description': '',
      'url': 'https://www.youtube.com/shorts/78uEBzKg_dU',
    },
    {
      'title': 'Tips on how to hold a cue',
      'description': '',
      'url': 'https://www.youtube.com/shorts/nXnu1G_CH10',
    },
    {
      'title': '8ball in middle pocket',
      'description': '',
      'url': 'https://www.youtube.com/shorts/ARknpPySq7k',
    },
    {
      'title': 'Applying All Spins To Cue Ball & Increase Power For Balls Down The Rail ',
      'description': '',
      'url': 'https://www.youtube.com/shorts/-4Q7KR6rovc',
    },
    {
      'title': 'Mastering Billiards: Rules and Tricks',
      'description': '',
      'url': 'https://www.youtube.com/shorts/21JcL9gNagE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: const Text(
          "Video Shorts",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return _buildVideoPlayer(
            context,
            video['title']!,
            video['description']!,
            video['url']!,
          );
        },
      ),
    );
  }

  Widget _buildVideoPlayer(
      BuildContext context, String title, String description, String url) {
    return VideoPlayerPage(
      title: title,
      url: url,
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String title;
  final String url;

  const VideoPlayerPage({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        controlsVisibleAtStart: false,
        hideControls: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: YoutubePlayer(
              controller: _controller,
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
              showVideoProgressIndicator: false,
              onReady: () {
                _controller.play();
              },
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Swipe up for the next video',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
