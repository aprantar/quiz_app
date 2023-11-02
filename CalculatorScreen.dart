import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';

  void _handleButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == '=') {
        _input = _calculateResult();
      } else if (buttonText == 'AC') {
        _input = '';
      } else if (buttonText == '√') {
        _input = _calculateSquareRoot();
      } else if (buttonText == 'sin') {
        _input = 'sin(' + _input + ')';
      } else if (buttonText == 'cos') {
        _input = 'cos(' + _input + ')';
      } else if (buttonText == 'tan') {
        _input = 'tan(' + _input + ')';
      } else {
        _input += buttonText;
      }
    });
  }

  String _calculateResult() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_input);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      if (result.isNaN) {
        return 'Error';
      }
      return result.toStringAsFixed(2);
    } catch (e) {
      return 'Error';
    }
  }

  String _calculateSquareRoot() {
    try {
      Parser p = Parser();
      Expression exp = p.parse('sqrt($_input)');
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      if (result.isNaN) {
        return 'Error';
      }
      return result.toStringAsFixed(2);
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(32),
              alignment: Alignment.bottomRight,
              child: Text(
                _input,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 37, 31, 31),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
              ),
              child: Column(
                children: [
                  _buildButtonRow(['AC', '√', 'sin', 'cos']),
                  _buildButtonRow(['7', '8', '9', 'tan']),
                  _buildButtonRow(['4', '5', '6', '-']),
                  _buildButtonRow(['1', '2', '3', '+']),
                  _buildButtonRow(['0', '.', '=']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttonLabels) {
    return Expanded(
      child: Row(
        children: buttonLabels
            .map((label) => Expanded(child: _buildButton(label)))
            .toList(),
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => _handleButtonPressed(buttonText),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        child: Container(
          width: 60,
          height: 60,
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    ),
  );
}