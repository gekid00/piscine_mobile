import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _recherche.dispose();
    super.dispose();
  }

  void _chercher(String valeur) {
    setState(() {
      _lieu = valeur;
    });
  }

  void _geolocaliser() {
    _recherche.clear();
    setState(() {
      _lieu = 'Geolocation';
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
                  children: [Text(nom), Text(_lieu)],
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
