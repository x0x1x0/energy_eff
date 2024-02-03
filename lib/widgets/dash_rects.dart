import 'package:flutter/material.dart';

class DashCards extends StatelessWidget {
  final double currentPricePerMWh; // This will be passed from the parent widget

  const DashCards({Key? key, required this.currentPricePerMWh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert MWh to kWh
    double currentPricePerKWh = currentPricePerMWh / 100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(
                  right: 4.0), // Add space between the cards
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current Price',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),

                  // Display the converted price per kWh
                  Text(
                    currentPricePerKWh.toStringAsFixed(4),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(
                  left: 4.0), // Add space between the cards
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hardcoded Value',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const Text(
                    '24',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
