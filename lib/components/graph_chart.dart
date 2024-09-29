import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomLineChart extends StatelessWidget {
  final List<double> yValues;
  final List<String> statuses;
  final List<DateTime> createdAt; // Add a parameter for createdAt

  CustomLineChart({
    required this.yValues,
    required this.statuses,
    required this.createdAt,
  })  : assert(
            yValues.length == statuses.length &&
                statuses.length ==
                    createdAt.length, // Ensure they all have the same length
            "yValues, statuses, and createdAt must have the same length"),
        maxX = (yValues.isNotEmpty) ? yValues.length.toDouble() : 10,
        minX = 1,
        maxY = 100,
        minY = 0;

  final double maxX;
  final double minX;
  final double maxY;
  final double minY;

  @override
  Widget build(BuildContext context) {
    if (yValues.isEmpty) {
      return Center(child: Text('No data available'));
    }

    // Combine yValues, statuses, and createdAt into a list of tuples for sorting
    List<Map<String, dynamic>> combinedList = List.generate(
      yValues.length,
      (index) => {
        'yValue': yValues[index],
        'status': statuses[index],
        'createdAt': createdAt[index],
      },
    );

    // Sort the list based on createdAt dates
    combinedList.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));

    // Extract sorted values
    List<double> sortedYValues =
        combinedList.map((e) => e['yValue'] as double).toList();
    List<String> sortedStatuses =
        combinedList.map((e) => e['status'] as String).toList();

    // Filter the spots based on status and score
    List<FlSpot> spots = List.generate(
      sortedYValues.length,
      (index) {
        if (sortedStatuses[index] != "Selesai" && sortedYValues[index] == 0) {
          return null; // Skip this point
        }
        return FlSpot((index + 1).toDouble(), sortedYValues[index]);
      },
    ).whereType<FlSpot>().toList(); // Remove null values

    // If no valid data points remain
    if (spots.isEmpty) {
      return Center(child: Text('No valid data available'));
    }

    return Container(
      padding: EdgeInsets.all(10),
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: false,
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toString(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.blue.shade800],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.blue.withOpacity(0.0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: Colors.blue.shade800,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
