import 'package:flutter/material.dart';

class Welcomemessage extends StatelessWidget {
  const Welcomemessage({
    super.key,
    required this.first,
    required this.second,
    required this.third,
  });

  final String first;
  final String second;
  final String third;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          first,
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: second,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Broad',
                  fontSize: 45,
                  fontWeight: FontWeight.w100,
                ),
              ),
              TextSpan(
                text: third,
                style: TextStyle(
                  color: Colors.amber[700],
                  fontFamily: 'Broad',
                  fontSize: 45,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
