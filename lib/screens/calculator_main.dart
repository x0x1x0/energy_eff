import 'package:energy_eff/data/exposat_consumer_price.dart';
import 'package:flutter/material.dart';

import 'package:energy_eff/data/ren_signal.dart';
import 'package:energy_eff/widgets/dash_rects.dart';
import 'package:energy_eff/data/ren_shares.dart';
import 'package:energy_eff/data/mwh_price_data.dart';
import 'package:energy_eff/widgets/price_chart.dart';
import 'package:energy_eff/widgets/ren_chart.dart';
import 'package:energy_eff/widgets/task_calculator.dart';
import 'package:energy_eff/widgets/cost_calculator.dart';

class CalculatorMain extends StatefulWidget {
  const CalculatorMain({super.key});

  @override
  _CalculatorMainState createState() => _CalculatorMainState();
}

class _CalculatorMainState extends State<CalculatorMain> {
  late Future<dynamic> _allDataFuture;

  @override
  void initState() {
    super.initState();
    _allDataFuture = fetchAllData();
  }

  Future<dynamic> fetchAllData() async {
    // Keep the existing calls
    final priceData =
        EnergyPriceService().fetchPrices(); // Existing price data for charts
    final renShareData = RenShareDailyAvgService().fetchRenShareDailyAvg();
    final renSignalData = RenSignalService().fetchRenSignal();

    // Add the new EPEXsPriceService call
    final currentPriceData = EPEXsPriceService()
        .fetchPrices(); // New price data for current price per kWh

    // Use Future.wait to wait for all futures to complete
    return Future.wait(
        [priceData, renShareData, renSignalData, currentPriceData]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("24 Energy"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 51, 52, 69),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<dynamic>(
          future: _allDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                // Existing data for charts
                final priceData = snapshot.data![0];
                final renShareData = snapshot.data![1];
                final renSignalData = snapshot.data![2];

                // New current price data
                final currentPriceData = snapshot.data![3];

                // Assuming the last element of currentPriceData is the most recent
                double currentPricePerKWh = currentPriceData.last.value /
                    100; // Ensure this matches your actual data structure

                int signal =
                    renSignalData.last.signal; // Process this data accordingly

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      DashCards(
                        currentPricePerKWh: currentPricePerKWh,
                        signal: signal,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: PriceChart(priceData: priceData),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: RenShareDailyAvgChart(
                            renShareDailyAvgData: renShareData),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TaskEnergyCostCalculator(
                            currentPricePerKWh: currentPricePerKWh),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: EnergyCostCalculator(
                            currentPricePerKWh: currentPricePerKWh),
                      ),
                      const SizedBox(height: 32)
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
            }
            // By default, show a loading spinner.
            return const Center(
                child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              strokeWidth: 5,
            ));
          },
        ),
      ),
    );
  }
}
