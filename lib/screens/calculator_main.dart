import 'package:energy_eff/widgets/dash_rects.dart';
import 'package:flutter/material.dart';
import 'package:energy_eff/data/ren_shares.dart';
import 'package:energy_eff/data/price_data.dart';
import 'package:energy_eff/widgets/price_chart.dart';
import 'package:energy_eff/widgets/ren_chart.dart';
import 'package:energy_eff/widgets/task_calculator.dart';
import 'package:energy_eff/widgets/cost_calculator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalculatorMain extends StatefulWidget {
  const CalculatorMain({super.key});

  @override
  _CalculatorMainState createState() => _CalculatorMainState();
}

class _CalculatorMainState extends State<CalculatorMain> {
  late Future<List<EnergyPrice>> _priceDataFuture;
  late Future<List<RenShareDailyAvg>> _renShareDataFuture;

  @override
  void initState() {
    super.initState();
    // Initialize data fetch operations
    _priceDataFuture = EnergyPriceService().fetchPrices();
    _renShareDataFuture = RenShareDailyAvgService().fetchRenShareDailyAvg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        // Ensure this height accommodates the logo height plus padding.
        title: SvgPicture.asset(
          'lib/assets/svg/24app.svg', // Path to your SVG file
          height:
              48, // Adjust based on your AppBar's height to center the logo properly
        ),
        centerTitle:
            true, // This ensures the title (your logo) is centered in the AppBar
        backgroundColor: Color.fromARGB(255, 51, 52, 69),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<EnergyPrice>>(
          future: _priceDataFuture,
          builder: (context, priceSnapshot) {
            if (priceSnapshot.connectionState == ConnectionState.done) {
              if (priceSnapshot.hasError) {
                return Text('Error: ${priceSnapshot.error}');
              } else if (priceSnapshot.hasData &&
                  priceSnapshot.data!.isNotEmpty) {
                double currentPricePerMWh = priceSnapshot.data!.last.price;
                return FutureBuilder<List<RenShareDailyAvg>>(
                  future: _renShareDataFuture,
                  builder: (context, renShareSnapshot) {
                    if (renShareSnapshot.connectionState ==
                        ConnectionState.done) {
                      if (renShareSnapshot.hasError) {
                        return Text('Error: ${renShareSnapshot.error}');
                      } else if (renShareSnapshot.hasData &&
                          renShareSnapshot.data!.isNotEmpty) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: DashCards(
                                    currentPricePerMWh: currentPricePerMWh),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child:
                                    PriceChart(priceData: priceSnapshot.data!),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: RenShareDailyAvgChart(
                                    renShareDailyAvgData:
                                        renShareSnapshot.data!),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TaskEnergyCostCalculator(
                                    currentPricePerMWh: currentPricePerMWh),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: EnergyCostCalculator(
                                    currentPricePerMWh: currentPricePerMWh),
                              ),
                              const SizedBox(height: 32),
                              // Add your new widget here and pass any required data as you did with other widgets.
                            ],
                          ),
                        );
                      }
                    }
                    return const CircularProgressIndicator();
                  },
                );
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
