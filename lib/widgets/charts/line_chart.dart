import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  final List<LineChartBarData> lineChartData;
  final List<dynamic> xValues;

  const LineChartWidget({
    super.key,
    required this.lineChartData,
    required this.xValues,
  });

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late double minX = 0;
  late double maxX = 0;
  late double minY = 0;
  late double maxY = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      calculateMinMaxValues();
    });
  }

  @override
  void didUpdateWidget(covariant LineChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    calculateMinMaxValues();
  }

  void calculateMinMaxValues() {
    setState(() {
      minX = 0;
      maxX = widget.xValues.length.toDouble() + 2;
      minY = 0;
      maxY = getMaxX(offset: 1).toDouble();
    });
    debugPrint("minX: $minX, maxX: $maxX, minY: $minY, maxY: $maxY");
  }

  num getMinX({int offset = 0}) {
    if (widget.xValues.isEmpty) {
      return 0;
    }

    double min = widget.lineChartData[0].spots[0].x;

    for (final data in widget.lineChartData) {
      for (final spot in data.spots) {
        if (spot.y < min) {
          min = spot.y;
        }
      }
    }

    return min.toInt() - offset;
  }

  num getMaxX({int offset = 0}) {
    if (widget.xValues.isEmpty) {
      return 0;
    }

    double max = widget.lineChartData[0].spots[0].x;

    for (final data in widget.lineChartData) {
      for (final spot in data.spots) {
        if (spot.y > max) {
          max = spot.y;
        }
      }
    }

    return max.toInt() + offset;
  }

  num getMinY({int offset = 0}) {
    if (widget.xValues.isEmpty) {
      return 0;
    }

    double min = widget.lineChartData[0].spots[0].y;

    for (final data in widget.lineChartData) {
      for (final spot in data.spots) {
        if (spot.y < min) {
          min = spot.y;
        }
      }
    }

    return min.toInt() - offset;
  }

  num getMaxY({int offset = 0}) {
    if (widget.xValues.isEmpty) {
      return 0;
    }

    double max = widget.lineChartData[0].spots[0].y;

    for (final data in widget.lineChartData) {
      for (final spot in data.spots) {
        if (spot.y > max) {
          max = spot.y;
        }
      }
    }

    return max.toInt() + offset;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: LineChart(mainData()),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text;
    const style = TextStyle(
      fontSize: 10.0,
    );

    if (value == minY) {
      text = '';
    } else if (value == maxY) {
      text = '';
    } else {
      if (value > 1000) {
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    if (value == minX) {
      text = '';
    } else if (value == maxX) {
      text = '';
    } else {
      text = widget.xValues[value.toInt()].toString();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            dashArray: [5, 5],
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            dashArray: [5, 5],
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
      ),
      minY: minY,
      maxY: maxY,
      minX: 0,
      maxX: 15,
      lineBarsData: widget.lineChartData,
    );
  }
}

final LineChartBarData defaultLineBarData = LineChartBarData(
  spots: const [
    FlSpot(0, 3),
    FlSpot(2.6, 2),
    FlSpot(4.9, 5),
    FlSpot(6.8, 3.1),
    FlSpot(8, 4),
    FlSpot(9.5, 3),
    FlSpot(11, 4),
  ],
  isCurved: true,
  barWidth: 5,
  isStrokeCapRound: true,
  dotData: const FlDotData(
    show: false,
  ),
  belowBarData: BarAreaData(
    show: true,
  ),
);
