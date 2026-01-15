

import 'package:flutter/cupertino.dart';
import 'package:quote/screens/about_developer.dart';
import 'package:quote/screens/generate_random_image.dart';
import 'package:quote/screens/generate_random_quote.dart';
import 'package:quote/screens/on_boarding_screen.dart';
import 'package:quote/screens/quote_of_screen.dart';
import 'package:quote/screens/quote_screen.dart';
import 'package:quote/screens/splash_screen.dart';

class AppRoute{
  static Map<String,WidgetBuilder> routes = {
    '/':(context)=> SplashScreen(),
    '/onBoarding':(_)=>OnBoardingScreen(),
    '/quoteScreen':(context)=> QuoteScreen(),
    '/quoteOfDay':(context)=>QuoteOfScreen(),
    '/generateRandomQuote':(context)=>GenerateRandomQuote(),
    '/generateRandomImage':(context)=>GenerateRandomImage(),
    '/aboutDeveloper':(context)=>AboutDeveloper(),
  };
}