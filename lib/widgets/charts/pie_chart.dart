import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'indicator.dart';

class PieChartWidget extends StatefulWidget {
  final double height;
  final List<Indicator> indicators;
  final List<PieChartSectionData> chartData;

  const PieChartWidget({
    super.key,
    this.height = 250.0,
    required this.indicators,
    required this.chartData,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 50.0,
                sections: showingSections(),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Wrap(
            spacing: 10.0,
            alignment: WrapAlignment.center,
            children: [
              ...widget.indicators,
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.chartData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 14.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: widget.chartData[i].color,
        value: widget.chartData[i].value,
        title: widget.chartData[i].title,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}
