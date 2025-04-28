import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const ClockApp());
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: ClockWidget()),
      ),
    );
  }
}

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late Timer _timer;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:"
           "${time.minute.toString().padLeft(2, '0')}:"
           "${time.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(_dateTime),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomPaint(
          painter: ClockPainter(_dateTime),
          size: const Size(300, 300),
        ),
        const SizedBox(height: 16),
        const Text(
          'Hoàng Duy Hướng',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Text(
          '22119187',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Viền ngoài xám
    final Paint borderPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius - 2, borderPaint);

    // Vạch chia giờ/phút
    final Paint tickPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 60; i++) {
      final isHour = i % 5 == 0;
      final tickLength = isHour ? 10.0 : 5.0;
      tickPaint.strokeWidth = isHour ? 2 : 1;

      final angle = 2 * pi * i / 60;
      final start = Offset(
        center.dx + (radius - tickLength - 5) * cos(angle),
        center.dy + (radius - tickLength - 5) * sin(angle),
      );
      final end = Offset(
        center.dx + (radius - 5) * cos(angle),
        center.dy + (radius - 5) * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // Số giờ từ 1–12
    final textStyle = TextStyle(color: Colors.white, fontSize: 16);
    for (int i = 1; i <= 12; i++) {
      final angle = 2 * pi * i / 12 - pi / 2;
      final offset = Offset(
        center.dx + (radius - 30) * cos(angle),
        center.dy + (radius - 30) * sin(angle),
      );
      final textSpan = TextSpan(text: '$i', style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = offset - Offset(textPainter.width / 2, textPainter.height / 2);
      textPainter.paint(canvas, textOffset);
    }

    // Kim giờ
    final hourAngle = 2 * pi * ((dateTime.hour % 12 + dateTime.minute / 60) / 12);
    final hourHand = Offset(
      center.dx + 60 * cos(hourAngle - pi / 2),
      center.dy + 60 * sin(hourAngle - pi / 2),
    );
    canvas.drawLine(center, hourHand, Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round);

    // Kim phút
    final minuteAngle = 2 * pi * (dateTime.minute / 60);
    final minuteHand = Offset(
      center.dx + 90 * cos(minuteAngle - pi / 2),
      center.dy + 90 * sin(minuteAngle - pi / 2),
    );
    canvas.drawLine(center, minuteHand, Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round);

    // Kim giây
    final secondAngle = 2 * pi * (dateTime.second / 60);
    final secondHand = Offset(
      center.dx + 100 * cos(secondAngle - pi / 2),
      center.dy + 100 * sin(secondAngle - pi / 2),
    );
    canvas.drawLine(center, secondHand, Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round);

    // Chấm tròn trung tâm
    canvas.drawCircle(center, 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
