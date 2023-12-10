import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Textfn extends StatelessWidget {
  Textfn(
      {super.key,
      required this.countryController,
      required this.hint,
      required this.phn});

  final TextEditingController countryController;
  final String hint;
  String phn;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 40,
            child: TextField(
              enabled: false,
              controller: countryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          const Text(
            "|",
            style: TextStyle(fontSize: 33, color: Colors.grey),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: TextField(
            onChanged: (value) {
              phn = value;
            },
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
          ))
        ],
      ),
    );
  }
}
