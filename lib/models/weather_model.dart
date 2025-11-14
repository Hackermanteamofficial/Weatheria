class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int? sunrise;
  final int? sunset;
  final int humidity;
  final double feelsLike;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.humidity,
    required this.feelsLike,
    this.sunrise,
    this.sunset
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main'],
        sunrise: json['sys']?['sunrise'],
        sunset: json['sys']?['sunset'],
        humidity: json['main']['humidity'],
        feelsLike: json['main']['feels_like']
    );
  }
}