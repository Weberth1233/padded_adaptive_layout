import 'package:flutter/material.dart';
import 'package:padded_adaptive_layout/padded_adaptive_layout.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padded Adaptive Layout Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('Responsive Layout Demo')),
        body: PaddedAdaptiveLayoutBuilder(
          children: const [
            Text('Widget 1'),
            Text('Widget 2'),
            Text('Widget 3'),
          ],
          smallScreen: (context, children) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
          mediumScreen: (context, children) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
          largeScreen: (context, children) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          ),
        ),
      ),
    );
  }
}
