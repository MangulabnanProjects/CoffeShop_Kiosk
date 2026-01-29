import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CoffeeKioskApp());
}

class CoffeeKioskApp extends StatelessWidget {
  const CoffeeKioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mr. Buenaz Kiosk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF4A7C59),
          secondary: const Color(0xFF8B7355),
          background: const Color(0xFFF5F0EB),
          surface: const Color(0xFFFFFFFF),
        ),
        fontFamily: 'Roboto',
      ),
      home: const TabletPreviewWrapper(
        child: HomeScreen(),
      ),
    );
  }
}

/// Wrapper widget that simulates tablet size when running on web
class TabletPreviewWrapper extends StatelessWidget {
  final Widget child;
  
  const TabletPreviewWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Tablet dimensions - wider rectangle (16:9 widescreen tablet ratio)
        const double tabletWidth = 1366;
        const double tabletHeight = 768;
        
        // If screen is larger than tablet size, show in tablet frame
        if (constraints.maxWidth > tabletWidth + 100) {
          return Container(
            color: const Color(0xFFE8E0D8),
            child: Center(
              child: Container(
                width: tabletWidth,
                height: tabletHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7C59),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: child,
                ),
              ),
            ),
          );
        }
        
        // For smaller screens or actual tablets, show the app normally
        return child;
      },
    );
  }
}
