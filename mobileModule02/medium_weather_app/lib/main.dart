import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(home: WeatherApp()));
}

class WeatherApp extends StatefulWidget {
  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  static const List<String> onglets = ['Currently', 'Today', 'Weekly'];
  static const List<IconData> icones = [
    Icons.wb_sunny,
    Icons.today,
    Icons.calendar_month,
  ];

  final TextEditingController _recherche = TextEditingController();
  String _lieu = '';
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _geolocaliser();
  }

  @override
  void dispose() {
    _recherche.dispose();
    super.dispose();
  }

  void _chercher(String valeur) {
    setState(() {
      _lieu = valeur;
      _erreur = null;
    });
  }

  void _echouer(String message) {
    setState(() {
      _lieu = '';
      _erreur = message;
    });
  }

  Future<void> _geolocaliser() async {
    _recherche.clear();

    if (!await Geolocator.isLocationServiceEnabled()) {
      _echouer('Location services are disabled.');
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _echouer('Location permission denied. Search a city instead.');
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _lieu = '${position.latitude}, ${position.longitude}';
      _erreur = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: onglets.length,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _recherche,
            onSubmitted: _chercher,
            decoration: InputDecoration(
              hintText: 'Search location...',
              border: InputBorder.none,
              icon: Icon(Icons.search),
            ),
          ),
          actions: [
            IconButton(onPressed: _geolocaliser, icon: Icon(Icons.location_on)),
          ],
        ),
        body: TabBarView(
          children: [
            for (final nom in onglets)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(nom),
                    Text(_lieu),
                    if (_erreur != null)
                      Text(
                        _erreur!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            tabs: [
              for (var i = 0; i < onglets.length; i++)
                Tab(icon: Icon(icones[i]), text: onglets[i]),
            ],
          ),
        ),
      ),
    );
  }
}
