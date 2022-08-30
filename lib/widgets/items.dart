import 'package:flutter/material.dart';

class DividerQuart extends StatelessWidget {
  const DividerQuart({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 7,
      thickness: 1,
      color: const Color.fromRGBO(158, 158, 158, 0.3),
      indent: width/4,
      endIndent: width/4,
    );
  }
}
