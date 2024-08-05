class Question {
  final String text;
  final List<String> options;
  final String correctOption;
  final String questionSetId; // Reference to the QuestionSet document
  final String type;

  Question({
    required this.text,
    required this.options,
    required this.correctOption,
    required this.questionSetId,
    required this.type,
  });

  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      text: data['text'] ?? '', // Provide a default empty string if null
      type: data['type'] ?? '', // Provide a default empty string if null
      options: List<String>.from(
          data['options'] ?? []), // Provide a default empty list if null
      correctOption:
          data['correctOption'] ?? '', // Provide a default empty string if null
      questionSetId:
          data['questionSetId'] ?? '', // Provide a default empty string if null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'options': options,
      'correctOption': correctOption,
      'questionSetId': questionSetId,
      'type': type,
    };
  }
}
