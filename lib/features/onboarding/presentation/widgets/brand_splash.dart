import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class BrandSplash extends StatelessWidget {
  const BrandSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Image.asset(
                'assets/images/brand_image.png',
                width: 320,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Gramulate',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'serif',
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
