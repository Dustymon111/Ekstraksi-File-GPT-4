class Subject {
  String? id;
  final String title;
  final String description;
  final List<String> questionSetIds; // List of QuestionSet document IDs
  final String bookmarkId; // Reference to the Bookmark document

  Subject({
    this.id,
    required this.title,
    required this.description,
    required this.questionSetIds,
    required this.bookmarkId,
  });

  factory Subject.fromMap(Map<String, dynamic> data) {
    return Subject(
      id: data['id'] ?? "",
      title: data['title'] ?? '', // Provide a default empty string if null
      description:
          data['description'] ?? '', // Provide a default empty string if null
      questionSetIds: List<String>.from(
          data['questionSetIds'] ?? []), // Provide a default empty list if null
      bookmarkId:
          data['bookmarkId'] ?? '', // Provide a default empty string if null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questionSetIds': questionSetIds,
      'bookmarkId': bookmarkId,
    };
  }
}
