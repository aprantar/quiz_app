
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CalculatorScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QuizScreen(),
  ));
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  SharedPreferences? sharedPreferences;
  int highestScore = 0;
  int quizNumber = 1;
  int questionIndex = 0;
  int score = 0;
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  void initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      highestScore = sharedPreferences?.getInt('highestScore') ?? 0;
    });
  }

  void updateHighestScore() async {
    final currentScore = await sharedPreferences?.getInt('highestScore');
    if (currentScore != null) {
      if (score > currentScore) {
        await sharedPreferences?.setInt('highestScore', score);
        setState(() {
          highestScore = score;
        });
      }
    } else {
      await sharedPreferences?.setInt('highestScore', score);
      setState(() {
        highestScore = score;
      });
    }
  }

  List<String> questions = [
    'What is the capital of France?',
    'Who painted the Mona Lisa?',
    'What is the largest planet in our solar system?',
    'How many continents are there in the world?',
    'What is the largest mammal?',
    'Which gas do plants absorb from the atmosphere?',
    'Who wrote the play "Romeo and Juliet"?',
    'What is the chemical symbol for gold?',
    'What is the largest ocean in the world?',
    'What is the tallest mountain on Earth?',
    'What is the primary function of the heart?',
    'Which planet is known as the Red Planet?',
    'What is the powerhouse of the cell?',
    'Which gas makes up the majority of Earth\'s atmosphere?',
    'In which year did Christopher Columbus discover America?',
    'Which famous scientist developed the theory of relativity?',
    'What is the largest desert in the world?',
    'How many players are there on a standard soccer team?',
    'Which element is the most abundant in the Earth',
    'Who is known as the "Father of Modern Physics"?',
  ];

  List<List<String>> options = [
    ['Paris', 'London', 'Madrid', 'Rome'],
    ['Leonardo da Vinci', 'Pablo Picasso', 'Vincent van Gogh', 'Claude Monet'],
    ['Saturn', 'Mars', 'Earth', 'Jupiter'],
    ['5', '6', '7', '8'],
    ['Elephant', 'Giraffe', 'Blue Whale', 'Hippopotamus'],
    ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
    ['William Shakespeare', 'Charles Dickens', 'Jane Austen', 'Mark Twain'],
    ['Au', 'Ag', 'Fe', 'Hg'],
    ['Pacific Ocean', 'Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean'],
    ['Mount Kilimanjaro', 'Mount Everest', 'Mount Fuji', 'Mount McKinley'],
    ['Pumping blood', 'Digesting food', 'Storing memories', 'Breathing'],
    ['Mars', 'Venus', 'Earth', 'Jupiter'],
    ['Mitochondria', 'Nucleus', 'Chloroplast', 'Ribosome'],
    ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
    ['1492', '1507', '1601', '1776'],
    ['Albert Einstein', 'Isaac Newton', 'Stephen Hawking', 'Marie Curie'],
    ['Sahara Desert', 'Arabian Desert', 'Antarctica', 'Gobi Desert'],
    ['11', '10', '9', '12'],
    ['Oxygen', 'Silicon', 'Iron', 'Aluminum'],
    ['Albert Einstein', 'Isaac Newton', 'Stephen Hawking', 'Marie Curie'],
  ];

  List<String> correctAnswers = ['Paris', 'Leonardo da Vinci', 'Jupiter''7', 'Blue Whale', 'Carbon Dioxide',
    'William Shakespeare', 'Au', 'Pacific Ocean', 'Mount Everest', 'Pumping blood',
    'Mars', 'Mitochondria', 'Nitrogen', '1492', 'Albert Einstein', 'Sahara Desert', '11', 'Oxygen', 'Albert Einstein',
  ];

  List<String> selectedAnswers = [];

  void checkAnswer(String selectedOption) {
    if (isAnswered) {
      return; // Prevent multiple answer selections
    }

    String correctAnswer = correctAnswers[questionIndex];
    bool isCorrect = selectedOption == correctAnswer;

    setState(() {
      selectedAnswers.add(selectedOption);
      isAnswered = true;

      if (isCorrect) {
        score++;
        sharedPreferences?.setInt('highestScore', score);
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        if (questionIndex < questions.length - 1) {
          questionIndex++;
          isAnswered = false;
        } else {
          // Quiz completed, perform any desired actions
        }
      });
    });
  }

  void shareScore() {
    String message =
        'I scored $score out of ${questions.length} in the quiz app!';
    Share.share(message);
  }

  void resetQuiz() {
    setState(() {
      selectedAnswers.clear();
      questionIndex = 0;
      quizNumber++;
      score = 0;
      isAnswered = false;
    });
  }

  void updateHighScore() {
    if (score > highestScore) {
      setState(() {
        highestScore = score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App by Aprantar'),
        backgroundColor: Colors.pinkAccent.shade200,
        centerTitle: true,
        elevation: 10,
      ),
      body: Column(
        children: [
          Text(
            'Question ${questionIndex + 1}: ${questions[questionIndex]}',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              backgroundColor: Colors.purpleAccent
            ),
          ),
          SizedBox(height: 40),
          ListView.builder(
            shrinkWrap: true,
            itemCount: options[questionIndex].length,
            itemBuilder: (context, index) {
              bool isSelected =
              selectedAnswers.contains(options[questionIndex][index]);
              bool isCorrect = options[questionIndex][index] ==
                  correctAnswers[questionIndex];
              bool showCorrectAnswer = isAnswered && isCorrect;

              Color backgroundColor = Colors.transparent;
              if (isSelected) {
                backgroundColor = isCorrect ? Colors.green : Colors.red;
              } else if (showCorrectAnswer) {
                backgroundColor = Colors.lightGreenAccent;
              }

              return GestureDetector(
                onTap: () {
                  if (!isSelected) {
                    checkAnswer(options[questionIndex][index]);
                  }
                },
                child: Container(
                  color: backgroundColor,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + index)}.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        options[questionIndex][index],
                        style: TextStyle(
                          color: isSelected || showCorrectAnswer
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Text(
            'Score: $score / ${questions.length}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: shareScore,
          ),
          IconButton(
            icon: Icon(Icons.calculate),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalculatorScreen()),
              );
            },
          ),
          SizedBox(height: 20),
          if (selectedAnswers.contains(correctAnswers[questionIndex]))
            Text(
              'Correct Answer: ${correctAnswers[questionIndex]}',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          Text(
            'Highest Score: $highestScore', // Display the highestScore variable
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          updateHighScore();
          resetQuiz();
        },
        child: Text('Next Quiz'),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(16),
        color: Colors.grey[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quiz $quizNumber', // Display the current quiz number
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'High Score: $highestScore', // Display the high score
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
