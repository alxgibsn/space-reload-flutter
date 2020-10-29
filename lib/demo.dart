import 'package:flutter/material.dart';

class Demo {

  final String riveFile;
  final Alignment alignment;
  final String navTitle;
  final Color navColor;
  final Color tileColor;
  final Color backgroundColor;

  Demo({
    @required this.riveFile,
    this.alignment = Alignment.center,
    this.navTitle = 'MyApp',
    this.navColor = Colors.grey,
    this.tileColor = Colors.grey,
    this.backgroundColor = Colors.white
  });
}