import 'package:http/http.dart' as http;
import 'dart:convert';

class RenSignal {
  final int unixSeconds;
  final double share;
  final int signal;

  RenSignal(
      {required this.unixSeconds, required this.share, required this.signal});

  factory RenSignal.fromJson(Map<String, dynamic> json) {
    return RenSignal(
      unixSeconds: json['unix_seconds'],
      share: json['share'],
      signal: json['signal'],
    );
  }
}

class RenSignalService {
  Future<List<RenSignal>> fetchRenSignal() async {
    String url =
        'https://api.energy-charts.info/signal'; // Ensure this is the correct URL

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<int> unixSecondsList = List<int>.from(jsonResponse['unix_seconds']);
      List<double> shareList = List<double>.from(jsonResponse['share']);
      List<int> signalList = List<int>.from(jsonResponse['signal']);

      List<RenSignal> renSignals =
          List<RenSignal>.generate(unixSecondsList.length, (index) {
        return RenSignal(
          unixSeconds: unixSecondsList[index],
          share: shareList[index],
          signal: signalList[index],
        );
      });

      return renSignals;
    } else {
      throw Exception('Failed to load renewable signal data');
    }
  }
}
