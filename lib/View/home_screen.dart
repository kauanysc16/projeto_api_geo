import 'package:exemplo_api/Controller/weather_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherController _controller = WeatherController();

  @override
  void initState() {
    _getWeather();
    super.initState();
  }

  Future<void> _getWeather() async {
    try {
      Position _position = await Geolocator.getCurrentPosition();
      _controller.getWeatherbyLocation(_position.latitude, _position.longitude);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previsão do Tempo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/favorites');
                    },
                    child: const Text("Favoritos"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    },
                    child: const Text("Localização"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (_controller.weatherList.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Localização Não Encontrada"),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              _getWeather();
                            },
                          ),
                        ],
                      );
                    } else {
                      var weather = _controller.weatherList.last;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weather.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            weather.main,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            weather.description,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildWeatherInfo(
                                Icons.thermostat_outlined,
                                '${(weather.temp - 273.15).toStringAsFixed(1)} °C',
                                'Temperatura',
                              ),
                              const SizedBox(width: 24),
                              _buildWeatherInfo(
                                Icons.arrow_drop_up,
                                '${(weather.tempMax - 273.15).toStringAsFixed(1)} °C',
                                'Máxima',
                              ),
                              const SizedBox(width: 24),
                              _buildWeatherInfo(
                                Icons.arrow_drop_down,
                                '${(weather.tempMin - 273.15).toStringAsFixed(1)} °C',
                                'Mínima',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              _getWeather();
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 36),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
