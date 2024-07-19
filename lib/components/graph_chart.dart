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
    this.maxX = 10,
    this.minX = 1,
    this.maxY = 100,
    this.minY = 0,
  });

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = List.generate(
      yValues.length,
      (index) => FlSpot((index + 1).toDouble(), yValues[index]),
    );

    return Container(
      padding: EdgeInsetsDirectional.all(10),
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black),
          ),
          maxX: maxX,
          minX: minX,
          maxY: maxY,
          minY: minY,
          titlesData: const FlTitlesData(
            show: true,
            topTitles: AxisTitles(
              sideTitles: SideTitles(reservedSize: 0, showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(reservedSize: 0, showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: 20,
                reservedSize: 35,
                showTitles: true,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: 1,
                reservedSize: 24,
                showTitles: true,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
