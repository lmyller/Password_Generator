import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerador de senha"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [GeneratePassword()],
      ),
    );
  }
}

class GeneratePassword extends StatefulWidget {
  const GeneratePassword({Key? key}) : super(key: key);

  @override
  _GeneratePasswordState createState() => _GeneratePasswordState();
}

class _GeneratePasswordState extends State<GeneratePassword> {
  bool checkedNumber = false;
  String password = "";
  final TextEditingController _textController = TextEditingController();

  void generatePassword() {
    FocusScope.of(context).unfocus();

    List<String> characters = [];
    String text = _textController.text;

    for (var i = 0; i < int.parse(text); i++) {
      if (checkedNumber) {
        int random = Random().nextInt(94) + 33; // ASCII range for symbols, numbers, uppercase, and lowercase letters
        characters.add(String.fromCharCode(random));
      } else {
        while (true) {
          int random = Random().nextInt(74) + 48; // ASCII range for symbols, uppercase, and lowercase letters (excluding numbers)
          if ((random >= 48 && random <= 57) || (random >= 65 && random <= 90) || (random >= 97 && random <= 122)) {
            characters.add(String.fromCharCode(random));
            break;
          }
        }
      }
    }

    setState(() {
      password = characters.join('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckBoxWidget(
          label: 'Número',
          isChecked: checkedNumber,
          onChanged: (bool? value) {
            setState(() {
              checkedNumber = value ?? false;
            });
          },
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        InputTextWidget(controller: _textController),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
        ElevatedButton(
          onPressed: generatePassword,
          style: TextButton.styleFrom(
            backgroundColor: Colors.black87,
            minimumSize: const Size(350, 60),
          ),
          child: const Text(
            "Gerar Senha",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: "sans serif",
              color: Colors.white,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
        if (password.isNotEmpty)
          Text(
            password,
            style: const TextStyle(
              fontFamily: "sans serif",
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.black87,
            ),
          )
      ],
    );
  }
}

class CheckBoxWidget extends StatelessWidget {
  final String label;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const CheckBoxWidget({
    Key? key,
    required this.label,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: Colors.black87,
          value: isChecked,
          onChanged: onChanged,
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: "sans serif",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class InputTextWidget extends StatelessWidget {
  final TextEditingController controller;

  const InputTextWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 15),
        labelText: 'Quantidade de caracteres',
        labelStyle: TextStyle(
          color: Colors.black87,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: "sans serif",
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black87),
        ),
      ),
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontFamily: "sans serif",
      ),
    );
  }
}
