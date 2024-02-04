import 'package:flutter/material.dart';

class TaskEnergyCostCalculator extends StatefulWidget {
  final double currentPricePerKWh;
  final double highEndRigPower =
      850.0; // Assuming this is the power for the high-end rig

  const TaskEnergyCostCalculator({super.key, required this.currentPricePerKWh});

  @override
  State<TaskEnergyCostCalculator> createState() =>
      _TaskEnergyCostCalculatorState();
}

class _TaskEnergyCostCalculatorState extends State<TaskEnergyCostCalculator> {
  double _workloadPercentage = 50.0;
  double _taskDurationHours = 1.0;
  double _customPower = 850.0;
  String _selectedPowerOption = 'High End Rig';
  final List<String> _powerOptions = ['High End Rig', 'Custom Input'];
  double? _energyCost;

  double getPowerConsumption() {
    double idlePower = 100;
    double maxPower = _selectedPowerOption == 'Custom Input'
        ? _customPower
        : widget.highEndRigPower;
    return idlePower + (_workloadPercentage / 100) * (maxPower - idlePower);
  }

  double calculateEnergyCost() {
    // Power consumption in kWh = Power in watts * hours / 1000 (to convert watts to kilowatts)
    double powerConsumptionKWh =
        getPowerConsumption() * _taskDurationHours / 1000;

    // Since the price is given per MWh and 1 MWh = 1000 kWh,
    // we divide the price per MWh by 1000 to get the price per kWh.
    double pricePerKWh = widget.currentPricePerKWh;

    // Finally, calculate the cost by multiplying the power consumption in kWh by the price per kWh.
    return powerConsumptionKWh * pricePerKWh;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Align contents to the left
        children: [
          Text('Workload Percentage: ${_workloadPercentage.round()}%',
              style: Theme.of(context).textTheme.titleMedium),
          Slider(
            min: 0,
            max: 100,
            divisions: 100,
            value: _workloadPercentage,
            label: '${_workloadPercentage.round()}%',
            onChanged: (value) {
              setState(() {
                _workloadPercentage = value;
              });
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Expected Task Duration (Hours)'),
            keyboardType: TextInputType.number,
            initialValue: _taskDurationHours.toString(),
            onChanged: (value) {
              setState(() {
                _taskDurationHours = double.tryParse(value) ?? 1.0;
              });
            },
          ),
          DropdownButton<String>(
            isExpanded: true, // Ensure the dropdown takes the full width
            value: _selectedPowerOption,
            onChanged: (String? newValue) {
              setState(() {
                _selectedPowerOption = newValue!;
              });
            },
            items: _powerOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          if (_selectedPowerOption == 'Custom Input')
            TextFormField(
              decoration: const InputDecoration(labelText: 'Custom Power (W)'),
              keyboardType: TextInputType.number,
              initialValue: _customPower.toString(),
              onChanged: (value) {
                setState(() {
                  _customPower = double.tryParse(value) ?? 850.0;
                });
              },
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _energyCost = calculateEnergyCost();
              });
            },
            child: const Text('Calculate'),
          ),
          const SizedBox(height: 16),
          if (_energyCost != null)
            Text(
              'Energy Cost for Task: ${_energyCost!.toStringAsFixed(2)} ct',
              style: Theme.of(context).textTheme.titleMedium,
            ),
        ],
      ),
    );
  }
}
