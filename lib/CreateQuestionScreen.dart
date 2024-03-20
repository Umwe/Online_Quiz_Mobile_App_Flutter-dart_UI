import 'package:flutter/material.dart';

class CreateQuestionScreen extends StatefulWidget {
  final String quizName;
  final int totalMarks;
  final int quizId; // Add quizId as a parameter

  CreateQuestionScreen({
    required this.quizName,
    required this.totalMarks,
    required this.quizId, // Include quizId in the constructor
  });

  @override
  _CreateQuestionScreenState createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  String? _selectedOption;
  TextEditingController _questionController = TextEditingController();
  TextEditingController _marksController = TextEditingController(); // Controller for marks field
  TextEditingController _optionAController = TextEditingController();
  TextEditingController _optionBController = TextEditingController();
  TextEditingController _optionCController = TextEditingController();
  TextEditingController _optionDController = TextEditingController();

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
            TextField(
              controller: _optionAController,
              decoration: InputDecoration(labelText: 'Option A'),
            ),
            TextField(
              controller: _optionBController,
              decoration: InputDecoration(labelText: 'Option B'),
            ),
            TextField(
              controller: _optionCController,
              decoration: InputDecoration(labelText: 'Option C'),
            ),
            TextField(
              controller: _optionDController,
              decoration: InputDecoration(labelText: 'Option D'),
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
              onPressed: () async {
                // Save question and correct option
                if (_selectedOption != null) {
                  String questionText = _questionController.text;
                  String marksText = _marksController.text.trim();
                  if (questionText.isNotEmpty && marksText.isNotEmpty) {
                    int marks = int.parse(marksText);
                    Map<String, dynamic> questionData = {
                      'quizId': widget.quizId,
                      'questionText': questionText,
                      'marks': marks,
                    };

                    // Call API to save question
                    final questionResponse = await saveQuestion(questionData);
                    int questionId = questionResponse['questionId'] as int;

                    // Now save the answer with the retrieved questionId
                    Map<String, dynamic> answerData = {
                      'questionId': questionId,
                      'optionA': _optionAController.text,
                      'optionB': _optionBController.text,
                      'optionC': _optionCController.text,
                      'optionD': _optionDController.text,
                      'correctOptionIndex': ['A', 'B', 'C', 'D'].indexOf(_selectedOption!),
                    };

                    // Call API to save answer
                    final answerResponse = await saveAnswer(answerData);
                    // Handle success or error responses if needed
                  } else {
                    // Show error message for empty fields
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields.')),
                    );
                  }
                } else {
                  // Show error message or handle invalid input
                }
              },
              child: Text('Add Question'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> saveQuestion(Map<String, dynamic> questionData) async {
    // Implement logic to send HTTP POST request to save question
    // For example:
    // final response = await http.post(Uri.parse('your_api_endpoint'), body: jsonEncode(questionData));
    // Handle response and return data or throw an error
    return {'questionId': 123}; // Dummy data, replace with actual response
  }

  Future<Map<String, dynamic>> saveAnswer(Map<String, dynamic> answerData) async {
    // Implement logic to send HTTP POST request to save answer
    // For example:
    // final response = await http.post(Uri.parse('your_api_endpoint'), body: jsonEncode(answerData));
    // Handle response and return data or throw an error
    return {'answerId': 456}; // Dummy data, replace with actual response
  }
}
