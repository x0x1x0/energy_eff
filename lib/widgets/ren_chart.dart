import 'package:energy_eff/data/ren_shares.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RenShareDailyAvgChart extends StatelessWidget {
  final List<RenShareDailyAvg> renShareDailyAvgData;

  const RenShareDailyAvgChart({super.key, required this.renShareDailyAvgData});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime thirtyDaysagp = now.subtract(const Duration(days: 30));

    return Container(
      height: 164,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SfCartesianChart(
          margin: const EdgeInsets.all(0),
          legend: const Legend(isVisible: false),
          title: const ChartTitle(text: 'Daily Average Renewable Shares'),
          primaryXAxis: DateTimeAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            dateFormat: DateFormat('dd.MM'),
            majorGridLines: const MajorGridLines(width: 0),
            interval: 7,
            minimum: thirtyDaysagp,
            maximum: now,
          ),
          primaryYAxis: const NumericAxis(
            labelFormat: '{value} %',
            axisLine: AxisLine(width: 0),
            interval: 25,
            majorTickLines: MajorTickLines(size: 0),
            maximum: 100, // Add this line
          ),
          series: <CartesianSeries<RenShareDailyAvg, DateTime>>[
            FastLineSeries<RenShareDailyAvg, DateTime>(
              dataSource: renShareDailyAvgData,
              xValueMapper: (RenShareDailyAvg shares, _) =>
                  DateFormat('dd.MM.yyyy').parse(shares.day),
              yValueMapper: (RenShareDailyAvg shares, _) => shares.data,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
