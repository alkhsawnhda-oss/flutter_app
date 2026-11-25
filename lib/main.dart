import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'screens/quiz_page.dart';

final AudioPlayer player = AudioPlayer();
final FlutterTts tts = FlutterTts();

/// لغة التطبيق الحالية — مشتركة بين كل الصفحات
/// false = عربي   |   true = English
final ValueNotifier<bool> languageNotifier = ValueNotifier<bool>(false);

/// تبديل اللغة من أي مكان في التطبيق
void toggleLanguage() {
  languageNotifier.value = !languageNotifier.value;
}

Future speak(String text, {bool isEnglish = false}) async {
  await tts.stop();
  await tts.setLanguage(isEnglish ? "en-US" : "ar-SA");
  await tts.setSpeechRate(isEnglish ? 0.45 : 0.5);
  await tts.setPitch(1);
  await tts.speak(text);
}

class Place {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final String descriptionEn;
  final String videoUrl;
  final String imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.descriptionEn,
    required this.videoUrl,
    required this.imageUrl,
  });

  String getName(bool isEnglish) => isEnglish ? nameEn : name;

  String getDescription(bool isEnglish) =>
      isEnglish ? descriptionEn : description;
}

final List<Place> jordanData = [
  Place(
    id: '1',
    name: "البتراء",
    nameEn: "Petra",
    description:
        "البتراء هي مدينة أثرية وردية منحوتة في الصخر، تقع في جنوب الأردن (وادي موسى)، بناها الأنباط العرب في القرن الرابع قبل الميلاد (حوالي 312 ق.م) لتكون عاصمة مملكتهم، واشتهروا بنحت المعابد والمقابر في الجبال وتطوير نظام مائي هندسي مذهل. تُعد إحدى عجائب الدنيا السبع الجديدة وموقعاً للتراث العالمي لليونسكو",
    descriptionEn:
        "Petra is an ancient rose-red city carved into the rock, located in southern Jordan (Wadi Musa). It was built by the Arab Nabataeans in the 4th century BC (around 312 BC) to be the capital of their kingdom. They were famous for carving temples and tombs into the mountains and for developing an amazing engineered water system. It is one of the New Seven Wonders of the World and a UNESCO World Heritage Site.",
    videoUrl: "https://www.youtube.com/watch?v=5Bdi__qG7Fc",
    imageUrl:
        "https://upload.wikimedia.org/wikipedia/commons/3/30/Petra_%2C_Al-Khazneh_2.jpg",
  ),
  Place(
    id: '2',
    name: "جرش",
    nameEn: "Jerash",
    description:
        "تأسست مدينة جرش (جراسا القديمة) في القرن الرابع قبل الميلاد على يد اليونانيين، وتحديداً في عهد الإسكندر الأكبر وقواده، لتكون مركزاً تجارياً وحضارياً هاماً. شهدت المدينة عصوراً هيلينستية (يونانية) مبكرة، ثم ازدهرت بشكل هائل لاحقاً كإحدى مدن حلف الديكابوليس العشر تحت الحكم الروماني. ",
    descriptionEn:
        "The city of Jerash (ancient Gerasa) was founded in the 4th century BC by the Greeks, specifically during the era of Alexander the Great and his commanders, to be an important commercial and cultural center. The city witnessed early Hellenistic (Greek) periods, then flourished enormously later as one of the ten cities of the Decapolis under Roman rule.",
    videoUrl: "https://www.youtube.com/watch?v=vBISBLDRqpE",
    imageUrl:
        "https://cdn.alweb.com/thumbs/jordanencyclopedia/article/fit710x532/%D9%83%D9%84-%D9%85%D8%A7-%D9%8A%D9%87%D9%85%D9%83-%D8%AD%D9%88%D9%84-%D8%A2%D8%AB%D8%A7%D8%B1-%D8%AC%D8%B1%D8%B4.jpg",
  ),
  Place(
    id: '3',
    name: "وادي رم",
    nameEn: "Wadi Rum",
    description:
        "وادي رم المعروف بـوادي القمر لشدة تشابه تضاريسه مع سطح المريخ وهو محمية طبيعية وصحراء ساحرة جنوب الأردن (على بعد 300 كم من عمان)  ويتميز بجبال شاهقة من الحجر الرملي و رمال حمراء ونقوش أثرية تعود لـ 12,000 عام وهو موقع تراث عالمي لليونسكو ويشتهر بسياحة المغامرات والتخييم وتصوير الأفلام العالمية.",
    descriptionEn:
        "Wadi Rum, known as the Valley of the Moon because its terrain so closely resembles the surface of Mars, is a nature reserve and a magical desert in southern Jordan (about 300 km from Amman). It features towering sandstone mountains, red sands and ancient inscriptions dating back 12,000 years. It is a UNESCO World Heritage Site and is famous for adventure tourism, camping and filming international movies.",
    videoUrl: "https://www.youtube.com/watch?v=ZJ6fQhE4pcY",
    imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEb0SveMc-O5K-ZF_wEGCcjaFhgcduuFjznQ&s",
  ),
  Place(
    id: '4',
    name: "مأدبا مدينة الفسيفساء",
    nameEn: "Madaba, the City of Mosaics",
    description:
        "مادبا، الملقبة بـمدينة الفسيفساء وعاصمة السياحة العربية لعام 2022 وهي مدينة أردنية تاريخية تشتهر بكنوزها البيزنطية والأموية وأبرزها خارطة مادبا الفسيفسائية للأراضي المقدسة (القرن السادس) في كنيسة القديس جورج وتضم أفضل مراكز تعليم الفسيفساء وتتميز بمواقع سياحية دينية وتاريخية مثل جبل نيبو ومكاور وحمامات ماعين.",
    descriptionEn:
        "Madaba, nicknamed the City of Mosaics and the Arab Tourism Capital for 2022, is a historic Jordanian city famous for its Byzantine and Umayyad treasures, most notably the Madaba Mosaic Map of the Holy Land (6th century) in the Church of St. George. It hosts the best mosaic schools and centers and features religious and historical sites such as Mount Nebo, Machaerus and the Ma'in hot springs.",
    videoUrl: "https://www.youtube.com/watch?v=L4b1xp-mJi4",
    imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzJnymn9qgRnHg6bhSBvpSHTheqooze13TOQ&s",
  ),
  Place(
    id: '5',
    name: "أم قيس",
    nameEn: "Umm Qais",
    description:
        "أم قيس (جدارا قديماً) هي مدينة أثرية أردنية تاريخية تقع شمالي محافظة إربد وتشتهر بإطلالتها الفريدة على نهر اليرموك وبحيرة طبريا وهضبة الجولان  كانت إحدى مدن الديكابولس العشر  واشتهرت كمركز ثقافي للحكماء والشعراء.",
    descriptionEn:
        "Umm Qais (ancient Gadara) is a historic Jordanian archaeological city located in the north of Irbid Governorate. It is famous for its unique view over the Yarmouk River, the Sea of Galilee and the Golan Heights. It was one of the ten cities of the Decapolis and was known as a cultural center for philosophers and poets.",
    videoUrl: "https://www.youtube.com/watch?v=0JbqdHbrV4M",
    imageUrl:
        "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/13/bc/f4/ef/wwwyes-jordancom.jpg?w=1400&h=1400&s=1",
  ),
  Place(
    id: '6',
    name: "قلعة الكرك",
    nameEn: "Karak Castle",
    description:
        "قلعة الكرك هي حصن صليبي منيع يقع في مدينة الكرك بالأردن (120 كم جنوب عمان)، بناها الصليبيون في القرن الثاني عشر (حوالي 1142م) لتعزيز سيطرتهم على الطريق المؤدي للقدس. تمتاز بهندسة عسكرية معقدة، وقد تم تطويرها عبر العصور الأيوبية والمملوكية، وتشتهر بكونها قلعة حصينة جداً ومعلماً تاريخياً وثقافياً بارزاً في المنطقة.",
    descriptionEn:
        "Karak Castle is a mighty Crusader fortress located in the city of Karak in Jordan (120 km south of Amman). It was built by the Crusaders in the 12th century (around 1142 AD) to strengthen their control over the road leading to Jerusalem. It features complex military architecture and was developed through the Ayyubid and Mamluk eras. It is famous for being a very strong fortress and a prominent historical and cultural landmark in the region.",
    videoUrl: "https://www.youtube.com/watch?v=BvFfPK1fo_E",
    imageUrl:
        "https://cdn.alweb.com/thumbs/travel/article/fit710x532/%D8%AA%D8%B9%D8%B1%D9%81-%D8%A3%D9%83%D8%AB%D8%B1-%D8%B9%D9%84%D9%89-%D9%82%D9%84%D8%B9%D8%A9-%D8%A7%D9%84%D9%83%D8%B1%D9%83-%D8%A7%D9%84%D8%A3%D8%AB%D8%B1%D9%8A%D8%A9-%D9%81%D9%8A-%D8%A7%D9%84%D8%A3%D8%B1%D8%AF%D9%86.jpg",
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEnglish, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 159, 19, 9),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 51, 100, 47),
            ),
          ),
          builder: (context, child) => Directionality(
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          ),
          home: const WelcomeScreen(),
        );
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEnglish, _) {
        return Scaffold(
          body: Stack(
            children: [
              Container(color: Colors.white),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isEnglish ? "Welcome to Jordan" : "أهلاً بك في الأردن",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      },
                      child: Text(
                        isEnglish ? "Start Journey" : "ابدأ الرحلة",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.language, size: 30),
                  onPressed: toggleLanguage,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int userRating = 0;
  bool _showThanks = false;
  bool _ratingDone = false;
  Timer? _thanksTimer;

  void _onRate(int index) {
    setState(() {
      userRating = index + 1;
      _showThanks = true;
    });

    _thanksTimer?.cancel();

    _thanksTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _showThanks = false;
        _ratingDone = true;
      });
    });
  }

  @override
  void dispose() {
    _thanksTimer?.cancel();
    super.dispose();
  }

  Widget buildStar(int index) {
    return IconButton(
      onPressed: () => _onRate(index),
      icon: Icon(
        index < userRating ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEnglish, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(isEnglish ? "Discover Jordan" : "اكتشف الأردن"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.language),
                onPressed: toggleLanguage,
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizPage(
                          language: languageNotifier,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.quiz, color: Colors.white),
                  label: Text(
                    isEnglish ? "Open Quiz" : "افتح صفحة الاختبار",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              if (!_ratingDone)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: _showThanks
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            isEnglish
                                ? "Thanks for your rating!"
                                : "شكراً لتقييمك",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 12, 7, 6),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) => buildStar(index),
                          ),
                        ),
                ),
              if (!_ratingDone) SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: jordanData.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 7 / 8,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (ctx, i) => PlaceItem(
                    place: jordanData[i],
                    isEnglish: isEnglish,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PlaceItem extends StatelessWidget {
  final Place place;
  final bool isEnglish;

  const PlaceItem({
    required this.place,
    required this.isEnglish,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(place),
        ),
      ),
      borderRadius: BorderRadius.circular(15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.network(
                place.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                place.getName(isEnglish),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Place place;

  const DetailScreen(this.place, {super.key});

  void _launchVideo() async {
    final url = Uri.parse(place.videoUrl);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEnglish, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(place.getName(isEnglish)),
            actions: [
              IconButton(
                icon: Icon(Icons.volume_up),
                onPressed: () {
                  speak(
                    place.getName(isEnglish),
                    isEnglish: isEnglish,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.language),
                onPressed: toggleLanguage,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  place.imageUrl,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEnglish ? "About:" : "عن المعلم:",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        place.getDescription(isEnglish),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () {
                          speak(
                            place.getDescription(isEnglish),
                            isEnglish: isEnglish,
                          );
                        },
                        icon: Icon(Icons.volume_up),
                        label: Text(
                          isEnglish
                              ? "Listen to the description"
                              : "استماع للوصف",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 11, 38, 59),
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: _launchVideo,
                        icon: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                        ),
                        label: Text(
                          isEnglish
                              ? "Watch Official Video"
                              : "شاهد الفيديو الرسمي",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
