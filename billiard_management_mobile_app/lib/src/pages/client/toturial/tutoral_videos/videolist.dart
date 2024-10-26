import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListPage extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'title': 'Learn to Play Pool in 3 Minutes | Pool Lesson',
      'description': 'A quick tutorial on the basics of playing pool.',
      'url': 'https://youtu.be/DZEP-7mRVsA',
    },
    {
      'title': 'Mastering Billiards: Rules and Tricks',
      'description': 'Learn the rules and tricks for mastering billiards.',
      'url': 'https://youtu.be/MupHq3whI7o',
    },
    {
      'title': '5 Tips that INSTANTLY Boosted my AIMING',
      'description': 'In this video I present 5 tips that helped me become better at aiming in pool. These were all so called a-ha moments that had immidiate impact.',
      'url': 'https://www.youtube.com/watch?v=OdrBujOwJQA',
    },

    {
      'title': 'Clearing The Table Step by Step - GoPro & Ghostball',
      'description': 'What is In Sharivari Case?',
      'url': 'https://www.youtube.com/watch?v=YdiVb5mW9rg',
    },

    {
      'title': '5 pool hacks that work extremely well (in 2 minutes)',
      'description': 'In this lesson I cover 5 pool secrets that a lot of beginners and even average pool players need to here.',
      'url': 'https://www.youtube.com/watch?v=70T-ugWnarU',
    },

    {
      'title': 'Learn to Shoot The 5 Most Important Shots in Pool',
      'description': 'Learn how to use the proper spin on the five most important shots in pool.',
      'url': 'https://www.youtube.com/watch?v=Sor910-kdBU',
    },

    {
      'title': 'AIM LIKE A PRO!!! SVB Aiming Simplified!',
      'description': 'In this video we discuss shaft aiming as used by Shane Van Boening. I have found that using aiming systems can be helpful, because it helps create a solid pre-shot routine which in turn helps make your game more consistent. Let’s go over the aiming system and how to build the pre-shot routine into it.',
      'url': 'https://www.youtube.com/watch?v=-LPr4tod0Bs',
    },

    {
      'title': 'Master Your Potting Angles (The Easy Way!)',
      'description': "Today we're looking at some techniques to help you pot balls regularly and impress your mates. Stephen walks through some essential practices that help master the process for lining up a shot and ensuring it goes into the pocket. We also look at some more advanced potting techniques such as aiming with side. The GoPro POV angle makes another appearance so we can all see exactly how Stephen lines up his shots. Let us know in the comments anything that you want Stephen to do a Cue Tip on in future videos!",
      'url': 'https://www.youtube.com/watch?v=ilS_YOUpf9s',
    },

    {
      'title': 'Mastering Side Spin & Cue Ball Control: Step by Step Guide',
      'description': 'Learn how to plan your shots with the correct spin to achieve the best position for your next shot.',
      'url': 'https://www.youtube.com/watch?v=HVFAnIwyvdI',
    },

    {
      'title': 'The Proper Way To Use Hand Bridge position In Pool',
      'description': 'The Proper Way To Use Hand Bridge position In Pool',
      'url': 'https://www.youtube.com/watch?v=6k9xzeXjLD4',
    },

    {
      'title': 'Truth about aiming',
      'description': 'Aiming is a difficult topic but in this video I will explain it as easy as possible. Make you understand why aiming systems never work 100%. With my tips you will find a natural approach.',
      'url': 'https://www.youtube.com/watch?v=SOWqX0bmt3M',
    },

    {
      'title': 'Billiards Tutorial: How to Break 8 Ball in Pool',
      'description': 'Want some tips on how to be a better ball breaker? From how to rack to where to aim, I go over some of the most asked fan questions in this tutorial. ',
      'url': 'https://www.youtube.com/watch?v=_xig92Lo72M',
    },

    {
      'title': 'How to Get The Perfect Pool Stroke: Making Shots Consistently',
      'description': 'Aligning your body properly to the aiming line and applying the right stroke are the most important things to make shots consistently. Learn everything you need to know in this pool lesson!',
      'url': 'https://www.youtube.com/watch?v=QiBunV0Ba8w',
    },

    {
      'title': '5 Reasons You Are Missing Shots & How to Easily Fix It',
      'description': 'The biggest difference between really good players and amateurs is their consistency in shotmaking. Learn how to solve the five biggest mistakes you keep making in pool.',
      'url': 'https://www.youtube.com/watch?v=K_A1Tr4YcFs',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: const Text(
          "Video Tutorials",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return _buildVideoCard(
              context,
              video['title']!,
              video['description']!,
              video['url']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoCard(
    BuildContext context,
    String title,
    String description,
    String url,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(url: url),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.play_circle_fill,
              color: Colors.blue,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String url;

  const VideoPlayerPage({Key? key, required this.url}) : super(key: key);

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
      appBar: AppBar(
        title: const Text("Video Player"),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          onReady: () {
            _controller.play();
          },
        ),
      ),
    );
  }
}
