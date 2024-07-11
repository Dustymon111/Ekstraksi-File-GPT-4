import 'package:aplikasi_ekstraksi_file_gpt4/models/bookmark_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class BookmarkDetailScreen extends StatefulWidget {
  final Bookmark bookmark;

  BookmarkDetailScreen({required this.bookmark});
  @override
  _BookmarkDetailScreenState createState() => _BookmarkDetailScreenState();
}

class _BookmarkDetailScreenState extends State<BookmarkDetailScreen> {
  bool _isChartVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Modul/Buku'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.bookmark.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Penulis: ${widget.bookmark.author}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Jumlah Halaman: ${widget.bookmark.pageNumber.toString()}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isChartVisible = !_isChartVisible;
                  });
                },
                child: Row(
                  children: [
                    const Text(
                      'Grafik Pembelajaran',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                    Icon(_isChartVisible
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down),
                  ],
                ),
              ),
              if (_isChartVisible)
                Container(
                  padding: EdgeInsetsDirectional.all(10),
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true, drawVerticalLine: false),
                      borderData: FlBorderData(show: true, border: Border.all(color: Colors.black)),
                      maxX: 10,
                      minX: 1,
                      maxY: 100,
                      minY: 20,
                      titlesData: const FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(sideTitles: SideTitles(reservedSize: 0, showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(reservedSize: 0, showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(interval: 20, reservedSize: 35, showTitles: true)
                          ) ,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(interval: 1, reservedSize: 24, showTitles: true)
                          )
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                          FlSpot(1, 40), // Example data points (x, y)
                          FlSpot(2, 60),
                          FlSpot(3, 80),
                          FlSpot(4, 20),
                          FlSpot(5, 100),
                          FlSpot(6, 60),
                          FlSpot(7, 80),
                          FlSpot(8, 40),
                          FlSpot(9, 20),
                          FlSpot(10, 80),
                          ],
                          isCurved: false,
                          color:Colors.blue,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 16),
              Text("List Latihan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.check),
                    title: Text('Subject ${index+1}', overflow: TextOverflow.ellipsis,),
                    onTap: () {
                      // Navigate to another screen if needed
                    },
                    trailing: Text('Hasil: 30/50'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
