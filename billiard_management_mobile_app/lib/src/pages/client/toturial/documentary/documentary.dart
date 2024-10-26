import 'package:flutter/material.dart';

class DocumentaryPage extends StatelessWidget {
  final List<Map<String, String>> documentaries = [
    {
      'title': 'The Origins of Billiards',
      'description':
          'Explore the fascinating history of billiards, from its medieval beginnings to the modern-day competitive sport.',
      'duration': '45 minutes',
      'focus': 'History of the sport',
    },
    {
      'title': 'Legends of the Game',
      'description':
          'A tribute to the greatest billiard players of all time and their journeys.',
      'duration': '50 minutes',
      'focus': 'Player biographies',
    },
    {
      'title': 'Billiards: Techniques and Strategies',
      'description':
          'Learn advanced techniques and strategies used by professional players.',
      'duration': '40 minutes',
      'focus': 'Techniques and strategies',
    },
    {
      'title': 'The Art of Trick Shots',
      'description':
          'Discover the art behind some of the most mesmerizing trick shots performed by billiard masters.',
      'duration': '35 minutes',
      'focus': 'Trick shots',
    },
    {
      'title': 'Women in Billiards: Breaking the Mold',
      'description':
          'A look into the lives of the most influential women in the billiards world and their contributions to the sport.',
      'duration': '48 minutes',
      'focus': 'Women players',
    },
    {
      'title': 'The Science Behind Billiards',
      'description':
          'An in-depth look at the physics and geometry that define billiard gameplay.',
      'duration': '42 minutes',
      'focus': 'Physics of billiards',
    },
    {
      'title': 'Champion Mindset: The Mental Game of Billiards',
      'description':
          'Explore the mental strategies and focus required by top billiard champions.',
      'duration': '38 minutes',
      'focus': 'Mental strategies',
    },
    {
      'title': 'The Evolution of Pool Tables',
      'description':
          'A documentary on how pool tables have evolved over the centuries.',
      'duration': '30 minutes',
      'focus': 'Equipment evolution',
    },
    {
      'title': 'Billiards Around the World',
      'description':
          'A cultural journey exploring how billiards is played and celebrated in different countries.',
      'duration': '60 minutes',
      'focus': 'International billiards',
    },
    {
      'title': 'Inside the World of Professional Billiards',
      'description':
          'A behind-the-scenes look at professional billiard tournaments and players.',
      'duration': '55 minutes',
      'focus': 'Professional scene',
    },
    {
      'title': 'Pool Halls: A Historical Perspective',
      'description':
          'The history and significance of pool halls in various cultures.',
      'duration': '35 minutes',
      'focus': 'Cultural impact',
    },
    {
      'title': 'Billiard Innovations: From Chalk to Cues',
      'description':
          'An exploration of the technological innovations in billiard equipment over time.',
      'duration': '37 minutes',
      'focus': 'Technological advances',
    },
    {
      'title': 'Famous Billiard Tournaments',
      'description':
          'A look at some of the most iconic billiard tournaments and their history.',
      'duration': '52 minutes',
      'focus': 'Tournaments',
    },
    {
      'title': 'The Psychology of a Billiard Champion',
      'description':
          'How players develop the mindset needed to compete at the highest level.',
      'duration': '33 minutes',
      'focus': 'Psychological training',
    },
    {
      'title': 'Pool Cues: Craftsmanship and Precision',
      'description':
          'The craftsmanship involved in creating high-quality pool cues.',
      'duration': '44 minutes',
      'focus': 'Equipment and craftsmanship',
    },
    {
      'title': 'The Rise of Billiards in America',
      'description':
          'How billiards became one of America\'s favorite pastimes.',
      'duration': '49 minutes',
      'focus': 'Cultural history',
    },
    {
      'title': 'Famous Trick Shots and Their Creators',
      'description':
          'A documentary showcasing some of the most impressive trick shots in billiards.',
      'duration': '36 minutes',
      'focus': 'Trick shots',
    },
    {
      'title': 'Pool Hall Stories: Tales from the Tables',
      'description':
          'Stories from iconic pool halls and the players who made them famous.',
      'duration': '47 minutes',
      'focus': 'Cultural tales',
    },
    {
      'title': 'The Art of the Break Shot',
      'description':
          'Mastering the break shot, one of the most crucial aspects of the game.',
      'duration': '31 minutes',
      'focus': 'Technique',
    },
    {
      'title': 'Famous Rivalries in Billiard History',
      'description':
          'The most intense rivalries between the world\'s best billiard players.',
      'duration': '43 minutes',
      'focus': 'Player rivalries',
    },
    {
      'title': 'How Billiard Balls Are Made',
      'description':
          'A deep dive into the manufacturing and design process of billiard balls.',
      'duration': '32 minutes',
      'focus': 'Manufacturing process',
    },
    {
      'title': 'Training Like a Pro: Inside a Billiard Academy',
      'description':
          'An inside look at how professional players train and prepare for tournaments.',
      'duration': '50 minutes',
      'focus': 'Professional training',
    },
    {
      'title': 'Billiard Legends: The Greatest Matches Ever Played',
      'description':
          'Relive some of the greatest matches in the history of billiards.',
      'duration': '55 minutes',
      'focus': 'Historic matches',
    },
    {
      'title': 'From Amateur to Pro: The Journey of a Billiard Player',
      'description':
          'The journey and challenges faced by amateur players aspiring to become pros.',
      'duration': '46 minutes',
      'focus': 'Player development',
    },
    {
      'title': 'The Future of Billiards',
      'description':
          'What lies ahead for the sport of billiards as it adapts to modern technology and trends.',
      'duration': '42 minutes',
      'focus': 'Future of the sport',
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
          "Documentaries",
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
          itemCount: documentaries.length,
          itemBuilder: (context, index) {
            final doc = documentaries[index];
            return _buildDocumentaryCard(
              context,
              doc['title']!,
              doc['description']!,
              doc['duration']!,
              doc['focus']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDocumentaryCard(
    BuildContext context,
    String title,
    String description,
    String duration,
    String focus,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.book,
                color: Colors.blue,
                size: 40,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.timer,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Duration: $duration',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.category,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Focus: $focus',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
