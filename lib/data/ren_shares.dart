import 'package:http/http.dart' as http;
import 'dart:convert';

class RenShareDailyAvg {
  final String day;
  final double data;

  RenShareDailyAvg({required this.day, required this.data});

  factory RenShareDailyAvg.fromJson(Map<String, dynamic> json) {
    return RenShareDailyAvg(
      day: json['day'],
      data: json['data'],
    );
  }
}

class RenShareDailyAvgService {
  Future<List<RenShareDailyAvg>> fetchRenShareDailyAvg() async {
    String url = 'https://api.energy-charts.info/ren_share_daily_avg';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<String> days = List<String>.from(jsonResponse['days']);
      List<double> data = List<double>.from(jsonResponse['data']);

      List<RenShareDailyAvg> renShareDailyAvgs = [];
      for (int i = 0; i < days.length; i++) {
        renShareDailyAvgs.add(RenShareDailyAvg(day: days[i], data: data[i]));
      }

      
      for (var avg in renShareDailyAvgs) {
        print('Day: ${avg.day}, Data: ${avg.data}');
      }

      return renShareDailyAvgs;
    } else {
      throw Exception('Failed to load renewable share daily average');
    }
  }
}
