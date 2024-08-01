import 'package:aplikasi_ekstraksi_file_gpt4/utils/file_loader_and_splitter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain_openai/langchain_openai.dart';

final String openAiApiKey = dotenv.env["OPENAI_API_KEY"]!;
final String supabaseApiKey = dotenv.env["SUPABASE_API_KEY"]!;
final embeddings = OpenAIEmbeddings(apiKey: openAiApiKey);

class VectorStore {}
