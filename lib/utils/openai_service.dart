import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FileProcessor {
  final String apiKey = dotenv.env["OPENAI_API_KEY"]!;

  Future<List<String>> extractTableOfContents(String fileUrl) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': '''
          Extract the table of contents from the document at this URL: $fileUrl.
          Return the table of contents in a JSON array format, where each entry is a section title.
        ''',
        'max_tokens': 500,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(jsonDecode(data['choices'][0]['text']));
    } else {
      throw Exception('Failed to extract table of contents');
    }
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

