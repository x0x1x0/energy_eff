import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:energy_eff/data/ren_signal.dart';
import 'package:energy_eff/widgets/dash_rects.dart';
import 'package:energy_eff/data/ren_shares.dart';
import 'package:energy_eff/data/price_data.dart';
import 'package:energy_eff/widgets/price_chart.dart';
import 'package:energy_eff/widgets/ren_chart.dart';
import 'package:energy_eff/widgets/task_calculator.dart';
import 'package:energy_eff/widgets/cost_calculator.dart';

class CalculatorMain extends StatefulWidget {
  const CalculatorMain({Key? key}) : super(key: key);

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
    return Future.wait([priceData, renShareData, renSignalData]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text("24 Energy"), // Updated to display text instead of SVG
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 51, 52, 69),
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
                double currentPricePerMWh = priceData.last.price;
                double currentPricePerKWh = currentPricePerMWh / 1000;
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
                      SizedBox(height: 32)
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
            }
            // By default, show a loading spinner.
            return Center(
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
