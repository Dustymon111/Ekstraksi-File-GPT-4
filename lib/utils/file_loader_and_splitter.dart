import 'package:langchain_community/langchain_community.dart';
import 'package:langchain/langchain.dart';

Future<List<Document>> loadAndSplit() async {
  const filePath = '/storage/emulated/0/Documents/temp_file.txt';
  const loader = TextLoader(filePath);
  final documents = await loader.load();
  const textSplitter = RecursiveCharacterTextSplitter(
    chunkSize: 512,
    chunkOverlap: 64,
  );
  final docs = textSplitter.splitDocuments(documents);
  return docs;
}
