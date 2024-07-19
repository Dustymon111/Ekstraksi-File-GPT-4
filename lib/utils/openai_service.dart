import 'dart:convert';
import 'package:aplikasi_ekstraksi_file_gpt4/utils/pdf_text_extractor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dart_openai/dart_openai.dart';

class FileProcessor {
  final String apiKey = dotenv.env["OPENAI_API_KEY"]!;

Future<Map<String, dynamic>> extractTableOfContents(String fileUrl) async {
  final text = await extractTextFromPDF(fileUrl);
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'prompt': 'Extract the title, total page number, the author, and the table of contents from this $text, if it exist. The text maybe contains appended words that could be hard to extract. Return the result in a JSON format with the following keys: "title", "totalPages", "author", and "subjects" (where "subjects" is a JSON array of section titles).',
      'max_tokens': 2200,
      'temperature': 0.7,
    }),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final extractedData = data['choices'][0]['text'].trim();

    try {
      print(jsonDecode(extractedData));
      return jsonDecode(extractedData);
    } catch (e) {
      throw Exception('Failed to parse extracted data: $e');
    }
  } else {
    throw Exception('Failed to extract table of contents. Status code: ${response.statusCode}');
  }
}

Future<void> listModel() async {
  final response = await http.get(
    Uri.parse('https://api.openai.com/v1/models'),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    try {
      print(data['data']);
    } catch (e) {
      throw Exception('Failed to parse extracted data: $e');
    }
  } else {
    throw Exception('Failed to extract table of contents. Status code: ${response.statusCode}');
  }
}

Future<void> testFunction() async {
  final completion = await OpenAI.instance.completion.create(
    model: "gpt-3.5-turbo",
    prompt: "who is the CEO of Google",
    maxTokens: 50 
  );

  print(completion.choices[0].text);
}


  Future<Map<String, dynamic>> extractInformation(String fileUrl, String sectionTitle) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': '''
          Extract detailed information about the section titled "$sectionTitle" from the document at this URL: $fileUrl.
          Return the information in the following JSON format:
          {
            "title": "Section title",
            "content": "Detailed content of the section"
          }
        ''',
        'max_tokens': 500,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return jsonDecode(data['choices'][0]['text']);
    } else {
      throw Exception('Failed to extract information');
    }
  }
}

