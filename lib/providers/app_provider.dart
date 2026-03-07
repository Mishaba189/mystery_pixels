import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class PlayerProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PlayerModel? player;
  bool isLoading = false;
  int todayTotalScore = 0;
  final Random random = Random();
  int gridSize = 3;
  Set<int> revealedTiles = {};
  int get totalTiles => gridSize * gridSize;
  //images
  List<Map<String, dynamic>> levels = [

    {
      "image": "assets/img1.png",
      "answers": ["hira","hira cave","hira guha"],
      "description": "മക്കയിലെ നൂർ പാർവ്വത്തിൽ സ്ഥിതി ചെയ്യുന്ന ഗുഹയാണ് ഹിറാ ഗുഹ. "
          "മുഹമ്മദ്‌ നബി (സ്വ )ക്ക് ആദ്യമായി വഹ് യ് ലഭിച്ചത് ഈ ഗുഹയിൽ വെച്ചാണ്.",
      "hint" :"Not a palace, not a throne, but a narrow space above the City of"
          " Peace,there the journey of prophethood began. ",
      "correctAnswar":"Hira Cave",
    },
    {
      "image": "assets/img2.png",
      "answers": [ "annur" , "annoor" ,"annoor course ","anoor","peace radio annoor", "peace radio annur"],
      "description": "ഖുർആനിന്റെ വ്യവസ്ഥാപിത പഠനത്തിനായി പീസ് റേഡിയോ നടത്തുന്ന "
          "കോഴ്സ് ആണ് അന്നൂർ. ആഴത്തിലുള്ള ഖുർആൻ പഠനത്തിനായി പീസ് റേഡിയോ കോഴ്സ് "
          "ഓപ്ഷൻ ഉപയോഗിക്കാം.",
      "hint" :"“The Light” ",
      "correctAnswar":"Annoor",

    },
    {
      "image": "assets/img3.png",
      "answers": ["maqam ibrahim","maqaam ibrahim", "maqamu ibrahim",
        "makamu ibrahim","makamu ibraheem","maqamu ibraheem","maqaamu ibraheem","maqaamu ibrahim"],
      "description": "മക്കയിലെ മസ്ജിദുൽ ഹറമിൽ കഅ്ബയുടെ അടുത്തായി സ്ഥിതി ചെയ്യുന്ന ഇബ്രാഹിം "
    "നബി(അ) കഅ്ബ നിർമ്മിക്കുമ്പോൾ നിന്നിരുന്നതും അദ്ദേഹത്തിൻ്റെ കാൽപ്പാടുകൾ പതിഞ്ഞതുമായ ചരിത്രപ്രസിദ്ധമായ ശിലയാണ് മഖാം ഇബ്രാഹിം. ത്വവാഫിന"
    "് ശേഷം രണ്ട് റക്അത്ത് സുന്നത്ത് നമസ്‌കാരം ഇവിടെ നിർവഹിക്കുന്നത് സുന്നത്താണ്.",
      "hint" :"A step that shaped history ",
      "correctAnswar":"Maqam Ibrahim"

    },
    {
      "image": "assets/img4.png",
      "answers": ["thajdeed","thajdid","tajdid","tajdeed"],
      "description": "റമദാൻ മാസങ്ങളിൽ wisdom Islamic girls organisation നടത്തി വരുന്ന പോസ്റ്റർ സീരീസാണ് തജ്‌ദീത്. "
          "Wisdom girls WhatsApp ചാനലിലും മറ്റു സോഷ്യൽ മീഡിയ പ്ലാറ്റഫോമുകളിലും പോസ്റ്ററുകൾ ലഭിക്കും.",
      "hint" :"Renewal",
      "correctAnswar":"Thajdeed"

    },
    {
      "image": "assets/img5.png",
      "answers": ["bait ul muqaddas","bait ul muqadhas","masjidul aqasa"," al aqasa",
        "masjidul aqsa", "masjidhul aqusa ","masjid al aqsa", "bithul muqaddhas",
        "bait ul muqaddhas", "masjidul aksa", "masjidul akasa","baithul mukaddhas" ,
        "bithul muqaddas","bithul muqaddhas","bithul muqadhas","baithul muqadhas","masjidhul aksa" ],
      "description": "അല്ലാഹുവിനെ ആരാധിക്കുന്നതിനായി ലോകത്ത് രണ്ടാമതായി നിർമ്മിച്ച ആരാധനാലയമാണ് "
          "ഫലസ്തീനിലുള്ള മസ്ജിദുല്‍ അഖ്‌സ (ബൈതുല്‍ മുഖദ്ദസ്).ഇസ്ലാമിന്റെ ആദ്യകാലത്ത് ഖിബ്‌ല "
          "ഫലസ്തീനിലെ ബൈതുല്‍  മുഖദ്ദസ് ആയിരുന്നു.",
      "hint" :"Mi'raj",
      "correctAnswar":"Bait ul Muqaddas"
    },
    {
      "image": "assets/img6.png",
      "answers": ["reclaim"],
      "description": "Wisdom islamic girls organisation എല്ലാ മാസങ്ങളിലും നടത്തിവരുന്ന"
          " ഓൺലൈൻ പ്രോഗ്രാം ആണ് Reclaim.കാലിക പ്രസക്തവും ധാർമിക "
          "മൂല്യങ്ങൾ ഉൾക്കൊള്ളുന്നതുമായ വിവിധങ്ങളായ വിഷയങ്ങൾ reclaim പ്രോഗ്രാമിൽ ചർച്ച ചെയ്യുന്നു.",
      "hint" :"Monthly online program conducted by wisdom islamic girls organization",
      "correctAnswar":"Reclaim"
    },
    {
      "image": "assets/img7.png",
      "answers": ["zameel" , "zameel app"],
      "description": "ഇസ്‌ലാമികമായ പ്രസംഗങ്ങൾ, എഴുത്തുകൾ, അദ്കാറുകൾ, "
          "ഖുർആൻ തഫ്സീർ തുടങ്ങിയവ ഉൾകൊള്ളുന്ന ആപ്പ് ആണ് zameel app",
      "hint" :"The Soulmate ",
      "correctAnswar":"Zameel App"
    },
    {
      "image": "assets/img8.png",
      "answers": ["qvp","Quran viknjana pareeksha","Quran vikjana pareeksha"],
      "description": "റമദാനിൽ ഖുർആൻ പഠനം ലക്ഷ്യം വെച്ചുകൊണ്ട് wisdom students നടത്തുന്ന  "
          "പരീക്ഷ.കൃത്യമായ സിലബസോടു കൂടി നടത്തുന്ന qvp ഈ വർഷം മാർച്ച്‌ 8 നു ആണ് നടത്തുന്നത്.",
      "hint":"Quran Contest",
      "correctAnswar":"QVP",
      "link": "https://guide.wisdomislam.org/qvp"

    },
  ];

  List<int> revealOrder = [3, 7, 8, 1, 2, 4, 6, 5, 0];

  int currentLevel = 0;
  int score = 45;

  void startGame() {
    currentLevel = 0;
    score = 45;
    notifyListeners();
  }

  void nextLevel() {
    int endLevel = todayEndLevel();

    if (currentLevel < endLevel) {
      currentLevel++;
      score = 45;
      revealedTiles.clear();
      notifyListeners();
    }
  }

  void completeLevel() {
    todayTotalScore += score;
  }

  void revealMore() {
    if (revealedTiles.length >= totalTiles) return;

    if (score > 0) score -= 5;

    int nextTile = revealOrder[revealedTiles.length];

    revealedTiles.add(nextTile);

    notifyListeners();
  }

  bool checkAnswer(String userAnswer) {
    String answer = userAnswer.toLowerCase().trim();

    List<String> correctAnswers =
    List<String>.from(levels[currentLevel]['answers']);

    if (correctAnswers.contains(answer)) {
      revealedTiles =
          List.generate(totalTiles, (i) => i).toSet();

      notifyListeners();
      return true;
    } else {
      revealMore();

      if (revealedTiles.length == totalTiles) {
        return true;
      }

      return false;
    }
  }

  double getProgress() {
    int start = todayStartLevel();
    int end = todayEndLevel();
    int totalTodayLevels = (end - start) + 1;

    return (currentLevel - start + 1) / totalTodayLevels;
  }

  // event start date
  final DateTime eventStartDate = DateTime(2026, 3, 1);

  // reg/fetch player
  Future<void> registerOrFetchPlayer({
    required String name,
    required String place,
    required String phone,
  }) async {

    currentLevel = todayStartLevel();
    score = 45;
    todayTotalScore = 0;
    revealedTiles.clear();

    isLoading = false;
    notifyListeners();

    final docRef = _firestore.collection('players').doc(phone);
    final doc = await docRef.get();

    if (doc.exists) {
      player = PlayerModel.fromMap(doc.data()!);
    } else {
      PlayerModel newPlayer = PlayerModel(
        name: name,
        place: place,
        phone: phone,
        day1Score: 0,
        day2Score: 0,
        day3Score: 0,
        day4Score: 0,
        totalScore: 0,
      );

      await docRef.set({
        ...newPlayer.toMap(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      player = newPlayer;
    }

    isLoading = false;
    notifyListeners();
  }


  //get current day
  int getCurrentDay() {
    DateTime today = DateTime.now();
    int difference = today.difference(eventStartDate).inDays;

    if (difference < 0) return 0;

    int day = difference + 1;

    return day.clamp(1, 4);
  }



  int todayStartLevel() {
    int day = getCurrentDay();
    return ((day - 1) * 2).clamp(0, levels.length - 1);
  }

  int todayEndLevel() {
    int day = getCurrentDay();
    return ((day * 2) - 1).clamp(0, levels.length - 1);
  }
  // int todayEndLevel() {
  //   return 7;
  // }

  //save today score
  Future<void> saveTodayScore(int todayScore) async {
    if (player == null) return;

    int currentDay = getCurrentDay();

    Map<String, dynamic> updateData = {};

    updateData["day${currentDay}Score"] = todayScore;

    await _firestore
        .collection('players')
        .doc(player!.phone)
        .update(updateData);

    await calculateTotalScore();
  }

  //calculate total score
  Future<void> calculateTotalScore() async {
    if (player == null) return;

    final doc = await _firestore
        .collection('players')
        .doc(player!.phone)
        .get();

    int total =
        (doc['day1Score'] ?? 0) +
            (doc['day2Score'] ?? 0) +
            (doc['day3Score'] ?? 0) +
            (doc['day4Score'] ?? 0);

    await _firestore
        .collection('players')
        .doc(player!.phone)
        .update({"totalScore": total});

    player = PlayerModel.fromMap(doc.data()!);
    notifyListeners();
  }

  bool hasCompletedToday() {
    if (player == null) return false;

    int currentDay = getCurrentDay();

    switch (currentDay) {
      case 1:
        return player!.day1Score > 0;
      case 2:
        return player!.day2Score > 0;
      case 3:
        return player!.day3Score > 0;
      case 4:
        return player!.day4Score > 0;
      default:
        return false;
    }
  }

}


class PlayerModel {
  final String name;
  final String place;
  final String phone;
  final int day1Score;
  final int day2Score;
  final int day3Score;
  final int day4Score;
  final int totalScore;

  PlayerModel({
    required this.name,
    required this.place,
    required this.phone,
    required this.day1Score,
    required this.day2Score,
    required this.day3Score,
    required this.day4Score,
    required this.totalScore,
  });

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      name: map['name'] ?? '',
      place: map['place'] ?? '',
      phone: map['phone'] ?? '',
      day1Score: map['day1Score'] ?? 0,
      day2Score: map['day2Score'] ?? 0,
      day3Score: map['day3Score'] ?? 0,
      day4Score: map['day4Score'] ?? 0,
      totalScore: map['totalScore'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "place": place,
      "phone": phone,
      "day1Score": day1Score,
      "day2Score": day2Score,
      "day3Score": day3Score,
      "day4Score": day4Score,
      "totalScore": totalScore,
    };
  }
}




class AdminProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> players = [];
  bool isLoading = false;

  //fetch
  Future<void> fetchPlayers() async {
    isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _firestore
          .collection('players')
          .orderBy('totalScore', descending: true)
          .get();

      players = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'] ?? '-',
          'place': data['place'] ?? '-',
          'phone': data['phone'] ?? '-',
          'day1Score': data['day1Score'] ?? 0,
          'day2Score': data['day2Score'] ?? 0,
          'day3Score': data['day3Score'] ?? 0,
          'day4Score': data['day4Score'] ?? 0,
          'totalScore': data['totalScore'] ?? 0,
        };
      }).toList();
    } catch (e) {
      debugPrint("Error fetching players: $e");
      players = [];
    }

    isLoading = false;
    notifyListeners();
  }
}