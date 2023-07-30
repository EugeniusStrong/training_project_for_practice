import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _numbersButton = [
    '7',
    '8',
    '9',
    '-',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '*',
    '00',
    '0',
    '.',
    '/',
    'C',
    '=',
    'DEL',
    '%',
  ];

  String _displayText = '';
  String _resultText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        _displayText,
                        style: const TextStyle(fontSize: 35),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        _resultText,
                        style: const TextStyle(fontSize: 45),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: _numbersButton.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () => _tapped(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isNumber(_numbersButton[index])
                            ? Colors.yellow
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          _numbersButton[index],
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: isNumber(_numbersButton[index])
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isNumber(String x) {
    if (x == '1' ||
        x == '2' ||
        x == '3' ||
        x == '4' ||
        x == '5' ||
        x == '6' ||
        x == '7' ||
        x == '8' ||
        x == '9' ||
        x == '0' ||
        x == '00' ||
        x == '.') {
      return true;
    }
    return false;
  }

  void _tapped(int index) {
    setState(() {
      if (_numbersButton[index] == 'C') {
        _displayText = '';
        _resultText = '';
      } else if (_numbersButton[index] == 'DEL') {
        if (_displayText.isNotEmpty) {
          _displayText = _displayText.substring(0, _displayText.length - 1);
        }
      } else if (_numbersButton[index] == '=') {
        calculateResult();
      } else {
        bool isOperator = _numbersButton[index] == '+' ||
            _numbersButton[index] == '-' ||
            _numbersButton[index] == 'x' ||
            _numbersButton[index] == '/';

        bool isLastCharacterOperator = _displayText.isNotEmpty &&
            (_displayText.endsWith('+') ||
                _displayText.endsWith('-') ||
                _displayText.endsWith('x') ||
                _displayText.endsWith('/'));

        if (isOperator && isLastCharacterOperator) {
          return;
        }

        _displayText += _numbersButton[index];
      }
    });
  }

  void calculateResult() {
    String result = _displayText;

    Parser p = Parser();
    Expression exp = p.parse(result);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    _resultText = eval.toString();
  }
}
