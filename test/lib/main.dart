import 'dart:async'; // Import thư viện cho việc sử dụng Timer
import 'dart:math'; // Import thư viện cho việc sử dụng hàm cos và sin
import 'package:flutter/material.dart'; // Import thư viện flutter

void main() {
  runApp(MyClockApp()); // Khởi chạy ứng dụng Flutter
}

class MyClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ẩn biểu tượng "debug" trên banner
      home: Scaffold(
        appBar: AppBar(
          title: Text("Minh Triet - Viet Cuong"), // Tiêu đề ứng dụng
        ),
        body: Container(
          color: Color.fromARGB(255, 255, 255, 255), // Đặt màu nền là màu vàng
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyClock(), // Hiển thị đồng hồ
                SizedBox(
                  height: 20,
                ), // Khoảng cách giữa đồng hồ và hộp thời gian kỹ thuật số
                DigitalTimeBox(), // Hộp hiển thị thời gian kỹ thuật số
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyClock extends StatefulWidget {
  @override
  _MyClockState createState() => _MyClockState(); // Tạo ra trạng thái cho đồng hồ
}

class _MyClockState extends State<MyClock> {
  DateTime _currentTime = DateTime.now(); // Lưu trữ thời gian hiện tại
  Timer? _timer; // Biến đếm thời gian

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      Duration(seconds: 1),
      _updateTime,
    ); // Cập nhật thời gian mỗi giây
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy timer khi widget bị hủy
    super.dispose();
  }

  void _updateTime(Timer timer) {
    setState(() {
      _currentTime = DateTime.now(); // Cập nhật thời gian mới
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360, // Chiều rộng của đồng hồ
      height: 360, // Chiều cao của đồng hồ
      child: CustomPaint(
        painter: ClockPainter(_currentTime), // Vẽ đồng hồ
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time; // Thời gian hiện tại
  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2; // Tọa độ x của tâm đồng hồ
    final centerY = size.height / 2; // Tọa độ y của tâm đồng hồ
    final center = Offset(centerX, centerY); // Tọa độ tâm đồng hồ
    final radius = min(centerX, centerY); // Bán kính của đồng hồ

    // Vẽ đường viền mặt đồng hồ
    final borderPaint =
        Paint()
          ..color = Color.fromARGB(255, 232, 243, 235) // Màu viền đồng hồ
          ..style =
              PaintingStyle
                  .stroke // Kiểu vẽ là nét kẻ
          ..strokeWidth = 21; // Độ dày của viền

    canvas.drawCircle(
      center,
      radius + 5,
      borderPaint,
    ); // Vẽ đường viền mặt đồng hồ (thêm 5 để dày viền ra ngoài)

    // Vẽ mặt đồng hồ
    final facePaint =
        Paint()
          ..color = Color.fromARGB(255, 29, 154, 203) // Màu mặt đồng hồ
          ..style = PaintingStyle.fill; // Kiểu vẽ là toàn phần

    canvas.drawCircle(center, radius, facePaint); // Vẽ mặt đồng hồ

    // Vẽ các chỉ số giờ và các đường nhỏ giữa các chỉ số
    final mainLinePaint =
        Paint()
          ..color = Color.fromARGB(255, 18, 17, 17) // Màu của các điểm chỉ số
          ..style =
              PaintingStyle
                  .stroke // Kiểu vẽ là nét kẻ
          ..strokeWidth = 2; // Độ dày của các đường chỉ số

    final smallLinePaint =
        Paint()
          ..color = Color.fromARGB(255, 18, 17, 17) // Màu của các điểm chỉ số
          ..style =
              PaintingStyle
                  .stroke // Kiểu vẽ là nét kẻ
          ..strokeWidth = 1; // Độ dày của các đường chỉ số nhỏ

    for (int i = 1; i <= 60; i++) {
      final angle = (i - 15) * 6 * (pi / 180); // Tính góc dựa trên số giờ
      final lineRadius =
          radius - (i % 5 == 0 ? 15 : 10); // Độ dài của đường chỉ số
      final startX =
          centerX + cos(angle) * lineRadius; // Tọa độ x của điểm bắt đầu
      final startY =
          centerY + sin(angle) * lineRadius; // Tọa độ y của điểm bắt đầu
      final endX = centerX + cos(angle) * radius; // Tọa độ x của điểm kết thúc
      final endY = centerY + sin(angle) * radius; // Tọa độ y của điểm kết thúc

      if (i % 5 == 0) {
        // Nếu là số giờ, vẽ đường chính lên
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          mainLinePaint,
        );
      } else {
        // Nếu không, vẽ đường nhỏ giữa các số
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          smallLinePaint,
        );
      }
    }

    // Vẽ các số thường
    for (int i = 1; i <= 12; i++) {
      final angle = (i - 3) * 30 * (pi / 180); // Tính góc dựa trên số giờ
      final x = centerX + cos(angle) * (radius - 30); // Tọa độ x của số
      final y = centerY + sin(angle) * (radius - 30); // Tọa độ y của số
      final number = i.toString(); // Lấy số thường

      final textPainter = TextPainter(
        text: TextSpan(
          text: number,
          style: TextStyle(
            color: Colors.white, // Màu của số giờ
            fontSize: 24, // Kích thước của số giờ
            fontWeight: FontWeight.bold, // Độ đậm của số giờ
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      ); // Vẽ số giờ
    }

    // Vẽ kim giờ
    final hourPaint =
        Paint()
          ..color = Color.fromARGB(255, 0, 0, 0) // Màu của kim giờ
          ..style =
              PaintingStyle
                  .stroke // Kiểu vẽ là nét kẻ
          ..strokeCap =
              StrokeCap
                  .round // Kiểu đầu của kim giờ
          ..strokeWidth = 12; // Độ dày của kim giờ

    final hourAngle =
        ((time.hour % 12 + time.minute / 60) * 30 - 90) *
        (pi / 180); // Tính góc của kim giờ
    canvas.drawLine(
      center,
      center +
          Offset(cos(hourAngle) * radius * 0.5, sin(hourAngle) * radius * 0.5),
      hourPaint,
    );

    // Vẽ kim phút
    final minutePaint =
        Paint()
          ..color = const Color.fromARGB(255, 82, 89, 94) // Màu của kim phút
          ..style =
              PaintingStyle
                  .stroke // Kiểu vẽ là nét kẻ
          ..strokeCap =
              StrokeCap
                  .round // Kiểu đầu của kim phút
          ..strokeWidth = 9; // Độ dày của kim phút

    final minuteAngle =
        ((time.minute + time.second / 60) * 6 - 90) *
        (pi / 180); // Tính góc của kim phút
    canvas.drawLine(
      center,
      center +
          Offset(
            cos(minuteAngle) * radius * 0.7,
            sin(minuteAngle) * radius * 0.7,
          ),
      minutePaint,
    );

    // Vẽ kim giây
    final secondPaint =
        Paint()
          ..color =
              Colors
                  .red // Màu của kim giây
          ..style =
              PaintingStyle
                  .stroke // Kiểu vẽ là nét kẻ
          ..strokeCap =
              StrokeCap
                  .round // Kiểu đầu của kim giây
          ..strokeWidth = 5; // Độ dày của kim giây

    final secondAngle =
        ((time.second) * 6 - 90) * (pi / 180); // Tính góc của kim giây
    canvas.drawLine(
      center,
      center +
          Offset(
            cos(secondAngle) * radius * 0.9,
            sin(secondAngle) * radius * 0.9,
          ),
      secondPaint,
    );

    // Vẽ chấm giữa đồng hồ
    final centerDotPaint =
        Paint()
          ..color = Color.fromARGB(
            255,
            202,
            202,
            202,
          ) // Màu của chấm giữa đồng hồ
          ..style = PaintingStyle.fill; // Kiểu vẽ là toàn phần

    canvas.drawCircle(center, 15, centerDotPaint); // Vẽ chấm giữa đồng hồ

    // Vẽ thứ và ngày
    _drawDateAndDay(canvas, centerX, centerY, radius);
  }

  // Hàm lấy tên của ngày trong tuần
  String _getDayOfWeek() {
    final weekdays = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ]; // Tên của các ngày trong tuần
    return weekdays[time.weekday -
        1]; // Trả về tên của ngày trong tuần hiện tại
  }

  // Hàm định dạng số thành dạng có 2 chữ số
  String _formatTwoDigits(int value) {
    return value.toString().padLeft(2, '0'); // Định dạng số có 2 chữ số
  }

  // Hàm vẽ thứ và ngày bên dưới đồng hồ
  void _drawDateAndDay(
    Canvas canvas,
    double centerX,
    double centerY,
    double radius,
  ) {
    final dayText = _getDayOfWeek(); // Lấy tên của ngày trong tuần
    final dateText = _formatTwoDigits(time.day); // Lấy ngày hiện tại
    final dayDateText = "$dayText, $dateText"; // Chuỗi hiển thị thứ và ngày

    final datePainter = TextPainter(
      text: TextSpan(
        text: dayDateText,
        style: TextStyle(
          color: Colors.white, // Màu của thứ và ngày
          fontSize: 24, // Kích thước của thứ và ngày
          fontWeight: FontWeight.bold, // Độ đậm của thứ và ngày
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    datePainter.layout();
    final dateX = centerX - datePainter.width / 2; // Vị trí x của thứ và ngày
    final dateY = centerY + radius * 0.3; // Vị trí y của thứ và ngày
    datePainter.paint(
      canvas,
      Offset(dateX, dateY),
    ); // Vẽ thứ và ngày bên dưới đồng hồ
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DigitalTimeBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final time = snapshot.data!;
        final hours = time.hour.toString().padLeft(2, '0');
        final minutes = time.minute.toString().padLeft(2, '0');
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$hours:$minutes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
