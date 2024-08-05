// import 'package:aplikasi_ekstraksi_file_gpt4/utils/docx_generator.dart';
// import 'package:aplikasi_ekstraksi_file_gpt4/utils/openai_service.dart';
// import 'package:aplikasi_ekstraksi_file_gpt4/utils/vector_store.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Generate DOCX with Python')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // VectorStore().addVector();
              // VectorStore().vectorSimSearch();
            },
            child: Text('Generate Document'),
          ),
        ),
      ),
    );
  }
}
