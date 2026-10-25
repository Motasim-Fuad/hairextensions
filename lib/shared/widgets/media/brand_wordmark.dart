import 'package:flutter/material.dart';

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.size,
  });

  final double? size;


  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Gramulate, Hair Extension Profit Calculator',
      child: Image.asset(
        'assets/images/brand_image.png',
        width: size??  250,
        fit: BoxFit.contain,
      ),
    );
  }
}