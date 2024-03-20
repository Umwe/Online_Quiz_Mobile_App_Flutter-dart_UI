import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CreateQuestionScreen.dart';

class CreateQuizScreen extends StatelessWidget {
  final TextEditingController _quizNameController = TextEditingController();
  final TextEditingController _totalMarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Quiz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _quizNameController,
              decoration: InputDecoration(labelText: 'Quiz Name'),
            ),
            TextField(
              controller: _totalMarksController,
              decoration: InputDecoration(labelText: 'Total Marks'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                String quizName = _quizNameController.text.trim();
                String totalMarks = _totalMarksController.text.trim();
                if (quizName.isEmpty || totalMarks.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter quiz name and total marks.')),
                  );
                  return;
                }

                try {
                  int marks = int.parse(totalMarks);
                  Map<String, dynamic> quizData = {
                    'quizName': quizName,
                    'totalMarks': marks,
                  };

                  Uri url = Uri.parse('http://10.152.3.231:8080/quiz/savequiz');
                  final response = await http.post(
                    url,
                    body: jsonEncode(quizData),
                    headers: {'Content-Type': 'application/json'},
                  );

                  if (response.statusCode == 201) {
                    int quizId = int.parse(response.body);

                    // Print quiz data to console
                    print('Quiz ID: $quizId');
                    print('Quiz Name: $quizName');
                    print('Total Marks: $marks');

                    // Redirect to CreateQuestionScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateQuestionScreen(
                          quizId: quizId,
                          quizName: quizName,
                          totalMarks: marks,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save quiz data.')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid number for total marks.')),
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Quiz App',
    home: CreateQuizScreen(),
  ));
}
