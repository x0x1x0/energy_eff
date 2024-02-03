import 'package:flutter/material.dart';

class EnergyCostCalculator extends StatefulWidget {
  final double currentPricePerMWh;

  const EnergyCostCalculator({Key? key, required this.currentPricePerMWh})
      : super(key: key);

  @override
  State<EnergyCostCalculator> createState() => _EnergyCostCalculatorState();
}

class _EnergyCostCalculatorState extends State<EnergyCostCalculator> {
  final _formKey = GlobalKey<FormState>();

  // Create text editing controllers for each input field
  final TextEditingController _pricePerKWhController = TextEditingController();
  final TextEditingController _powerConsumptionController =
      TextEditingController();
  final TextEditingController _hoursPerDayController = TextEditingController();

  bool _showResults = false; // Added state for visibility of results

  // Variables to hold calculation results
  double? _dayCost;
  double? _weekCost;
  double? _monthCost;
  double? _yearCost;

  @override
  void initState() {
    super.initState();
    // Initialize the price per kWh controller with the default value
    _pricePerKWhController.text = (widget.currentPricePerMWh / 100).toString();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    _pricePerKWhController.dispose();
    _powerConsumptionController.dispose();
    _hoursPerDayController.dispose();
    super.dispose();
  }

  void calculateCost() {
    final double pricePerKWh = double.parse(_pricePerKWhController.text);
    final double powerConsumption =
        double.parse(_powerConsumptionController.text);
    final double hoursPerDay = double.parse(_hoursPerDayController.text);

    final kWh = (powerConsumption / 1000) * hoursPerDay; // Convert watts to kWh
    setState(() {
      _dayCost = kWh * pricePerKWh;
      _weekCost = _dayCost! * 7;
      _monthCost = _dayCost! * 30;
      _yearCost = _dayCost! * 365;
      _showResults = true; // Show results after calculation
    });
  }

  bool get _isCalculateButtonEnabled {
    return _pricePerKWhController.text.isNotEmpty &&
        _powerConsumptionController.text.isNotEmpty &&
        _hoursPerDayController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Restored color from theme
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        boxShadow: [
          // Restored shadow effect
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _pricePerKWhController,
                  decoration:
                      const InputDecoration(labelText: 'Price per kWh (EUR)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() {}),
                ),
                TextFormField(
                  controller: _powerConsumptionController,
                  decoration: const InputDecoration(
                      labelText: 'Power Consumption (Watts)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() {}),
                ),
                TextFormField(
                  controller: _hoursPerDayController,
                  decoration:
                      const InputDecoration(labelText: 'Hours used per day'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() {}),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _isCalculateButtonEnabled
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              calculateCost();
                            }
                          }
                        : null,
                    child: const Text('Calculate'),
                  ),
                ),
              ],
            ),
          ),
          // Results Section
          Visibility(
            visible: _showResults,
            child: Column(
              children: [
                Text(
                  'Results',
                ),
                Text('Day: ${_dayCost?.toStringAsFixed(2)} EUR'),
                Text('Week: ${_weekCost?.toStringAsFixed(2)} EUR'),
                Text('Month: ${_monthCost?.toStringAsFixed(2)} EUR'),
                Text('Year: ${_yearCost?.toStringAsFixed(2)} EUR'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
