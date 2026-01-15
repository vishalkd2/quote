import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote/provider/quote_provider.dart';
import 'package:quote/screens/no_internet.dart';
import 'package:quote/services/notification_service.dart';
import 'package:quote/services/quote_service.dart';

class QuoteScreen extends StatelessWidget {
  QuoteScreen({super.key});
  final QuoteService service = QuoteService();
  final List<Color> cardColors = [
    Color(0xFFFEEAE6), // Light Peach
    Color(0xFFE8F5E9), // Light Green
    Color(0xFFE3F2FD), // Light Blue
    Color(0xFFFFF3E0), // Light Orange
    Color(0xFFF3E5F5), // Light Purple
    Color(0xFFE0F7FA), // Light Cyan
    Color(0xFFFFFDE7), // Light Yellow
    Color(0xFFF1F8E9), // Light Lime
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: Colors.transparent,centerTitle: true,
      title: const Text("Daily Quotes", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,letterSpacing: 0.5,color: Colors.white,)),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
      drawer: Drawer(
        elevation: 20,child: ListView(
        padding: EdgeInsets.symmetric(vertical: 20),children: [
            UserAccountsDrawerHeader(
              accountName: Text(""),accountEmail: Text(""),
              decoration: BoxDecoration(image: DecorationImage(
                  image: NetworkImage("https://zenquotes.io/api/image"),
                  fit: BoxFit.fill))),
            ListTile(leading: Icon(Icons.sunny),
              title: Text("Quote of the day",style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
              print("QuoteOfTheDayTapped");
              Navigator.pushNamed(context, "/quoteOfDay");
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              iconColor: Colors.orange,
              subtitle: Text("Get your daily inspiration"),
            ),
            Divider(),
            ListTile(leading: Icon(Icons.ac_unit),
              title: Text("Generate new Quotes",style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
              print("GenerateNewQuoteTapped");
              Navigator.pushNamed(context, "/generateRandomQuote");
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              iconColor: Colors.orange,
              subtitle: Text("Create unique quotes"),
            ),
            Divider(),
            ListTile(leading: Icon(Icons.image),
              title: Text("Image Quotes",style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
              print("QuoteWithImageTapped");
              Navigator.pushNamed(context, '/generateRandomImage');
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              iconColor: Colors.orange,
              subtitle: Text("Quotes with beautiful images"),
            ),
            Divider(),
            ListTile(leading: Icon(Icons.person),
              title: Text("About Developer",style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () {
              print("AboutDeveloperTapped");
              Navigator.pushNamed(context, "/aboutDeveloper");
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              iconColor: Colors.orange,
              subtitle: Text("Know about the app creator"),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed:()async{
      //       final quotes = await service.quoteOfTheDay();
      //       if(quotes  !=null && quotes.isNotEmpty){
      //         final quote=quotes.first;
      //         await NotificationService().showQuoteNotification(id: 1, quote: quote.quote, author: quote.author);
      //       }
      //       await Future.delayed(const Duration(seconds: 3));
      //       debugPrint("✅ Quote Of the Day");
      //     },child: const Icon(Icons.notifications)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF1F5),Color(0xFFDDE3EC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<QuoteProvider>(
          builder: (_, provider, _) {
            if (provider.isLoading && provider.quote.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            if (provider.error == "NO_INTERNET") {
              return NoInternet(onRetry: (){provider.fetchQuotes(isRefresh: true);});
            }if (provider.error != null) {
              return Center(child: Text(provider.error!));
            }
            return RefreshIndicator(
              onRefresh: () => provider.fetchQuotes(isRefresh: true),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                itemCount: provider.quote.length,
                itemBuilder: (context, index) {
                  print("Length:${provider.quote.length}");
                  final quote = provider.quote[index];
                  final bgColor = cardColors[index % cardColors.length];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.format_quote, color: Colors.deepPurple, size: 28),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Inspiration",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple.shade400,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          quote.quote,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "— ${quote.author}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
