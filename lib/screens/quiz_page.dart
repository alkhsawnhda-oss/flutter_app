import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class Question {
  final String questionArabic;
  final String questionEnglish;
  final List<String> answersArabic;
  final List<String> answersEnglish;
  final int correctIndex;

  Question({
    required this.questionArabic,
    required this.questionEnglish,
    required this.answersArabic,
    required this.answersEnglish,
    required this.correctIndex,
  });
}

class QuizPage extends StatefulWidget {
  final ValueListenable<bool> language;

  const QuizPage({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Question> questions = [
    Question(
      questionArabic: "أين تقع البتراء؟",
      questionEnglish: "Where is Petra located?",
      answersArabic: ["معان", "إربد", "العقبة", "الزرقاء"],
      answersEnglish: ["Ma'an", "Irbid", "Aqaba", "Zarqa"],
      correctIndex: 0,
    ),
    Question(
      questionArabic: "من بنى البتراء؟",
      questionEnglish: "Who built Petra?",
      answersArabic: ["الرومان", "الأنباط", "اليونان", "الفرس"],
      answersEnglish: [
        "The Romans",
        "The Nabataeans",
        "The Greeks",
        "The Persians"
      ],
      correctIndex: 1,
    ),
    Question(
      questionArabic: "جرش مدينة؟",
      questionEnglish: "Jerash is a...?",
      answersArabic: ["حديثة", "أثرية", "صناعية", "زراعية"],
      answersEnglish: [
        "Modern city",
        "Archaeological city",
        "Industrial city",
        "Agricultural city"
      ],
      correctIndex: 1,
    ),
    Question(
      questionArabic: "وادي رم يسمى؟",
      questionEnglish: "Wadi Rum is also called?",
      answersArabic: ["وادي الشمس", "وادي القمر", "وادي النجوم", "وادي الرمال"],
      answersEnglish: [
        "Valley of the Sun",
        "Valley of the Moon",
        "Valley of the Stars",
        "Valley of the Sands"
      ],
      correctIndex: 1,
    ),
    Question(
      questionArabic: "مادبا مشهورة بـ؟",
      questionEnglish: "What is Madaba famous for?",
      answersArabic: ["الفسيفساء", "الذهب", "الفضة", "الحديد"],
      answersEnglish: ["Mosaics", "Gold", "Silver", "Iron"],
      correctIndex: 0,
    ),
    Question(
      questionArabic: "قلعة الكرك هي؟",
      questionEnglish: "Karak Castle is a...?",
      answersArabic: [
        "قلعة رومانية",
        "قلعة صليبية",
        "قلعة يونانية",
        "قلعة فارسية"
      ],
      answersEnglish: [
        "Roman castle",
        "Crusader castle",
        "Greek castle",
        "Persian castle"
      ],
      correctIndex: 1,
    ),
  ];

  int currentQuestion = 0;
  int score = 0;
  bool answered = false;
  int? selectedIndex;

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> answer(int index) async {
    if (answered) return;

    setState(() {
      answered = true;
      selectedIndex = index;
    });

    final isCorrect = index == questions[currentQuestion].correctIndex;

    if (isCorrect) {
      score++;

      try {
        await audioPlayer.play(AssetSource('correct.mp3'));
      } catch (e) {
        debugPrint("Audio error: $e");
      }
    } else {
      try {
        await audioPlayer.play(AssetSource('error.mp3'));
      } catch (e) {
        debugPrint("Audio error: $e");
      }
    }

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        answered = false;
        selectedIndex = null;
      });
    } else {
      showResult();
    }
  }

  void restartQuiz() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      answered = false;
      selectedIndex = null;
    });
  }

  void showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ValueListenableBuilder<bool>(
          valueListenable: widget.language,
          builder: (context, english, child) {
            return AlertDialog(
              title: Text(
                english ? "Quiz Completed" : "نهاية الاختبار",
                textAlign: TextAlign.center,
              ),
              content: Text(
                english
                    ? "Well done! Your score is:\n$score out of ${questions.length}"
                    : "أحسنت! نتيجتك هي:\n$score من ${questions.length}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        restartQuiz();
                      },
                      child: Text(
                        english ? "Try Again" : "إعادة المحاولة",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.pop(this.context);
                      },
                      child: Text(
                        english ? "Exit" : "خروج",
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.language,
      builder: (context, english, child) {
        final q = questions[currentQuestion];
        final questionText = english ? q.questionEnglish : q.questionArabic;
        final answers = english ? q.answersEnglish : q.answersArabic;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              english
                  ? "Test Your Historical Knowledge"
                  : "اختبر معلوماتك التاريخية",
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 188, 51, 51),
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 160, 160, 160),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: (currentQuestion + 1) / questions.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    english
                        ? "Question ${currentQuestion + 1} of ${questions.length}"
                        : "السؤال ${currentQuestion + 1} من ${questions.length}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    questionText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ...List.generate(
                    answers.length,
                    (index) {
                      final isCorrect = index == q.correctIndex;
                      final isSelected = selectedIndex == index;

                      Color bgColor = Colors.white;
                      Color textColor = Colors.black87;

                      if (answered) {
                        if (isCorrect) {
                          bgColor = Colors.green;
                          textColor = Colors.white;
                        } else if (isSelected) {
                          bgColor = Colors.red;
                          textColor = Colors.white;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ElevatedButton(
                          onPressed: () => answer(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgColor,
                            foregroundColor: textColor,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                          ),
                          child: Text(
                            answers[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        english
                            ? "Current Score: $score"
                            : "النقاط الحالية: $score",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(
                            255,
                            181,
                            63,
                            63,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
