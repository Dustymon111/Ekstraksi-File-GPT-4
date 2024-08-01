import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final String title;
  final String author;
  final int totalPages;

  BookDetailScreen({
    required this.title,
    required this.author,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1C88BF),
        title: Text('Book Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              SizedBox(height: 8),
              Text(
                'Author : $author',
                style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              SizedBox(height: 8),
              Text(
                'Number Of Pages : $totalPages Pages',
                style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              SizedBox(height: 16),
              Text(
                'Table Of Contents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              SizedBox(height: 8),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    title: Text('Bab I ...'),
                    leading: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    title: Text('Bab II ...'),
                    leading: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    title: Text('Bab III ...'),
                    leading: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    title: Text('Bab IV ...'),
                    leading: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    title: Text('Bab V ...'),
                    leading: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    title: Text('Bab VI ...'),
                    leading: Icon(Icons.arrow_right),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Bibliography',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              SizedBox(height: 8),
              Text(
                'Aini, N., Sinurat, S., & Hutabarat, S. A. (2018). '
                'Penerapan metode simple moving average untuk memprediksi hasil laba laundry karpet pada CV Homecare. J. Ris. Komput., vol. 5, no. 2, 167-175.',
                style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
