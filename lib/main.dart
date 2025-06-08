import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stihl_mobile/pages/login_page.dart';

import 'config/user_provider.dart';
import 'theme/theme.dart';
import 'config/route_page.dart';

Future<void> main() async {
  await initializeDateFormatting('ru_RU', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'STIHL',
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.mulishTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
          initialRoute: '/login',
    routes: {
    '/login': (context) => const LoginScreen(),
    '/home': (context) => MyHomePage(),
    },
    ),
    );
  }
}
