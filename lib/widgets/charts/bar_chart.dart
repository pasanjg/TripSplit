import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChartWidget extends StatefulWidget {
  final double height;
  final List<BarChartGroupData> barChartGroupData;
  final List<String> xValues;

  const BarChartWidget({
    super.key,
    this.height = 200.0,
    required this.barChartGroupData,
    required this.xValues,
  });

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  late double minY = 0;
  late double maxY = 0;

  @override
  void didUpdateWidget(covariant BarChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    calculateMinMaxValues();
  }

  void calculateMinMaxValues() {
    setState(() {
      minY = 0;
      maxY = getMaxY(offset: 1).toDouble();
    });
    print("minY: $minY, maxY: $maxY");
  }

  double getChartWidth() {
    const double spacing = 50.0;
    final double totalWidth = widget.xValues.length * spacing;

    if (totalWidth < (MediaQuery.of(context).size.width - 60.0)) {
      return MediaQuery.of(context).size.width - 60.0;
    }

    return totalWidth;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 25.0,
          bottom: 0,
          left: 0,
          right: 25.0,
        ),
        child: SizedBox(
          height: widget.height,
          width: getChartWidth(),
          child: BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: barGroups,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              minY: 0,
            ),
          ),
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            final text = rod.toY != 0 ? NumberFormat.currency(
              symbol: 'LKR ',
            ).format(rod.toY): '';
            return BarTooltipItem(
              text,
              const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 10.0
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    String text;
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    text = widget.xValues[value.toInt()];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text;
    const style = TextStyle(fontSize: 10.0);

    if (value == 0) {
      text = '';
    } else if (value == maxY) {
      text = '';
    } else {
      if (value >= 1000) {
        text = '${value ~/ 1000}k';
      } else {
        text = value.toStringAsFixed(0);
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(show: false);

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => widget.barChartGroupData.map(
        (group) {
          return BarChartGroupData(
            x: group.x,
            barRods: group.barRods.map(
              (rod) {
                return BarChartRodData(
                  toY: rod.toY,
                  gradient: _barsGradient,
                );
              },
            ).toList(),
          );
        },
      ).toList();

  num getMaxY({int offset = 0}) {
    if (widget.xValues.isEmpty) {
      return 0;
    }

    double max = widget.barChartGroupData.fold<double>(
      0,
      (prev, group) {
        return group.barRods.fold<double>(
          prev,
          (prev, rod) {
            return rod.toY > prev ? rod.toY : prev;
          },
        );
      },
    );

    return max.toInt() + offset;
  }
}
