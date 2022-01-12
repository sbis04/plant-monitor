import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mongodb_realm/database/database.dart';
import 'package:intl/intl.dart';
import 'package:plant_tinker/res/palette.dart';

class HumidityChart extends StatelessWidget {
  final List<MongoDocument> docs;

  HumidityChart({required this.docs});

  final List<Color> gradientColors = [
    Palette.red_accent,
    Palette.skin_accent,
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.30,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Palette.blue_gray_dark,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 24.0,
            left: 0.0,
            top: 24,
            bottom: 12,
          ),
          child: LineChart(mainData()),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      axisTitleData: FlAxisTitleData(
        topTitle: AxisTitle(
          showTitle: true,
          titleText: 'Humidity',
          textStyle: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Montserrat',
            color: Palette.skin_accent,
          ),
          margin: 8.0,
          textAlign: TextAlign.left,
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 16,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.white30,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          getTitles: (value) {
            int total = docs.length;
            // int interval = total ~/ 6;

            final formatter = DateFormat('h a');

            if (value == 0) {
              final data = docs[0].get('sensors');
              final int timestamp = data['timestamp'] as int;
              return formatter.format(
                  DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
            } else if (value == (total - 2)) {
              final data = docs[total - 1].get('sensors');
              final int timestamp = data['timestamp'] as int;
              return formatter.format(
                  DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
            }

            // if (value == interval) {
            //   return formatter.format(DateTime.fromMillisecondsSinceEpoch(
            //       (docs[interval].data()['timestamp']) * 1000));
            // } else if (value == interval * 2) {
            //   return formatter.format(DateTime.fromMillisecondsSinceEpoch(
            //       (docs[interval * 2].data()['timestamp']) * 1000));
            // } else if (value == interval * 3) {
            //   return formatter.format(DateTime.fromMillisecondsSinceEpoch(
            //       (docs[interval * 3].data()['timestamp']) * 1000));
            // } else if (value == interval * 4) {
            //   return formatter.format(DateTime.fromMillisecondsSinceEpoch(
            //       (docs[interval * 4].data()['timestamp']) * 1000));
            // }

            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.white30,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 20:
                return '20';
              case 40:
                return '40';
              case 60:
                return '60';
              case 80:
                return '80';
              case 100:
                return '100';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: const Color(0xff37434d),
          width: 1,
        ),
      ),
      minX: 0,
      maxX: docs.length.toDouble() - 1,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < docs.length; i++)
              FlSpot(
                i.toDouble(),
                (docs[i].get('sensors')['humidity'] as int).toDouble(),
              ),
          ],
          isCurved: false,
          colors: gradientColors,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
