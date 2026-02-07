import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const GhamzaGame());
}

class GhamzaGame extends StatefulWidget {
  const GhamzaGame({super.key});

  @override
  State<GhamzaGame> createState() => _GhamzaGameState();
}

class _GhamzaGameState extends State<GhamzaGame> {
  bool isArabic = true;

  void toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: isArabic ? 'لعبة غمزة' : 'Ghamza Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: PlayerNamesScreen(
        isArabic: isArabic,
        onLanguageToggle: toggleLanguage,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// شاشة إدخال أسماء اللاعبين
class PlayerNamesScreen extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onLanguageToggle;

  const PlayerNamesScreen({
    super.key,
    required this.isArabic,
    required this.onLanguageToggle,
  });

  @override
  State<PlayerNamesScreen> createState() => _PlayerNamesScreenState();
}

class _PlayerNamesScreenState extends State<PlayerNamesScreen> {
  final List<String> playerNames = [];
  final TextEditingController nameController = TextEditingController();

  void addPlayer() {
    if (nameController.text.trim().isNotEmpty) {
      setState(() {
        playerNames.add(nameController.text.trim());
        nameController.clear();
      });
    }
  }

  void removePlayer(int index) {
    setState(() {
      playerNames.removeAt(index);
    });
  }

  void startGame() {
    if (playerNames.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isArabic
                ? 'لازم يكون في على الأقل لاعبين!'
                : 'You need at least 2 players!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          playerNames: playerNames,
          isArabic: widget.isArabic,
          onLanguageToggle: widget.onLanguageToggle,
        ),
      ),
    );
  }

  void showHowToPlay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HowToPlayScreen(
          isArabic: widget.isArabic,
          onLanguageToggle: widget.onLanguageToggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '😉',
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 10),
            Text(widget.isArabic ? 'لعبة غمزة' : 'Ghamza Game'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: showHowToPlay,
            tooltip: widget.isArabic ? 'طريقة اللعب' : 'How to Play',
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: widget.onLanguageToggle,
            tooltip: widget.isArabic ? 'English' : 'عربي',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              widget.isArabic ? 'أضف أسماء اللاعبين' : 'Add Player Names',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: widget.isArabic ? 'اسم اللاعب' : 'Player Name',
                      border: const OutlineInputBorder(),
                    ),
                    textAlign: widget.isArabic ? TextAlign.right : TextAlign.left,
                    onSubmitted: (_) => addPlayer(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addPlayer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: playerNames.isEmpty
                  ? Center(
                child: Text(
                  widget.isArabic ? 'لا يوجد لاعبين بعد' : 'No players yet',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: playerNames.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        playerNames[index],
                        textAlign: widget.isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(fontSize: 18),
                      ),
                      leading: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removePlayer(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}

// شاشة طريقة اللعب
class HowToPlayScreen extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onLanguageToggle;

  const HowToPlayScreen({
    super.key,
    required this.isArabic,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'طريقة اللعب' : 'How to Play'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: onLanguageToggle,
            tooltip: isArabic ? 'English' : 'عربي',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    '😉🎯',
                    style: TextStyle(fontSize: 60),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isArabic ? 'لعبة غمزة' : 'Ghamza Game',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildStep(
              '1',
              isArabic ? 'أضف أسماء اللاعبين' : 'Add Player Names',
              isArabic
                  ? 'اكتب اسم كل لاعب واضغط + أو Enter'
                  : 'Type each player\'s name and press + or Enter',
              Icons.person_add,
              Colors.blue,
            ),
            const SizedBox(height: 20),
            _buildStep(
              '2',
              isArabic ? 'ابدأ اللعبة' : 'Start the Game',
              isArabic
                  ? 'اضغط Done بعد إضافة جميع اللاعبين (لازم 2 على الأقل)'
                  : 'Press Done after adding all players (minimum 2)',
              Icons.play_circle,
              Colors.green,
            ),
            const SizedBox(height: 20),
            _buildStep(
              '3',
              isArabic ? 'شاهد رقمك' : 'See Your Number',
              isArabic
                  ? 'كل لاعب يعمل swipe لأعلى ↑ لرؤية رقمه السري'
                  : 'Each player swipes up ↑ to see their secret number',
              Icons.arrow_upward,
              Colors.purple,
            ),
            const SizedBox(height: 20),
            _buildStep(
              '4',
              isArabic ? 'القاتل' : 'The Killer',
              isArabic
                  ? 'القاتل يظهر رقمه بلون أحمر مع emoji 🎯'
                  : 'The killer\'s number appears in red with emoji 🎯',
              Icons.dangerous,
              Colors.red,
            ),
            const SizedBox(height: 20),
            _buildStep(
              '5',
              isArabic ? 'انتقل للتالي' : 'Next Player',
              isArabic
                  ? 'اضغط Next للاعب التالي، وبعد آخر لاعب اضغط Start'
                  : 'Press Next for next player, after last player press Start',
              Icons.navigate_next,
              Colors.orange,
            ),
            const SizedBox(height: 20),
            _buildStep(
              '6',
              isArabic ? 'العب!' : 'Play!',
              isArabic
                  ? 'القاتل يغمز للاعبين ليقتلهم، واللاعبون يحاولون اكتشافه!'
                  : 'The killer winks at players to eliminate them, players try to catch the killer!',
              Icons.emoji_emotions,
              Colors.pink,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.amber),
                      const SizedBox(width: 10),
                      Text(
                        isArabic ? 'ملاحظات مهمة:' : 'Important Notes:',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isArabic
                        ? '• كل رقم يُستخدم مرة واحدة فقط\n• رقم القاتل عشوائي في كل لعبة\n• لا تُظهر رقمك للآخرين!\n• اللعبة أكثر متعة مع 4 لاعبين أو أكثر'
                        : '• Each number is used only once\n• Killer number is random every game\n• Don\'t show your number to others!\n• Game is more fun with 4+ players',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
      String number,
      String title,
      String description,
      IconData icon,
      Color color,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// شاشة اللعب
class GameScreen extends StatefulWidget {
  final List<String> playerNames;
  final bool isArabic;
  final VoidCallback onLanguageToggle;

  const GameScreen({
    super.key,
    required this.playerNames,
    required this.isArabic,
    required this.onLanguageToggle,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentPlayerIndex = 0;
  bool numberRevealed = false;
  late List<int> playerNumbers;
  late int killerNumber;

  @override
  void initState() {
    super.initState();
    assignNumbers();
  }

  void assignNumbers() {
    // توزيع الأرقام بشكل عشوائي
    playerNumbers = List.generate(widget.playerNames.length, (index) => index + 1);
    playerNumbers.shuffle(Random());

    // اختيار رقم القاتل عشوائياً
    killerNumber = playerNumbers[Random().nextInt(playerNumbers.length)];
  }

  void nextPlayer() {
    setState(() {
      numberRevealed = false;
      if (currentPlayerIndex < widget.playerNames.length - 1) {
        currentPlayerIndex++;
      }
    });
  }

  void revealNumber() {
    setState(() {
      numberRevealed = true;
    });
  }

  void startGameProgress() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameInProgressScreen(
          isArabic: widget.isArabic,
          onLanguageToggle: widget.onLanguageToggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPlayer = currentPlayerIndex == widget.playerNames.length - 1;
    int currentNumber = playerNumbers[currentPlayerIndex];
    bool isKiller = currentNumber == killerNumber;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '😉',
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 10),
            Text(widget.isArabic ? 'لعبة غمزة' : 'Ghamza Game'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: widget.onLanguageToggle,
            tooltip: widget.isArabic ? 'English' : 'عربي',
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          // Swipe up (negative velocity means up)
          if (details.primaryVelocity != null && details.primaryVelocity! < -100) {
            if (!numberRevealed) {
              revealNumber();
            }
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: numberRevealed
              ? (isKiller ? Colors.red.shade50 : Colors.blue.shade50)
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.playerNames[currentPlayerIndex],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                if (!numberRevealed)
                  Column(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.isArabic
                            ? 'مرر لأعلى لرؤية رقمك'
                            : 'Swipe up to see your number',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: isKiller ? Colors.red : Colors.blue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (isKiller ? Colors.red : Colors.blue)
                                  .withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            currentNumber.toString(),
                            style: const TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (isKiller)
                        const Text(
                          '🎯',
                          style: TextStyle(fontSize: 50),
                        ),
                    ],
                  ),
                const SizedBox(height: 80),
                if (numberRevealed)
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: isLastPlayer ? startGameProgress : nextPlayer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLastPlayer ? Colors.orange : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        isLastPlayer ? 'Start ✓' : 'Next',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// شاشة اللعبة قيد التقدم
class GameInProgressScreen extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onLanguageToggle;

  const GameInProgressScreen({
    super.key,
    required this.isArabic,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '😉',
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 10),
            Text(isArabic ? 'لعبة غمزة' : 'Ghamza Game'),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: onLanguageToggle,
            tooltip: isArabic ? 'English' : 'عربي',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 120,
                color: Colors.green.shade400,
              ),
              const SizedBox(height: 40),
              Text(
                isArabic ? 'اللعبة قيد التقدم' : 'Game in Progress',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                isArabic
                    ? 'استمتعوا باللعب!'
                    : 'Enjoy the game!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerNamesScreen(
                          isArabic: isArabic,
                          onLanguageToggle: onLanguageToggle,
                        ),
                      ),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(
                    isArabic ? Icons.arrow_forward : Icons.arrow_back,
                    size: 28,
                  ),
                  label: Text(
                    isArabic ? 'العودة للقائمة' : 'Back to Player List',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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