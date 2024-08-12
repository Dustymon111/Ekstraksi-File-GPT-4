import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:docx_template/docx_template.dart';
import 'dart:io';
import 'package:flutter/services.dart';

Future<void> generateQuestionsDocx(List<Question> questions) async {
  try {
    // Load the DOCX template file
    final data = await rootBundle.load('assets/templates - 50 soal.docx');
    final bytes = data.buffer.asUint8List();

    final docx = await DocxTemplate.fromBytes(bytes);

    // List<Map<String, dynamic>> questions = [
    //   {
    //     'question': 'What is the capital of France?',
    //     'options': ['Berlin', 'Madrid', 'Paris', 'Rome'],
    //   },
    //   {
    //     'question': 'Which planet is known as the Red Planet?',
    //     'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
    //   },
    //   {
    //     'question': 'What is the largest ocean on Earth?',
    //     'options': [
    //       'Atlantic Ocean',
    //       'Indian Ocean',
    //       'Arctic Ocean',
    //       'Pacific Ocean'
    //     ],
    //   }
    // ];

    List<List<Content>> contentList =
        List.generate(questions.length, (_) => []);
    for (int i = 0; i < questions.length; i++) {
      for (var n in questions[i].options) {
        final c = PlainContent("value")..add(TextContent("normal", n));
        contentList[i].add(c);
      }
    }

    final content = Content();
    for (int i = 0; i < questions.length; i++) {
      content.add(ListContent("list$i", [
        TextContent("value", questions[i].text)
          ..add(ListContent("listnested", contentList[i])),
      ]));
    }

    final generatedBytes = await docx.generate(content);
    final outputFile =
        File('/storage/emulated/0/Documents/ExerciseSample50.docx');
    if (generatedBytes != null) {
      await outputFile.writeAsBytes(generatedBytes);
    }

    print('DOCX file generated and saved successfully.');
  } catch (e) {
    print('Error generating DOCX file: $e');
  }
}
