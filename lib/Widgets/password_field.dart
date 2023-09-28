import 'package:flutter/material.dart';

class Textp extends StatefulWidget {
  const Textp({
    super.key,
    required this.title,
    required this.controller,
    required this.visible,
  });

  final String title;
  final TextEditingController controller;
  final bool visible;

  @override
  State<Textp> createState() => _TextState();
}

class _TextState extends State<Textp> {
  @override
  Widget build(BuildContext context) {
    bool pass = widget.visible;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: TextField(
            controller: widget.controller,
            obscureText: pass,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15),
              hintText: widget.title,
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
        ),
      ),
    );
  }
}
