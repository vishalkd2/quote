import 'package:flutter/material.dart';

class GenerateRandomImage extends StatefulWidget {
  const GenerateRandomImage({super.key});

  @override
  State<GenerateRandomImage> createState() => _GenerateRandomImageState();
}

class _GenerateRandomImageState extends State<GenerateRandomImage> {
  String imageUrl = "https://zenquotes.io/api/image";

  void _refreshImage() {
    setState(() {
      imageUrl = "https://zenquotes.io/api/image?refresh=${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1f4037),
              Color(0xFF99f2c8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                const Text("Daily Inspiration",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,
                    color: Colors.white,letterSpacing: 1)),

                const SizedBox(height: 20),

                Expanded(child: Padding(padding: const EdgeInsets.all(16),
                    child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20, offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.black.withOpacity(0.2),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// ✨ SUBTEXT
                Text(
                  "Tap below to refresh inspiration",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔄 BUTTON
                GestureDetector(
                  onTap: _refreshImage,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF667eea),
                          Color(0xFF764ba2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.refresh, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Next Image",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
