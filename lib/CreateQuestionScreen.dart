import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateQuestionScreen extends StatefulWidget {
  final String quizName;
  final int totalMarks;
  final int quizId;

  CreateQuestionScreen({
    required this.quizName,
    required this.totalMarks,
    required this.quizId,
  });

  @override
  _CreateQuestionScreenState createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  String? _selectedOption;
  TextEditingController _questionController = TextEditingController();
  TextEditingController _marksController = TextEditingController();

  Future<void> saveQuestion() async {
    if (_selectedOption != null) {
      String marksText = _marksController.text.trim();
      if (marksText.isNotEmpty) {
        int marks = int.parse(marksText);
        Map<String, dynamic> questionData = {
          'quizId': widget.quizId,
          'questionText': _questionController.text,
          'marks': marks,
          'correctOption': _selectedOption!,
        };

        final Uri url = Uri.parse('http://10.152.3.231:8080/question/save');
        try {
          final response = await http.post(
            url,
            body: jsonEncode(questionData),
            headers: {'Content-Type': 'application/json'},
          );
          if (response.statusCode == 201) {
            // Question saved successfully, extract the question ID
            Map<String, dynamic> responseData = jsonDecode(response.body);
            int questionId = responseData['questionId'] as int;

            // Do something with the questionId, such as storing it for future use
            print('Question ID: $questionId');

            // Clear text fields and selected option
            _questionController.clear();
            _marksController.clear();
            _selectedOption = null;
          } else {
            // Show an error message if the backend request fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save question.')),
            );
          }
        } catch (e) {
          // Handle exceptions such as network errors
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error occurred. Please try again.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter marks for the question.')),
        );
      }
    } else {
      // Show error message or handle invalid input
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Question for ${widget.quizName}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: _marksController,
              decoration: InputDecoration(labelText: 'Marks'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _selectedOption,
              items: ['A', 'B', 'C', 'D'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
              decoration: InputDecoration(labelText: 'Correct Option'),
            ),
            ElevatedButton(
              onPressed: saveQuestion,
              child: Text('Save Question'),
            ),
          ],
        ),
      ),
    );
  }
}
