import 'package:flutter/material.dart';

// Widget for displaying the current price
class CurrentPriceCard extends StatelessWidget {
  final double currentPricePerKWh;

  const CurrentPriceCard({super.key, required this.currentPricePerKWh});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 4.0), // Space between the cards
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
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '${currentPricePerKWh.toStringAsFixed(2)} €',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for displaying the signal
class SignalCard extends StatelessWidget {
  final int signal;

  const SignalCard({Key? key, required this.signal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine color based on signal
    Color color = Colors.grey; // Default color
    switch (signal) {
      case -1:
      case 0:
        color = Colors.red;
        break;
      case 1:
        color = Colors.yellow;
        break;
      case 2:
        color = Colors.green;
        break;
    }

    return Container(
      height: 100,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(left: 4.0), // Space between the cards
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
            'Energy Signal',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated DashCards widget to use CurrentPriceCard and SignalCard
class DashCards extends StatelessWidget {
  final double currentPricePerKWh; // Passed from the parent widget
  final int signal; // Signal value

  const DashCards({
    Key? key,
    required this.currentPricePerKWh,
    required this.signal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert MWh to kWh

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: CurrentPriceCard(currentPricePerKWh: currentPricePerKWh),
          ),
          Expanded(
            child: SignalCard(signal: signal),
          ),
        ],
      ),
    );
  }
}
