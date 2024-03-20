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
                // Trim text before validation
                String quizName = _quizNameController.text.trim();
                String totalMarks = _totalMarksController.text.trim();

                // Validate trimmed text
                if (quizName.isNotEmpty && totalMarks.isNotEmpty) {
                  try {
                    int marks = int.parse(totalMarks);
                    // Prepare the quiz data to send to the backend
                    Map<String, dynamic> quizData = {
                      'quizName': quizName,
                      'totalMarks': marks,
                    };

                    // Send an HTTP POST request to save the quiz data
                    Uri url = Uri.parse('http://10.152.3.231:8080/quiz/savequiz');
                    final response = await http.post(
                      url,
                      body: jsonEncode(quizData),
                      headers: {'Content-Type': 'application/json'},
                    );

                    if (response.statusCode == 201) {
                      // Parse the response body to get the quizId
                      Map<String, dynamic> responseData = jsonDecode(response.body);
                      int quizId = responseData['quizId'];

                      // Navigate to the CreateQuestionScreen with quizId
                      Navigator.push(
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
                      // Show an error message if the backend request fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save quiz data.')),
                      );
                    }
                  } catch (e) {
                    // Handle invalid input (non-numeric) for total marks
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid number for total marks.')),
                    );
                  }
                } else {
                  // Show an error message if quiz name or total marks is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter quiz name and total marks.')),
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
