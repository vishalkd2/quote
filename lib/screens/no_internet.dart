import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  final VoidCallback onRetry;
  const NoInternet({super.key,required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
        Image.asset('assets/onBoarding/nointernet.png',height: 200),
        const SizedBox(height: 20),
        Text("No Internet Connection",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("Please check your internet connection and try again",textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 30),
        ElevatedButton.icon(onPressed: onRetry,icon: const Icon(Icons.refresh),label: const Text("Try Again"),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        )

      ]),
    );
  }
}
