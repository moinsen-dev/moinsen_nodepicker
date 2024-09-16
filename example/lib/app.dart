import 'package:example/json_nodes/page.dart';
import 'package:flutter/material.dart';

import 'geo_nodes/page.dart';
import 'simple_nodes/page.dart';

class MoinsenSelectApp extends StatelessWidget {
  const MoinsenSelectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoinsenSelect Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moinsen Nodepicker Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320, // Fixed width for both buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FixedNodesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16), // Add padding
                ),
                child: const Text(
                  ' JSON Nodes Demo',
                  style: TextStyle(fontSize: 24), // Increase font size
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 320, // Fixed width for both buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SimpleNodesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16), // Add padding
                ),
                child: const Text(
                  'Simple Nodes Demo',
                  style: TextStyle(fontSize: 24), // Increase font size
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 320, // Fixed width for both buttons
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GeoNodesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16), // Add padding
                ),
                child: const Text(
                  'Geo Nodes Demo',
                  style: TextStyle(fontSize: 24), // Increase font size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
