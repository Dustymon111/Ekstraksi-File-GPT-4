import 'dart:io';

import 'package:aplikasi_ekstraksi_file_gpt4/utils/text_processing.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> extractTextFromPDF(String file) async{
    //Load the PDF document
    //Load an existing PDF document.
  PdfDocument document =
    PdfDocument(inputBytes: File(file).readAsBytesSync());
  //Extract the text from page 1.
  String text = PdfTextExtractor(document).extractText(startPageIndex: 0, endPageIndex: document.pages.count - 1);
  //Dispose the document.
  return processExtractedText(text);
}
 