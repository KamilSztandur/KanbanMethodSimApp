import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      height: MediaQuery.of(context).size.height * 0.5,
      image: AssetImage('assets/logo.png'),
    );
  }
}
