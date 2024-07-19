String processExtractedText(String text) {
  // Example heuristic: Insert space before capital letters (naive approach)
  final processedText = text.replaceAllMapped(
    RegExp(r'([a-z])([A-Z])'),
    (match) => '${match.group(1)} ${match.group(2)}',
  );
  return processedText;
}