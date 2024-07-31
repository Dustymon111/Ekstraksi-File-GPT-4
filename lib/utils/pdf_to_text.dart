import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void pdfToText(String file) async {
  //Load the PDF document
  //Load an existing PDF document.
  String filePath = '/storage/emulated/0/Documents/temp_file.txt';
  if (await File(filePath).exists()) {
    await File(filePath).delete();
  }
  PdfDocument document = PdfDocument(inputBytes: File(file).readAsBytesSync());
  //Extract the text from page 1.
  String text = PdfTextExtractor(document)
      .extractText(startPageIndex: 0, endPageIndex: document.pages.count - 1);
  //Dispose the document.
  final File textFile = File('/storage/emulated/0/Documents/temp_file.txt');
  await textFile.writeAsString(text);
}
