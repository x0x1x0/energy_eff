import 'package:flutter/material.dart';

class TaskEnergyCostCalculator extends StatefulWidget {
  const TaskEnergyCostCalculator({Key? key}) : super(key: key);

  @override
  State<TaskEnergyCostCalculator> createState() =>
      _TaskEnergyCostCalculatorState();
}

class _TaskEnergyCostCalculatorState extends State<TaskEnergyCostCalculator> {
  double _workloadPercentage = 50.0;

  String _selectedPowerOption = 'High End Rig';
  final List<String> _powerOptions = ['High End Rig', 'Custom Input'];

  // Controllers for each TextFormField
  final TextEditingController _currentPricePerKWhController =
      TextEditingController(text: "0.30");
  final TextEditingController _customPowerController =
      TextEditingController(text: "850");
  final TextEditingController _taskDurationHoursController =
      TextEditingController(text: "1");

  @override
  void initState() {
    super.initState();
    // No additional setup required for initState
  }

  @override
  void dispose() {
    _currentPricePerKWhController.dispose();
    _customPowerController.dispose();
    _taskDurationHoursController.dispose();
    super.dispose();
  }

  double getPowerConsumption() {
    double idlePower = 100; // Assuming an idle power consumption
    double maxPower = _selectedPowerOption == 'Custom Input'
        ? double.parse(_customPowerController.text)
        : 850.0;
    return idlePower + (_workloadPercentage / 100) * (maxPower - idlePower);
  }

  double calculateEnergyCost() {
    final double currentPricePerKWh =
        double.parse(_currentPricePerKWhController.text);
    final double powerConsumptionKWh = getPowerConsumption() *
        (_taskDurationHoursController.text.isEmpty
            ? 1.0
            : double.parse(_taskDurationHoursController.text)) /
        1000;
    return powerConsumptionKWh * currentPricePerKWh;
  }

  @override
  Widget build(BuildContext context) {
    double _energyCost = calculateEnergyCost(); // Dynamically calculate cost

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
        crossAxisAlignment: CrossAxisAlignment.center,
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
            controller: _taskDurationHoursController,
            decoration: const InputDecoration(
                labelText: 'Expected Task Duration (Hours)'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                // The state update is implicit due to recalculation in build method
              });
            },
          ),
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedPowerOption,
            onChanged: (String? newValue) {
              setState(() {
                _selectedPowerOption = newValue!;
                if (newValue == 'High End Rig') {
                  _customPowerController.text =
                      '850'; // Reset if going back to High End Rig
                }
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
              controller: _customPowerController,
              decoration: const InputDecoration(labelText: 'Custom Power (W)'),
              keyboardType: TextInputType.number,
              // No need to explicitly set state here; build method handles updates
            ),
          TextFormField(
            controller: _currentPricePerKWhController,
            decoration: const InputDecoration(labelText: 'Price per kWh (EUR)'),
            keyboardType: TextInputType.number,

            // No need to explicitly set state here; build method handles updates
          ),
          const SizedBox(height: 20),
          Text(
            'Energy Cost for Task: ${_energyCost.toStringAsFixed(2)} EUR',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
