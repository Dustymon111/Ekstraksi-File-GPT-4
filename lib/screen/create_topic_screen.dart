import 'package:flutter/material.dart';

class CreateTopicScreen extends StatefulWidget {
  const CreateTopicScreen({super.key});

  @override
  State<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  String? selectedSubject;
  String? selectedTopic;
  int? selectedMultipleChoice;
  int? selectedEssay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1C88BF),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Create quizzes based on content Topics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "A topic about the questions you want!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            const Text(
              "Subject",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              hint: Text("Choose a subject"),
              value: selectedSubject,
              isExpanded: true,
              onChanged: (newValue) {
                setState(() {
                  selectedSubject = newValue;
                });
              },
              items: <String>['Math', 'Science', 'Analyst']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            const Text(
              "Topics",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              hint: Text("Choose a Topics"),
              value: selectedTopic,
              isExpanded: true,
              onChanged: (newValue) {
                setState(() {
                  selectedTopic = newValue;
                });
              },
              items: <String>['Bab I', 'Bab II', 'Bab III']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            const Text(
              "Number of Questions",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Multiple choice",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Wrap(
              spacing: 10.0,
              children: List.generate(7, (index) {
                int number = (index + 1) * 5;
                return ChoiceChip(
                  label: Text(number.toString()),
                  selected: selectedMultipleChoice == number,
                  onSelected: (selected) {
                    setState(() {
                      selectedMultipleChoice = selected ? number : null;
                    });
                  },
                  selectedColor: Color(0xFF1C88BF),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              "Essay",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Wrap(
              spacing: 10.0,
              children: List.generate(5, (index) {
                int number = index + 2;
                return ChoiceChip(
                  label: Text(number.toString()),
                  selected: selectedEssay == number,
                  onSelected: (selected) {
                    setState(() {
                      selectedEssay = selected ? number : null;
                    });
                  },
                  selectedColor: Color(0xFF1C88BF),
                );
              }),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward),
                label: Text(
                  "Generate",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 17.0, horizontal: 50.0),
                  backgroundColor: Color(0xFF1C88BF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
