import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingApp(),
    );
  }
}

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<Offset> points = [];
  String selectedEmoji = '😀';

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      points.add(renderBox.globalToLocal(details.globalPosition));
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      points.add(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emoji Drawing App'),
        actions: <Widget>[
          DropdownButton<String>(
            value: selectedEmoji,
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              setState(() {
                selectedEmoji = newValue!;
              });
            },
            items: <String>['😀', '😂', '🥰', '😍', '🤩']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: CustomPaint(
          painter: EmojiPainter(points: points, emoji: selectedEmoji),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class EmojiPainter extends CustomPainter {
  List<Offset?> points;
  String emoji;

  EmojiPainter({required this.points, required this.emoji});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (var point in points) {
      if (point != null) {
        TextSpan span = TextSpan(style: TextStyle(fontSize: 30), text: emoji);
        TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, point);
      }
    }
  }

  @override
  bool shouldRepaint(EmojiPainter oldDelegate) => true;
}
