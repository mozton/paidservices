import 'package:flutter/material.dart';
import 'package:namer_app/provider/paymet_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentProvder(),
      child: MaterialApp(
        title: 'Material App',
        home: DashboardScreen(),
      ),
    );
  }
}