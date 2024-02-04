import 'package:http/http.dart' as http;
import 'dart:convert';

class EnergyPrice {
  final int unixSeconds;
  final double price;

  EnergyPrice({required this.unixSeconds, required this.price});

  factory EnergyPrice.fromJson(Map<String, dynamic> json) {
    return EnergyPrice(
      unixSeconds: json['unix_seconds'],
      price: json['price'],
    );
  }
}

class EnergyPriceService {
  String formatDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}T${dateTime.hour.toString().padLeft(2, '0')}:00+01:00";
  }

  Future<List<EnergyPrice>> fetchPrices() async {
    final DateTime now = DateTime.now();
    final DateTime thirtyDaysagp = now.subtract(const Duration(days: 30));
    final DateTime twentyFourHoursAhead = now.add(const Duration(hours: 24));

    String formattedStart = formatDateTime(thirtyDaysagp);
    String formattedEnd = formatDateTime(twentyFourHoursAhead);

    String encodedStart = Uri.encodeComponent(formattedStart);
    String encodedEnd = Uri.encodeComponent(formattedEnd);

    String url =
        'https://api.energy-charts.info/price?bzn=DE-LU&start=$encodedStart&end=$encodedEnd';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<int> unixSeconds = List<int>.from(jsonResponse['unix_seconds']);
      List<double> prices = List<double>.from(jsonResponse['price']);

      List<EnergyPrice> energyPrices = [];
      for (int i = 0; i < unixSeconds.length; i++) {
        energyPrices
            .add(EnergyPrice(unixSeconds: unixSeconds[i], price: prices[i]));
      }

      return energyPrices;
    } else {
      throw Exception('Failed to load energy prices');
    }
  }
}
