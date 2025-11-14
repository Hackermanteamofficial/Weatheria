import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import '../models/weather_model.dart';

class WeatherService{

  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if(response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to load weather data");
    }
  }
  //get permit from user
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied");
    }

    try {
      //accuracy
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
      );

      if (placemarks.isEmpty) return "";

      String city = placemarks[0].locality ??
          placemarks[0].subAdministrativeArea ??
          placemarks[0].administrativeArea ??
          "";
      print(placemarks[0]);

      return city;
    } catch (e) {
      throw Exception("Error getting current city: $e");
    }
  }
}