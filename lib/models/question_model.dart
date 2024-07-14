class Question {
  final String text;
  final List<String> options;
  final String correctOption;

  Question({
    required this.text,
    required this.options,
    required this.correctOption,
  });

 factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      text: data['text'] ?? '', // Provide a default empty string if null
      options: List<String>.from(data['options'] ?? []), // Provide a default empty list if null
      correctOption: data['correctOption'] ?? '', // Provide a default empty string if null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'options': options,
      'correctOption': correctOption,
    };
  }
}