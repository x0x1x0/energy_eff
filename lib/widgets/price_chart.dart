import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:energy_eff/data/mwh_price_data.dart';


class PriceChart extends StatelessWidget {
  final List<EnergyPrice> priceData;

  const PriceChart({super.key, required this.priceData});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));

    // Assuming priceData is not empty and prices are in €/MWh
    double currentPricePerMWh =
        priceData.last.price; // The last price might be the most current
    double currentPricePerKWh =
        currentPricePerMWh / 1000; // Convert €/MWh to €/kWh

    // Preprocess data: Group by day and calculate average
    final Map<DateTime, double> dailyAverages = {};
    for (var price in priceData) {
      final date =
          DateTime.fromMillisecondsSinceEpoch(price.unixSeconds * 1000);
      final day = DateTime(date.year, date.month, date.day);
      dailyAverages.update(
          day, (existingValue) => (existingValue + price.price) / 2,
          ifAbsent: () => price.price);
    }

    final List<EnergyPrice> dailyAveragePrices = dailyAverages.entries
        .map((entry) => EnergyPrice(
            unixSeconds: entry.key.millisecondsSinceEpoch ~/ 1000,
            price: entry.value))
        .toList();

    return Column(
      children: [
        Container(
          height: 200, // Adjusted for overall container
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
              title: const ChartTitle(
                  text: 'Daily Average Energy Prices \n (in €/MWh)'),
              primaryXAxis: DateTimeAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                dateFormat: DateFormat('dd.MM'),
                majorGridLines: const MajorGridLines(width: 0),
                interval: 7,
                minimum: thirtyDaysAgo,
                maximum: now,
              ),
              primaryYAxis: const NumericAxis(
                labelFormat: '{value} €',
                axisLine: AxisLine(width: 0),
                majorTickLines: MajorTickLines(size: 0),
              ),
              series: <ColumnSeries<EnergyPrice, DateTime>>[
                ColumnSeries<EnergyPrice, DateTime>(
                  dataSource: dailyAveragePrices,
                  xValueMapper: (EnergyPrice prices, _) =>
                      DateTime.fromMillisecondsSinceEpoch(
                          prices.unixSeconds * 1000),
                  yValueMapper: (EnergyPrice prices, _) => prices.price,
                  name: 'EUR/MWh',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
