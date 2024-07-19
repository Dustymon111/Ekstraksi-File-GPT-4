import 'package:aplikasi_ekstraksi_file_gpt4/utils/pdf_text_extractor.dart';
import 'package:flutter/material.dart';

class PdfTextScreen extends StatefulWidget {
  final String pdfFilePath;

  PdfTextScreen({required this.pdfFilePath});

  @override
  _PdfTextScreenState createState() => _PdfTextScreenState();
}

class _PdfTextScreenState extends State<PdfTextScreen> {
  Future<String>? _extractedText;

  @override
  void initState() {
    super.initState();
    // Start extracting text when the widget initializes
    _extractedText = extractTextFromPDF(widget.pdfFilePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Text Extractor'),
      ),
      body: FutureBuilder<String>(
        future: _extractedText,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Text(snapshot.data ?? 'No data'),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
