class Question {
  String? id;
  final String text;
  final List<String> options;
  final dynamic correctOption; // Digunakan untuk single choice question
  final String questionSetId; // Referensi ke dokumen QuestionSet
  final String type;

  Question({
    this.id,
    required this.text,
    required this.options,
    this.correctOption,
    required this.questionSetId,
    required this.type,
  });

  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      type: data['type'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctOption: data['correctOption'],
      questionSetId: data['questionSetId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctOption': correctOption,
      'questionSetId': questionSetId,
      'type': type,
    };
  }
}
