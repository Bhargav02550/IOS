// ignore: file_names
import 'package:flutter/material.dart';

class Textf extends StatefulWidget {
  const Textf({
    super.key,
    required this.title,
    required this.controller,
  });

  final String title;
  final TextEditingController controller;

  @override
  State<Textf> createState() => _TextState();
}

class _TextState extends State<Textf> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.amber[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: TextField(
            controller: widget.controller,
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
