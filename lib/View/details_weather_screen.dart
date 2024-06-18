import 'package:exemplo_api/Controller/weather_controller.dart';
import 'package:flutter/material.dart';

class WeatherDetailsScreen extends StatefulWidget {
  final String cityName;

  const WeatherDetailsScreen({Key? key, required this.cityName}) : super(key: key);

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  final WeatherController _controller = WeatherController();
  bool isFavorite = false;

  @override
  void initState() {
    _controller.getWeather(widget.cityName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Weather Details',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: _controller.getWeather(widget.cityName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar dados.'));
                  } else if (_controller.weatherList.isEmpty) {
                    return Center(child: Text('Dados não encontrados.'));
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_city, size: 32),
                            SizedBox(width: 8),
                            Text(
                              _controller.weatherList.last.name,
                              style: TextStyle(fontSize: 24),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                                color: isFavorite ? Colors.red : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                  // Aqui você pode adicionar a lógica para adicionar/remover dos favoritos
                                  if (isFavorite) {
                                    // Adicionar à lista de favoritos ou realizar outra ação
                                  } else {
                                    // Remover da lista de favoritos ou realizar outra ação
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          _controller.weatherList.last.description,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${(_controller.weatherList.last.temp - 273.15).toStringAsFixed(1)} °C',
                          style: TextStyle(fontSize: 24),
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
    );
  }
}
