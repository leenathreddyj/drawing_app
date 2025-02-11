import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 155, 152, 129), // Set primary color to yellow
        colorScheme: ColorScheme.light(
          primary: Colors.yellow,
          secondary: Colors.orangeAccent, // Set accent color to orangeAccent
        ),
        scaffoldBackgroundColor: Colors.transparent, // Make the background transparent for the gradient
        textTheme: TextTheme(
          // Default text color to black
          bodyMedium: TextStyle(color: Colors.black), 
          titleLarge: TextStyle(
            color: Colors.black, 
            fontSize: 24, 
            fontWeight: FontWeight.bold,
          ), // Heading text style
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 239, 238, 232), // AppBar color is now yellow
          titleTextStyle: TextStyle(
            color: Colors.black, // Title text color to black
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow, // Floating action button color to yellow
          foregroundColor: Colors.white,
        ),
      ),
      home: DrawingApp(),
    );
  }
}

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<Map<String, dynamic>> drawnItems = [];
  String selectedEmoji = 'Smiley Face';

  void _onTapDown(TapDownDetails details) {
    setState(() {
      drawnItems.add({
        'emoji': selectedEmoji,
        'position': details.localPosition,
      });
    });
  }

  void _clearCanvas() {
    setState(() {
      drawnItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emoji Drawing App'),
        actions: [
          DropdownButton<String>(
            value: selectedEmoji,
            onChanged: (newValue) {
              setState(() {
                selectedEmoji = newValue!;
              });
            },
            items: ['Smiley Face', 'Party Face', 'Heart']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.black), // Black text for dropdown
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: GestureDetector(
        onTapDown: _onTapDown,
        child: CustomPaint(
          painter: EmojiPainter(drawnItems),
          size: Size.infinite,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearCanvas,
        child: Icon(Icons.clear),
        tooltip: 'Clear Canvas',
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: _clearCanvas,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow, // Button color to yellow
              foregroundColor: Colors.white, // Text color to white
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text('Clear', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}

class EmojiPainter extends CustomPainter {
  final List<Map<String, dynamic>> drawnItems;

  EmojiPainter(this.drawnItems);

  @override
  void paint(Canvas canvas, Size size) {
    // Apply the rainbow gradient as the background
    Paint backgroundPaint = Paint()..shader = LinearGradient(
      colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), backgroundPaint);

    for (var item in drawnItems) {
      Offset position = item['position'];
      String emojiType = item['emoji'];
      
      switch (emojiType) {
        case 'Smiley Face':
          _drawSmileyFace(canvas, position);
          break;
        case 'Party Face':
          _drawPartyFace(canvas, position);
          break;
        case 'Heart':
          _drawHeart(canvas, position);
          break;
      }
    }
  }

  void _drawSmileyFace(Canvas canvas, Offset center) {
    Paint facePaint = Paint()..color = Colors.yellow.shade400;
    Paint eyePaint = Paint()..color = Colors.black;
    Paint mouthPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Draw Face
    canvas.drawCircle(center, 40, facePaint);
    // Draw Eyes
    canvas.drawCircle(Offset(center.dx - 15, center.dy - 10), 5, eyePaint);
    canvas.drawCircle(Offset(center.dx + 15, center.dy - 10), 5, eyePaint);
    // Draw Smile
    Rect mouthRect = Rect.fromCircle(center: Offset(center.dx, center.dy + 10), radius: 20);
    canvas.drawArc(mouthRect, 0, 3.14, false, mouthPaint);
  }

  void _drawPartyFace(Canvas canvas, Offset center) {
    Paint facePaint = Paint()..color = Colors.orange.shade300;
    Paint eyePaint = Paint()..color = Colors.black;
    Paint mouthPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    Paint hatPaint = Paint()..color = Colors.green.shade600;

    // Draw Face
    canvas.drawCircle(center, 40, facePaint);
    // Draw Eyes
    canvas.drawCircle(Offset(center.dx - 15, center.dy - 10), 5, eyePaint);
    canvas.drawCircle(Offset(center.dx + 15, center.dy - 10), 5, eyePaint);
    // Draw Smile
    Rect mouthRect = Rect.fromCircle(center: Offset(center.dx, center.dy + 10), radius: 20);
    canvas.drawArc(mouthRect, 0, 3.14, false, mouthPaint);
    // Draw Party Hat
    Path hat = Path();
    hat.moveTo(center.dx - 20, center.dy - 40);
    hat.lineTo(center.dx + 20, center.dy - 40);
    hat.lineTo(center.dx, center.dy - 70);
    hat.close();
    canvas.drawPath(hat, hatPaint);
    // Draw Confetti
    Paint confettiPaint = Paint()..color = Colors.blue.shade300;
    canvas.drawCircle(Offset(center.dx + 25, center.dy - 30), 3, confettiPaint);
    canvas.drawCircle(Offset(center.dx - 25, center.dy - 35), 3, confettiPaint);
  }

  void _drawHeart(Canvas canvas, Offset center) {
    Paint heartPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red, Colors.pink],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: 40));

    Path heart = Path();
    heart.moveTo(center.dx, center.dy + 20);
    heart.cubicTo(center.dx + 40, center.dy - 20, center.dx + 40, center.dy - 60, center.dx, center.dy - 40);
    heart.cubicTo(center.dx - 40, center.dy - 60, center.dx - 40, center.dy - 20, center.dx, center.dy + 20);
    heart.close();

    canvas.drawPath(heart, heartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
