import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomLineChart extends StatelessWidget {
  final List<double> yValues;
  final double maxX;
  final double minX;
  final double maxY;
  final double minY;

  CustomLineChart({
    required this.yValues,
  })  : maxX = (yValues.isNotEmpty) ? yValues.length.toDouble() : 10,
        minX = 1,
        maxY = 100,
        minY = 0;

  @override
  Widget build(BuildContext context) {
    if (yValues.isEmpty) {
      return Center(child: Text('No data available'));
    }

    List<FlSpot> spots = List.generate(
      yValues.length,
      (index) => FlSpot((index + 1).toDouble(), yValues[index]),
    );

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
