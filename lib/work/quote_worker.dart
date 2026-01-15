import 'dart:convert';
import 'dart:developer';
import 'package:quote/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart'as http;

const dailyQuoteTask = 'dailyQuoteTask';
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    log("🚀 WorkManager triggered", name: "WORKMANAGER");
    if (task == dailyQuoteTask) {
      log("📅 Daily quote task running", name: "WORKMANAGER");
         try{
           final response = await http.get(Uri.parse('https://zenquotes.io/api/today'),headers: {"accept": "application/json"});
           if(response.statusCode==200){
             final List data = jsonDecode(response.body);
             final String quote = data[0]["q"];
             final String author = data[0]["a"];
             log("📡 Quote: $quote", name: "WORKMANAGER");
             await NotificationService().showQuoteNotification(id: 100,quote: quote,author: author);
           }
           //schedule next day again
           final now = DateTime.now();
           final tomorrow = DateTime(now.year,now.month,now.day+1,08,30);
           // final tomorrow = now.add(const Duration(seconds: 20));  //Testing
           final delay = tomorrow.difference(now);
           await Workmanager().registerOneOffTask(
             "dailyQuoteTaskId_${DateTime.now().millisecondsSinceEpoch}",
             dailyQuoteTask,
             initialDelay: delay,
             constraints: Constraints(networkType: NetworkType.connected),
           );

         }catch(e){throw Exception(e);}
    }
    return true;
  });
}
