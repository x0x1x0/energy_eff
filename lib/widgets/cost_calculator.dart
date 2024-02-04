import 'package:flutter/material.dart';

class EnergyCostCalculator extends StatefulWidget {
  final double currentPricePerKWh;

  const EnergyCostCalculator({super.key, required this.currentPricePerKWh});

  @override
  State<EnergyCostCalculator> createState() => _EnergyCostCalculatorState();
}

class _EnergyCostCalculatorState extends State<EnergyCostCalculator> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pricePerKWhController = TextEditingController();
  final TextEditingController _powerConsumptionController =
      TextEditingController();
  final TextEditingController _hoursPerDayController = TextEditingController();

  bool _showResults = false;
  double? _dayCost;
  double? _weekCost;
  double? _monthCost;
  double? _yearCost;

  @override
  void initState() {
    super.initState();
    _pricePerKWhController.text = widget.currentPricePerKWh.toString();
  }

  @override
  void dispose() {
    _pricePerKWhController.dispose();
    _powerConsumptionController.dispose();
    _hoursPerDayController.dispose();
    super.dispose();
  }

  void calculateCost() {
    if (_formKey.currentState!.validate()) {
      final double pricePerKWh = double.parse(_pricePerKWhController.text);
      final double powerConsumption =
          double.parse(_powerConsumptionController.text);
      final double hoursPerDay = double.parse(_hoursPerDayController.text);

      final double kWhPerDay = (powerConsumption / 1000) * hoursPerDay;
      setState(() {
        _dayCost = kWhPerDay * pricePerKWh;
        _weekCost = _dayCost! * 7;
        _monthCost = _dayCost! * 30;
        _yearCost = _dayCost! * 365;
        _showResults = true;
      });
    }
  }

  bool get _isCalculateButtonEnabled =>
      _pricePerKWhController.text.isNotEmpty &&
      _powerConsumptionController.text.isNotEmpty &&
      _hoursPerDayController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _pricePerKWhController,
                    decoration:
                        const InputDecoration(labelText: 'Price per kWh (ct)'),
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
                          ? () => calculateCost()
                          : null,
                      child: const Text('Calculate'),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _showResults,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Calculation Results',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(
                              label: Text('Metric',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Usage\n(kWh)',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Cost\n(€)',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: [
                          DataRow(cells: [
                            const DataCell(Text('Day')),
                            DataCell(Text((_powerConsumptionController
                                            .text.isNotEmpty &&
                                        _hoursPerDayController.text.isNotEmpty
                                    ? double.parse(
                                            _powerConsumptionController.text) /
                                        1000 *
                                        double.parse(
                                            _hoursPerDayController.text)
                                    : 0)
                                .toStringAsFixed(2))),
                            DataCell(Text('${_dayCost?.toStringAsFixed(2)}')),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text('Week')),
                            DataCell(Text((_powerConsumptionController
                                            .text.isNotEmpty &&
                                        _hoursPerDayController.text.isNotEmpty
                                    ? double.parse(
                                            _powerConsumptionController.text) /
                                        1000 *
                                        double.parse(
                                            _hoursPerDayController.text) *
                                        7
                                    : 0)
                                .toStringAsFixed(2))),
                            DataCell(Text('${_weekCost?.toStringAsFixed(2)}')),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text('Month')),
                            DataCell(Text((_powerConsumptionController
                                            .text.isNotEmpty &&
                                        _hoursPerDayController.text.isNotEmpty
                                    ? double.parse(
                                            _powerConsumptionController.text) /
                                        1000 *
                                        double.parse(
                                            _hoursPerDayController.text) *
                                        30
                                    : 0)
                                .toStringAsFixed(2))),
                            DataCell(Text('${_monthCost?.toStringAsFixed(2)}')),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text('Year')),
                            DataCell(Text((_powerConsumptionController
                                            .text.isNotEmpty &&
                                        _hoursPerDayController.text.isNotEmpty
                                    ? double.parse(
                                            _powerConsumptionController.text) /
                                        1000 *
                                        double.parse(
                                            _hoursPerDayController.text) *
                                        365
                                    : 0)
                                .toStringAsFixed(2))),
                            DataCell(Text('${_yearCost?.toStringAsFixed(2)}')),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
