import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:quote/core/app_route.dart';
import 'package:quote/provider/quote_provider.dart';
import 'package:quote/work/quote_worker.dart';
import 'package:workmanager/workmanager.dart';
import 'services/notification_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(requestPermission: true);
   await Workmanager().initialize(callbackDispatcher,isInDebugMode: true);
  Workmanager().registerOneOffTask(
    "dailyQuoteTaskId_${DateTime.now().millisecondsSinceEpoch}",
    dailyQuoteTask,
    initialDelay: _initialDelay(),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_)=>QuoteProvider()..fetchQuotes())
  ],child: MyApp()));
}
Duration _initialDelay(){
  final now = DateTime.now();
  final target = DateTime(now.year,now.month,now.day,08,30);
  if(target.isAfter(now)){
    return target.difference(now);
  }else{
    return target.add(const Duration(days: 1)).difference(now);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quote',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      navigatorKey: NotificationService.navigatorKey,
      initialRoute: '/',
      routes:AppRoute.routes,
    );
  }
}

