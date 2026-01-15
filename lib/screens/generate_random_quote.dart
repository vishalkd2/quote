
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote/provider/quote_provider.dart';
import 'package:quote/services/quote_service.dart';

class GenerateRandomQuote extends StatefulWidget {
  const GenerateRandomQuote({super.key});

  @override
  State<GenerateRandomQuote> createState() =>
      _GenerateRandomQuoteState();
}

class _GenerateRandomQuoteState
    extends State<GenerateRandomQuote> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<QuoteProvider>().fetchRandomQuote());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuoteProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff667eea),
              Color(0xff764ba2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                const Spacer(),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : provider.randomQuote == null
                      ? const SizedBox()
                      : Container(key: ValueKey(provider.randomQuote!.quote),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.15),blurRadius: 20,offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "“${provider.randomQuote!.quote}”",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "- ${provider.randomQuote!.author}",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                GestureDetector(
                  onTap: provider.isLoading
                      ? null
                      : () => provider.fetchRandomQuote(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff43cea2),
                          Color(0xff185a9d),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.auto_awesome, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Inspire Me Again",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
