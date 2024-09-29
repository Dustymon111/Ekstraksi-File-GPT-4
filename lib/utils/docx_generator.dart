import 'package:aplikasi_ekstraksi_file_gpt4/models/question_model.dart';
import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> generateQuestionsDocx(
    List<Question> questions, String title) async {
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

    List<Content> answerList = [];
    for (var n in questions) {
      if (n.type == "m_answer") {
        final c = PlainContent("value")
          ..add(TextContent(
              "normal", "Multiple Answer:\n- ${n.correctOption.join("\n- ")}"));
        answerList.add(c);
      } else {
        final c = PlainContent("value")
          ..add(TextContent("normal", n.correctOption));
        answerList.add(c);
      }
    }

    final content = Content();
    for (int i = 0; i < questions.length; i++) {
      content.add(ListContent("list$i", [
        TextContent("value", questions[i].text)
          ..add(ListContent("listnested", contentList[i])),
      ]));
      content.add(ListContent("answer0", answerList));
      // if (questions[i].type == "m_answer") {
      //   content.add(ListContent("answer$i",
      //       [TextContent("value", questions[i].correctOption.join('\n'))]));
      // } else {
      //   content.add(ListContent(
      //       "answer$i", [TextContent("value", questions[i].correctOption)]));
      // }
    }

    final generatedBytes = await docx.generate(content);
    final outputFile = File('/storage/emulated/0/Documents/$title.docx');
    if (generatedBytes != null) {
      await outputFile.writeAsBytes(generatedBytes);
    }

    Fluttertoast.showToast(
      msg: "Exercise Exported as Docx to Device's Document Folder.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.lightBlue,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    print('DOCX file generated and saved successfully.');
  } catch (e) {
    print('Error generating DOCX file: $e');
  }
}
