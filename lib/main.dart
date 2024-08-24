import 'package:flutter/material.dart';
import 'package:climatology/services/localizacionusuario.dart';
import 'package:climatology/services/servicioclima.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climatology',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherScreen(),
    );
  }
}
class ForecastScreen extends StatefulWidget {
  const ForecastScreen({Key? key}) : super(key: key);

  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final LocationService locationService = LocationService();
  final WeatherService weatherService = WeatherService();
  Future<Map<String, dynamic>>? forecastData;

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  void _loadForecast() async {
    try {
      final location = await locationService.getLocation();
      setState(() {
        forecastData = weatherService.getForecast(location.latitude!, location.longitude!);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronóstico de los proximos 3 Días'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
      future: forecastData,
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se pudieron obtener los datos'));
          } else {
                final forecast = snapshot.data!['list'];
                return SingleChildScrollView(
                child: Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(3, (index) {
                  final dayForecast = forecast[index * 8]; // Cada 8 horas (24 / 3) tenemos un día
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                    title: Text('${dayForecast['main']['temp_max']}°C / ${dayForecast['main']['temp_min']}°C'),
                    subtitle: Text(dayForecast['weather'][0]['description']),
                    leading: Image.network(
                    'https://openweathermap.org/img/wn/${dayForecast['weather'][0]['icon']}@2x.png',
                  ),
                ),
              );
            }),
          ),
        ),
      );
    }
  },
),

    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronóstico del Clima'),
      ),
      body: const Center(
        child: Text('Aquí se mostrará el pronóstico de los próximos 3 días.'),
      ),
    );
  }


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final LocationService locationService = LocationService();
  final WeatherService weatherService = WeatherService();
  Future<Map<String, dynamic>>? weatherData;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() async {
    try {
      final location = await locationService.getLocation();
      setState(() {
        weatherData = weatherService.getCurrentWeather(location.latitude!, location.longitude!);
      });
    } catch (e) {
      print('Error: $e');
    }
  }




  

  @override

  
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.orange, 
      centerTitle: true, 
      title: const Text(
        'Clima Actual',
        style: TextStyle(fontSize: 24), 
      
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          
          onPressed: _loadWeather,
        )
      ],
    
    
    ),
      body: FutureBuilder<Map<String, dynamic>>(
      future: weatherData,
      builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData) {
      return const Center(child: Text('No se pudieron obtener los datos'));
    } else {
      final weather = snapshot.data!;
      return SingleChildScrollView(
        child: Align(
          alignment: Alignment.center, // Centra el contenido vertical y horizontal
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Añade padding alrededor del contenido
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${weather['main']['temp']}°C',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                  
                ),
                const SizedBox(height:6), 
                Text(
                  weather['weather'][0]['description'],
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center, 
                ),
                const SizedBox(height: 6),
                Image.network(
                  'https://openweathermap.org/img/wn/${weather['weather'][0]['icon']}@2x.png',
                  height: 120, 
                ),
                const SizedBox(height:0), 
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForecastScreen()),
                    );
                  },
                  child: const Text('Revisar Pronóstico'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  },
)
,
    );
  }
}

