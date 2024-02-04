import 'package:flutter/material.dart';

class CurrentPriceCard extends StatelessWidget {
  final double currentPricePerKWh;

  const CurrentPriceCard({super.key, required this.currentPricePerKWh});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 10.0),
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
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '${currentPricePerKWh.toStringAsFixed(2)} ct',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class SignalCard extends StatelessWidget {
  final int signal;

  const SignalCard({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
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
      margin: const EdgeInsets.only(left: 4.0),
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
            style: Theme.of(context).textTheme.titleMedium,
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

class DashCards extends StatelessWidget {
  final double currentPricePerKWh;
  final int signal;

  const DashCards({
    super.key,
    required this.currentPricePerKWh,
    required this.signal,
  });

  @override
  Widget build(BuildContext context) {
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
