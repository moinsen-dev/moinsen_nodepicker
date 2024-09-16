import 'package:flutter/material.dart';
import 'package:moinsen_nodepicker/moinsen_nodepicker.dart';

import 'data.dart';

class SimpleNodesPage extends StatefulWidget {
  const SimpleNodesPage({super.key});

  @override
  State<SimpleNodesPage> createState() => _SimpleNodesPageState();
}

class _SimpleNodesPageState extends State<SimpleNodesPage> {
  MoinsenNode? _selectedNode;

  MoinsenNode rootNode = SimpleNodeData(
    id: '0',
    name: 'Root',
    numberOfChildren: 5,
  );

  @override
  void initState() {
    _selectedNode = rootNode;

    super.initState();
  }

  /// Behandlung der Knotenauswahl
  void onSelect(MoinsenNode node) async {
    setState(() {
      _selectedNode = node;
    });
  }

  /// Fehlerbehandlung
  void onError() {
    debugPrint('Error occurred while loading children');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Nodes Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Breadcrump:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MoinsenSelect(
                node: rootNode,
                onSelect: onSelect,
                onError: onError,
                width: 400,
                height: 200,
                visibleChildrenCount: 5,
                itemExtent: 40,
                itemTextStyle: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Selected node: $_selectedNode.name',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
