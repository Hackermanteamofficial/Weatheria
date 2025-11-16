import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../service/weather_service.dart';
import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('Your Api Key');
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  _fetchWeather() async {
    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //animation condition
  String getWeatherAnimation(String? mainCondition, bool isNight) {
    if (mainCondition == null) return 'assets/Weather-sunny.json';

    final condition = mainCondition.toLowerCase();
    if (condition.contains("cloud")) return 'assets/Weather-windy.json';
    if (condition.contains("mist") ||
        condition.contains("fog") ||
        condition.contains("haze") ||
        condition.contains("dust")) return 'assets/Weather-windy.json';
    if (condition.contains("drizzle") || condition.contains("rain")) return 'assets/Weather-partly shower.json';
    if (condition.contains("thunderstorm")) return 'assets/Weather-storm.json';
    if (condition.contains("clear")) {
      return isNight ? 'assets/Weather-night.json' : 'assets/Weather-sunny.json';
    }
    return isNight ? 'assets/Weather-night.json' : 'assets/Weather-sunny.json';
  }

  // daytime inspector
  bool isNightTime() {
    if (_weather?.sunrise == null || _weather?.sunset == null) return false;
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    return now < _weather!.sunrise! || now > _weather!.sunset!;
  }


  @override
  Widget build(BuildContext context) {
    final night = isNightTime();

    return Scaffold(
      body: _weather == null
          ? Center(child: CircularProgressIndicator())
          : Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: night
                ? [Colors.indigo.shade900, Colors.black]
                : [Colors.blue.shade400, Colors.lightBlue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // location
                  Text(
                    _weather!.cityName,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  // animation
                  SizedBox(
                    height: 200,
                    child: Lottie.asset(getWeatherAnimation(_weather!.mainCondition, night)),
                  ),
                  SizedBox(height: 16),
                  // temperature
                  Text(
                    '${_weather!.temperature.round()}°C',
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                    ),
                  ),
                  // main condition
                  Text(
                    _weather!.mainCondition,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16),
                  //Row
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.water_drop,color: Colors.white,),
                            Text("Humidity : ${_weather!.humidity}%",
                              style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.thermostat,color: Colors.white,),
                            Text("Feels like : ${_weather!.feelsLike}°C",
                                style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
