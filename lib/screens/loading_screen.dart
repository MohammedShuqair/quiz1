import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz1/models/image.dart';
import 'package:quiz1/models/quote.dart';
import 'package:quiz1/screens/brain/quote_brain.dart';
import 'package:quiz1/services/fetch_data.dart';
import 'home.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  void getData() async {
    ApiHelper apiHelper = ApiHelper();
    QuoteBrain brain = QuoteBrain();
    brain.quote = await apiHelper.fetchQuote();
    brain.image = await apiHelper.fetchImage(brain.quote.tags?[0] ?? 'sport');
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen(
          quoteBrain: brain,
        );
      }));
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
