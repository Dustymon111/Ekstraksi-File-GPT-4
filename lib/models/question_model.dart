class Question {
  final String text;
  final List<String> options;
  final dynamic correctOption; // Digunakan untuk single choice question
  final List<String>?
      correctOptions; // Digunakan untuk multiple answer question
  final String questionSetId; // Referensi ke dokumen QuestionSet
  final String type;

  Question({
    required this.text,
    required this.options,
    this.correctOption,
    this.correctOptions,
    required this.questionSetId,
    required this.type,
  });

  // factory Question.fromMap(Map<String, dynamic> data) {
  //   return Question(
  //     text: data['text'] ?? '', // Default ke string kosong jika null
  //     type: data['type'] ?? '', // Default ke string kosong jika null
  //     options: List<String>.from(
  //         data['options'] ?? []), // Default ke list kosong jika null
  //     correctOption:
  //         data['correctOption'], // Tetap null jika tidak ada atau default ke string kosong jika null
  //     correctOptions: data['correctOptions'] != null
  //         ? List<String>.from(data['correctOptions'])
  //         : null, // Default ke null jika tidak ada
  //     questionSetId:
  //         data['questionSetId'] ?? '', // Default ke string kosong jika null
  //   );
  // }
  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      text: data['text'] ?? '',
      type: data['type'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctOption: data['correctOption'],
      correctOptions: data['correctOptions'] != null
          ? List<String>.from(data['correctOptions'])
          : null,
      questionSetId: data['questionSetId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'options': options,
      'correctOption': correctOption,
      'correctOptions': correctOptions,
      'questionSetId': questionSetId,
      'type': type,
    };
  }
}
