import 'package:exemplo_api/Controller/city_database_controller.dart';
import 'package:exemplo_api/Controller/weather_controller.dart';
import 'package:exemplo_api/View/details_weather_screen.dart';
import 'package:flutter/material.dart';
import '../Model/city_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cityController = TextEditingController();
  final WeatherController _controller = WeatherController();
  final CityDbController _dbController = CityDbController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: "Enter the city name",
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Please enter a city";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _cityFind(_cityController.text);
                    }
                  },
                  child: const Text("Search"),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: _buildSavedCitiesList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavedCitiesList() {
    return FutureBuilder(
      future: _dbController.listCities(),
      builder: (context, AsyncSnapshot<List<City>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No saved locations"));
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(snapshot.data![index].cityName),
              onTap: () {
                _navigateToWeatherDetails(snapshot.data![index].cityName);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _cityFind(String city) async {
    if (await _controller.findCity(city)) {
      City cityToAdd = City(cityName: city, favoritesCities: false);
      _dbController.addCity(cityToAdd);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("City found"),
          duration: Duration(seconds: 1),
        ),
      );
      _navigateToWeatherDetails(city);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("City not found"),
          duration: Duration(seconds: 2),
        ),
      );
      _cityController.clear();
    }
  }

  void _navigateToWeatherDetails(String cityName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherDetailsScreen(cityName: cityName),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
