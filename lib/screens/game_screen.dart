import 'dart:ui' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';


class GameScreen extends StatelessWidget {
  GameScreen({super.key});

  final TextEditingController answerController =
  TextEditingController();



  @override
  Widget build(BuildContext context) {


    final provider = context.watch<PlayerProvider>();
    final player = provider.player;
    int start = provider.todayStartLevel();
    int end = provider.todayEndLevel();
    int displayLevel = provider.currentLevel - provider.todayStartLevel() + 1;

    if (provider.currentLevel < start || provider.currentLevel > end) {
      provider.currentLevel = start;
    }

    // if (player == null) {
    //   return const Scaffold(
    //     body: Center(child: Text("Please restart with your registered phone number")),
    //   );
    // }


    int currentDay = provider.getCurrentDay();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Level $displayLevel",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Day $currentDay Challenge",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius:
                      BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Score: ${provider.score}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              //progress
              ClipRRect(
                borderRadius:
                BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: provider.getProgress(),
                  minHeight: 10,
                  backgroundColor:
                  const Color(0xFFE0E0E0),
                  valueColor:
                  const AlwaysStoppedAnimation(
                      Colors.orangeAccent),
                ),
              ),

              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(CupertinoIcons.lightbulb,size: 18,
                        color: Colors.black),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.levels[provider.currentLevel]["hint"],
                        style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),

              //image
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double size = constraints.maxWidth;

                    return Center(
                      child: Container(
                        color: Colors.white,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final boardSize = constraints.maxWidth;
                              final tileSize = boardSize / provider.gridSize;

                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: provider.gridSize,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 0,
                                ),
                                itemCount: provider.totalTiles,
                                itemBuilder: (context, index) {
                                  final row = index ~/ provider.gridSize;
                                  final col = index % provider.gridSize;

                                  if (!provider.revealedTiles.contains(index)) {
                                    return Container(color: Colors.black);
                                  }

                                  return ClipRect(
                                    child: SizedBox(
                                      width: tileSize,
                                      height: tileSize,
                                      child: OverflowBox(
                                        maxWidth: boardSize,
                                        maxHeight: boardSize,
                                        alignment: Alignment.topLeft,
                                        child: Transform.translate(
                                          offset: Offset(
                                            -col * tileSize,
                                            -row * tileSize,
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              provider.levels[provider.currentLevel]["image"],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  hintText: "Enter your guess...",
                  prefixIcon:
                  const Icon(Icons.edit_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {

                    String userInput = answerController.text.trim();
                    if (userInput.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter your answer"),
                          backgroundColor: Colors.black,
                        ),
                      );
                      return;
                    }

                    bool isCorrect = provider.checkAnswer(userInput);

                    if (isCorrect) {
                      await Future.delayed(const Duration(milliseconds: 600));
                      provider.completeLevel();
                      showLevelCompleteDialog(context);
                    }

                    answerController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Check Answer",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showLevelCompleteDialog(BuildContext context) {
  final provider = context.read<PlayerProvider>();

  int todayEndLevel = provider.todayEndLevel();

  bool isLastLevelToday =
      provider.currentLevel >= todayEndLevel;

  String? levelLink =
  provider.levels[provider.currentLevel]["link"];

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "Correct Answer : ${provider.levels[provider.currentLevel]["correctAnswar"]}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            provider.levels[provider.currentLevel]["description"],
          ),
          if (levelLink != null) ...[
            const SizedBox(height: 12),

            GestureDetector(
              onTap: () async {
            final Uri url = Uri.parse(levelLink);

            if (await canLaunchUrl(url)) {
            await launchUrl(url);
            } else {
            print("Could not launch $url");
            }
            },
              child: Text("For registration : $levelLink",style: const TextStyle(
                color: Colors.blue,
              ),),
            )
          ],
          if (isLastLevelToday) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade100,
                    Colors.orange.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        "Your Total Score",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${provider.todayTotalScore}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD57C00),
                    ),
                  ),
                ],
              ),
            ),
          ]
          ]
        ,
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {



            if (isLastLevelToday) {
              await provider.saveTodayScore(
                  provider.todayTotalScore);

              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, "/", (route) => false);

              provider.todayTotalScore = 0;


            } else {
              provider.nextLevel();
              Navigator.pop(context);
            }
          },
          child: Text(
              isLastLevelToday ? "Finish" : "Next Level"),
        ),
      ],
    ),
  );
}