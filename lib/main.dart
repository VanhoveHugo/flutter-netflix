import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/movies_service.dart';
import 'services/favorites_service.dart';
import 'views/movies_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OmdbProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OMDb App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MoviesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
