import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iOS Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayValue = '0';
  double _firstNumber = 0;
  String _operation = '';
  bool _shouldClearDisplay = false;
  String _expressionDisplay = '';  // Để hiển thị biểu thức toán học
  bool _operationJustPressed = false;

  void _onNumberClick(String number) {
    setState(() {
      if (_displayValue == '0' || _shouldClearDisplay) {
        _displayValue = number;
        _shouldClearDisplay = false;
      } else {
        _displayValue += number;
      }
      _operationJustPressed = false;
    });
  }

  void _onOperationClick(String operation) {
    if (_operationJustPressed) {
      // Nếu người dùng đã ấn một phép toán và ấn phép toán khác, thay thế phép toán cũ
      setState(() {
        _operation = operation;
        _expressionDisplay = '${_firstNumber.toString()} $operation';
      });
      return;
    }
    
    setState(() {
      _firstNumber = double.parse(_displayValue);
      _operation = operation;
      _shouldClearDisplay = true;
      _operationJustPressed = true;
      
      // Cập nhật hiển thị biểu thức
      _expressionDisplay = '${_displayValue.toString()} $operation';
    });
  }

  void _onEqualsClick() {
    setState(() {
      if (_operation.isNotEmpty) {
        double secondNumber = double.parse(_displayValue);
        double result = 0;
        
        switch (_operation) {
          case '+':
            result = _firstNumber + secondNumber;
            break;
          case '-':
            result = _firstNumber - secondNumber;
            break;
          case '×':
            result = _firstNumber * secondNumber;
            break;
          case '÷':
            result = secondNumber != 0 ? _firstNumber / secondNumber : 0;
            break;
        }

        // Hiển thị biểu thức đầy đủ
        _expressionDisplay = '$_firstNumber $_operation $secondNumber = ';
        
        _displayValue = result % 1 == 0 ? result.toInt().toString() : result.toString();
        _operation = '';
        _firstNumber = result;
        _shouldClearDisplay = true;
        _operationJustPressed = false;
      }
    });
  }

  void _onClearClick() {
    setState(() {
      _displayValue = '0';
      _firstNumber = 0;
      _operation = '';
      _shouldClearDisplay = false;
      _expressionDisplay = '';
      _operationJustPressed = false;
    });
  }

  void _onDecimalClick() {
    setState(() {
      if (_shouldClearDisplay) {
        _displayValue = '0.';
        _shouldClearDisplay = false;
      } else if (!_displayValue.contains('.')) {
        _displayValue += '.';
      }
      _operationJustPressed = false;
    });
  }

  void _onPercentClick() {
    setState(() {
      double value = double.parse(_displayValue);
      value = value / 100;
      _displayValue = value.toString();
      _operationJustPressed = false;
    });
  }

  void _onSignChange() {
    setState(() {
      double value = double.parse(_displayValue);
      value = -value;
      _displayValue = value.toString();
      _operationJustPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Expression display
                    Text(
                      _expressionDisplay,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    // Result display
                    Text(
                      _displayValue,
                      style: TextStyle(
                        fontSize: _displayValue.length > 8 ? 60 : 88,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            
            // Buttons area
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton('AC', color: const Color(0xFF9E9E9E), textColor: Colors.black),
                      _buildButton('+/-', color: const Color(0xFF9E9E9E), textColor: Colors.black),
                      _buildButton('%', color: const Color(0xFF9E9E9E), textColor: Colors.black),
                      _buildButton('÷', color: const Color(0xFFFF9800)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton('7', color: const Color(0xFF333333)),
                      _buildButton('8', color: const Color(0xFF333333)),
                      _buildButton('9', color: const Color(0xFF333333)),
                      _buildButton('×', color: const Color(0xFFFF9800)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton('4', color: const Color(0xFF333333)),
                      _buildButton('5', color: const Color(0xFF333333)),
                      _buildButton('6', color: const Color(0xFF333333)),
                      _buildButton('-', color: const Color(0xFFFF9800)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton('1', color: const Color(0xFF333333)),
                      _buildButton('2', color: const Color(0xFF333333)),
                      _buildButton('3', color: const Color(0xFF333333)),
                      _buildButton('+', color: const Color(0xFFFF9800)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton('0', color: const Color(0xFF333333), isWide: true),
                      _buildButton('.', color: const Color(0xFF333333)),
                      _buildButton('=', color: const Color(0xFFFF9800)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, {
    required Color color, 
    Color textColor = Colors.white, 
    bool isWide = false
  }) {
    double buttonSize = (MediaQuery.of(context).size.width - 64) / 4;
    
    return Container(
      width: isWide ? buttonSize * 2 + 8 : buttonSize,
      height: buttonSize,
      margin: EdgeInsets.only(right: isWide ? 8 : 0),
      child: ElevatedButton(
        onPressed: () {
          switch (text) {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
              _onNumberClick(text);
              break;
            case '+':
            case '-':
            case '×':
            case '÷':
              _onOperationClick(text);
              break;
            case '=':
              _onEqualsClick();
              break;
            case 'AC':
              _onClearClick();
              break;
            case '.':
              _onDecimalClick();
              break;
            case '%':
              _onPercentClick();
              break;
            case '+/-':
              _onSignChange();
              break;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: isWide 
              ? const StadiumBorder() 
              : const CircleBorder(),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}