import 'package:aplikasi_ekstraksi_file_gpt4/utils/docx_generator.dart';
import 'package:flutter/material.dart';


class TestScreen extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('DOCX Template Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: generateQuestionsDocx,
            child: Text('Generate Document'),
          ),
        ),
      ),
    );
  }

}