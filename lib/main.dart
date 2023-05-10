import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ui/home_page.dart';
import './ui/themes.dart';
import './providers/task_provider.dart';
import './providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (ctx, themeProvider, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: Themes.light,
          darkTheme: Themes.dark,
          themeMode: themeProvider.themeMode,
          home: const HomePage(),
        ),
      ),
    );
  }
}
