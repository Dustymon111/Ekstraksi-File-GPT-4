import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void generateDocx(List<Map<String, dynamic>> questions) async {
  try {
    // Load the template
    ByteData data = await rootBundle.load('assets/templates.docx');
    var bytes = data.buffer.asUint8List();

    // Create a DocxTemplate from bytes
    var docx = await DocxTemplate.fromBytes(bytes);

    if (docx == null) {
      print('Failed to load DOCX template.');
      return;
    }

    // Create a simple Content object
    Content c = Content();
    // Add questions and options
    for (int i = 0; i < questions.length; i++) {
      var question = questions[i];
      c.add(TextContent('question${i + 1}', question['question']));
      for (int j = 0; j < question['options'].length; j++) {
        // Ensure options are modifiable before adding
        c.add(TextContent('option${i + 1}${j + 1}', question['options'][j]));
      }
    }
    // Generate the document
    final docGenerated = await docx.generate(c);

    // Get the application documents directory
    final directory = Directory('/storage/emulated/0/Documents');
    String appDocPath = directory.path;

    // Create a file for the DOCX document
    final file = File('$appDocPath/sample.docx');

    // Write the document to the file
    await file.writeAsBytes(docGenerated!);

    print('Document saved at: $appDocPath/sample.docx');
  } catch (e) {
    print('Error generating DOCX file: $e');
  }
}


class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Generate DOCX File'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              List<Map<String, dynamic>> questions = [
                {
                  'question': 'What is the capital of France?',
                  'options': ['A) Paris', 'B) London', 'C) Rome', 'D) Madrid'],
                },
                {
                  'question': 'What is 2 + 2?',
                  'options': ['A) 3', 'B) 4', 'C) 5', 'D) 6'],
                },
              ];

              generateDocx(questions);
            },
            child: Text('Generate DOCX'),
          ),
        ),
      ),
    );
  }
}
