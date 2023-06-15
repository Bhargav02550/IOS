import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: camel_case_types
class images extends StatelessWidget {
  const images({
    super.key,
    required this.path,
    required this.siz,
  });

  final String path;
  final double siz;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: siz,
      child: SvgPicture.asset(
        path,
      ),
    );
  }
}
