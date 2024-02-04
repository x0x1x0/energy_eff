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
    final priceData = EnergyPriceService().fetchPrices();
    final renShareData = RenShareDailyAvgService().fetchRenShareDailyAvg();
    final renSignalData = RenSignalService().fetchRenSignal();

    final currentPriceData = EPEXsPriceService().fetchPrices();

    return Future.wait(
        [priceData, renShareData, renSignalData, currentPriceData]);
  }

  // double calculateFinalPricePerKWh(double basePriceCents) {
  //   double offshoreNetworkLevy = 0.591;
  //   double concessionFee = 1.66;
  //   double stromNEVSurcharge = 0.417;
  //   double chpSurcharge = 0.357;
  //   double electricityTax = 2.05;

  //   double totalWithoutVATCents = basePriceCents +
  //       offshoreNetworkLevy +
  //       concessionFee +
  //       stromNEVSurcharge +
  //       chpSurcharge +
  //       electricityTax;

  //   double vatCents = totalWithoutVATCents * 0.19;

  //   double finalPricePerKWhCents = totalWithoutVATCents + vatCents;

  //   return finalPricePerKWhCents;
  // }

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
                final priceData = snapshot.data![0];
                final renShareData = snapshot.data![1];
                final renSignalData = snapshot.data![2];

                final List<EPEXsPrice> currentPriceData = snapshot.data![3];

                double currentPricePerKWh = currentPriceData.last.value;

                // double finalPricePerKWh =
                //     calculateFinalPricePerKWh(currentPricePerKWh);

                int signal = renSignalData.last.signal;
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
                          child: TaskEnergyCostCalculator()),
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
