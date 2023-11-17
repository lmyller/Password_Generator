import 'package:flutter/services.dart';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
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

    if (int.parse(text) > 20 || int.parse(text) < 1){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione entre 1 a 20 caracteres')));

      return;
    }

    for (var i = 0; i < int.parse(text); i++) {
      if (checkedNumber) {
        int random = Random().nextInt(94) +
            33; // ASCII range for symbols, numbers, uppercase, and lowercase letters
        characters.add(String.fromCharCode(random));
      } else {
        while (true) {
          int random = Random().nextInt(74) + 48;
          if ((random >= 48 && random <= 57) ||
              (random >= 65 && random <= 90) ||
              (random >= 97 && random <= 122)) {
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
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              generatePassword();
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Insira a quantidade de caracteres')),
              );
            }
            },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                password,
                style: const TextStyle(
                  fontFamily: "sans serif",
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                  leadingDistribution: TextLeadingDistribution.proportional
                ),
              ),
              CopyButton(password: password),
            ],
          ),
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
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: "sans serif",
        ),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 10)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
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

class CopyButton extends StatelessWidget {
  final String password;

  const CopyButton({Key? key, required this.password}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: password));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha copiada')),
        );
      },
    );
  }
}