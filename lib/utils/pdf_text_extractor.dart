import 'dart:io';

import 'package:aplikasi_ekstraksi_file_gpt4/utils/text_processing.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

Future<File> downloadPDF(String url, String fileName) async {
  // Get the temporary directory of the device
  final Directory tempDir = await getTemporaryDirectory();
  final File file = File('${tempDir.path}/$fileName');

  // Download the file from the URL
  final http.Response response = await http.get(Uri.parse(url));
  await file.writeAsBytes(response.bodyBytes);

  return file;
}


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
 