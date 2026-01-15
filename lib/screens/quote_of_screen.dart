import 'package:flutter/material.dart';
import 'package:quote/model/quote_model.dart';
import 'package:quote/services/quote_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:math';

import 'package:share_plus/share_plus.dart';

class QuoteOfScreen extends StatefulWidget {
  const QuoteOfScreen({super.key});
  @override
  State<QuoteOfScreen> createState() => _QuoteOfScreenState();
}

class _QuoteOfScreenState extends State<QuoteOfScreen> with SingleTickerProviderStateMixin {
  final QuoteService service = QuoteService();
  late AnimationController _controller;

  final List<Color> _gradientColors = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFFf093fb),
    Color(0xFFf5576c),
    Color(0xFF4facfe),
    Color(0xFF00f2fe),
    Color(0xFF43e97b),
    Color(0xFF38f9d7),
  ];

  Color _currentColor = Color(0xFF667eea);
  int _currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1500),vsync: this);
    // Start color cycling animation
    _startColorAnimation();
  }

  void _startColorAnimation() {_controller.repeat(reverse: true, period: Duration(seconds: 3));}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeColor() {
    setState(() {
      _currentColorIndex = (_currentColorIndex + 1) % _gradientColors.length;
      _currentColor = _gradientColors[_currentColorIndex];
    });
  }

  Widget _buildLoadingScreen() {
    return Stack(children: [AnimatedContainer(
          duration: Duration(seconds: 5),decoration: BoxDecoration(gradient: RadialGradient(center: Alignment(0, -0.5),
              radius: 1.5,colors: [_currentColor.withOpacity(0.3),Colors.transparent]))),

        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              // Animated sun icon
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(parent: _controller,curve: Curves.linear),
                ),
                child: Icon(Icons.sunny,size: 80, color: _currentColor,
                ),
              ),

              SizedBox(height: 30),

              // Loading text with animation
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('Loading today\'s wisdom...',
                    textStyle: TextStyle(fontSize: 18,color: Colors.grey[600],fontWeight: FontWeight.w500),
                    speed: Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              ),

              SizedBox(height: 20),

              // Custom progress indicator
              Container(
                width: 200,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: 200 * _controller.value,
                      decoration: BoxDecoration(gradient: LinearGradient(
                          colors: [_currentColor,_currentColor.withOpacity(0.5)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteCard(QuoteModel quote) {
    final random = Random();
    final color = _gradientColors[random.nextInt(_gradientColors.length)];

    return Container(margin: EdgeInsets.all(20),padding: EdgeInsets.all(30),decoration: BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,
        colors: [color.withOpacity(0.9),color.withOpacity(0.7),color.withOpacity(0.9)],
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(color: color.withOpacity(0.4),blurRadius: 30,spreadRadius: 5,offset: Offset(0, 15)),
        BoxShadow(color: Colors.black.withOpacity(0.1),blurRadius: 10,offset: Offset(0, 5),
        ),
      ],
    ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [
        // Decorative top elements
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
          _buildDecorIcon(Icons.format_quote, color),
          _buildDecorIcon(Icons.star_border, color),
        ]),

        SizedBox(height: 20),

        // Quote text with beautiful typography
        ShaderMask(shaderCallback: (bounds) {
          return LinearGradient(
              colors: [Colors.white,Colors.white.withOpacity(0.9)]).createShader(bounds);
        },
          child: Text('"${quote.quote}"',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w300,
              height: 1.5,fontStyle: FontStyle.italic,letterSpacing: 0.5),textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 40),

        // Author section with animation
        Container(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3),width: 1),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(width: 3,height: 20,decoration: BoxDecoration(gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.5)],
            ),borderRadius: BorderRadius.circular(2),
            ),
            ),
            SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('—',style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.7))),
                SizedBox(height: 2),
                AnimatedTextKit(animatedTexts: [TyperAnimatedText(quote.author,
                    textStyle: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),
                    speed: Duration(milliseconds: 50)),
                ],
                    totalRepeatCount: 1),
              ],)),
            _buildDecorIcon(Icons.person, color),
          ],
          ),
        ),

        SizedBox(height: 30),

        // Action buttons
        _buildActionButtons(color, quote),
      ],
      ),
    );
  }

  Widget _buildDecorIcon(IconData icon, Color color) {
    return Container(padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,border: Border.all(color: Colors.white.withOpacity(0.3),width: 1)),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildActionButtons(Color color, QuoteModel quote) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Share button
        _buildAnimatedButton(icon: Icons.share,label: 'Share',color: color,
          onPressed: () {
          SharePlus.instance.share(ShareParams(text: "${quote.quote} Author:${quote.author} "));
          // _showShareAnimation(context);
          },
        ),

        // Like button
        _buildAnimatedButton(icon: Icons.favorite_border,label: 'Save',color: color,
          onPressed: () {_showLikeAnimation(context);},),

        // Refresh button
        _buildAnimatedButton(icon: Icons.refresh,label: 'New',color: color,
          onPressed: () {setState(() {_changeColor();});},),
      ],
    );
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {return Column(children: [InkWell(onTap: onPressed,
          borderRadius: BorderRadius.circular(50),child: Container(width: 60,height: 60,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(0.8),color.withOpacity(0.5)]),
              shape: BoxShape.circle,boxShadow: [
                BoxShadow(color: color.withOpacity(0.3),blurRadius: 10,spreadRadius: 2),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        SizedBox(height: 8),
        Text(label,style: TextStyle(color: color,fontSize: 12,fontWeight: FontWeight.w500)),
      ]);
  }

  void _showShareAnimation(BuildContext context) {
    showDialog(context: context,builder: (context) {
        return Dialog(backgroundColor: Colors.transparent,
          child: Container(padding: EdgeInsets.all(20),decoration: BoxDecoration(
              color: Colors.white,borderRadius: BorderRadius.circular(20)),
            child: Column(mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 50),
                SizedBox(height: 20),
                Text('Not Implemented yet',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              ])));
        },);

    Future.delayed(Duration(seconds: 1), () {Navigator.pop(context);});
  }

  void _showLikeAnimation(BuildContext context) {
    showDialog(context: context,builder: (context) {
        return Dialog(backgroundColor: Colors.transparent,
          child: Container(padding: EdgeInsets.all(20),decoration: BoxDecoration(
              color: Colors.white,borderRadius: BorderRadius.circular(20)),
            child: Column(mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.favorite, color: Colors.red, size: 50),
                SizedBox(height: 20),
                Text('Not Implemented yet!',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))],
            ),
          ),
        );
      },
    );
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  Widget _buildErrorScreen(String error) {
    return Center(child: Container(padding: EdgeInsets.all(30),margin: EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFFff6b6b),Color(0xFFee5a52)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3),blurRadius: 20,spreadRadius: 5)],
        ),
        child: Column(mainAxisSize: MainAxisSize.min,children: [
            Icon(Icons.error_outline, color: Colors.white, size: 60),
            SizedBox(height: 20),
            Text('Oops!',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.white)),
            SizedBox(height: 10),
            Text('Something went wrong',style: TextStyle(fontSize: 16,color: Colors.white.withOpacity(0.9))),
            SizedBox(height: 15),
            Text(error,textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: Colors.white.withOpacity(0.7))),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white,foregroundColor: Color(0xFFff6b6b),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quote of the Day",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,
          color: Colors.black87,letterSpacing: 0.5)),centerTitle: true,elevation: 0,backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF667eea),Color(0xFF764ba2)],
              begin: Alignment.topLeft,end: Alignment.bottomRight))),
        actions: [
          IconButton(icon: Icon(Icons.palette, color: Colors.deepPurple),
            onPressed: _changeColor,tooltip: 'Change Theme'),
        ],
      ),
      body: FutureBuilder<List<QuoteModel>?>(
        future: service.quoteOfTheDay(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingScreen();
          } else if (snapshot.hasError) {
            return _buildErrorScreen(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.format_quote, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text('No quotes available',style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          final quotes = snapshot.data!;

          return Stack(
            children: [
              // Animated background
              AnimatedContainer(
                duration: Duration(seconds: 2),
                decoration: BoxDecoration(gradient: LinearGradient(
                    begin: Alignment.topLeft,end: Alignment.bottomRight,
                    colors: [
                      _currentColor.withOpacity(0.1),
                      Colors.white,
                      _currentColor.withOpacity(0.05),
                    ],
                  ),
                ),
              ),

              // Floating particles
              ...List.generate(20, (index) {
                return Positioned(
                  top: MediaQuery.of(context).size.height * (index / 20),
                  left: sin(index * 0.5) * 50 + 50,
                  child: Container(width: 5,height: 5,
                    decoration: BoxDecoration(color: _currentColor.withOpacity(0.3),shape: BoxShape.circle)),
                );
              }),

              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(children: [
                    // Date display
                    Container(margin: EdgeInsets.only(top: 20, bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(color: _currentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today,size: 16, color: _currentColor),
                          SizedBox(width: 8),
                          Text(DateTime.now().toString().split(' ')[0],
                            style: TextStyle(color: _currentColor,fontWeight: FontWeight.w500,fontSize: 16),
                          )]),
                    ),

                    // Quote cards
                    ...quotes.map((quote) {
                      return _buildQuoteCard(quote);
                    }).toList(),

                    SizedBox(height: 30),
                    // Footer
                    Padding(padding: EdgeInsets.all(20),child: Text('✨ Let this quote inspire your day ✨',
                        style: TextStyle(fontSize: 14,color: Colors.grey[600],fontStyle: FontStyle.italic))),
                  ]))]);}),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
          _controller.reset();
          _controller.forward();
        },
        backgroundColor: _currentColor,
        child: Icon(Icons.autorenew, color: Colors.white),
        shape: CircleBorder(),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'Daily Inspiration',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}