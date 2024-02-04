import 'package:http/http.dart' as http;
import 'dart:convert';

class EPEXsPrice {
  final String date;
  final double value;

  EPEXsPrice({
    required this.date,
    required this.value,
  });

  factory EPEXsPrice.fromJson(Map<String, dynamic> json) {
    return EPEXsPrice(
      date: json['date'],
      value: json['value'].toDouble(), // Ensure this is treated as double
    );
  }
}

class EPEXsPriceService {
  Future<List<EPEXsPrice>> fetchPrices() async {
    String url = 'https://apis.smartenergy.at/market/v1/price';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Decode the JSON
      Map<String, dynamic> jsonData = json.decode(response.body);

      // Extract the 'data' array
      List<dynamic> data = jsonData['data'];

      // Map each element in the array to an EPEXsPrice object
      List<EPEXsPrice> epexPrices = data.map<EPEXsPrice>((jsonItem) {
        return EPEXsPrice.fromJson(jsonItem);
      }).toList();

      return epexPrices;
    } else {
      throw Exception('Failed to load energy prices');
    }
  }
}
