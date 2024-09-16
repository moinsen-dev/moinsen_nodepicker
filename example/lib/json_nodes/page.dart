import 'package:flutter/material.dart';
import 'package:moinsen_nodepicker/moinsen_nodepicker.dart';

import 'data.dart';

class FixedNodesPage extends StatefulWidget {
  const FixedNodesPage({super.key});

  @override
  State<FixedNodesPage> createState() => _FixedNodesPageState();
}

class _FixedNodesPageState extends State<FixedNodesPage> {
  MoinsenNode? _selectedNode;

  late final MoinsenNode rootNode;

  @override
  void initState() {
    super.initState();
    rootNode = JsonNodeData(
      id: '0',
      name: 'Root',
      hasChildren: true, // Add this line
    );
    _selectedNode = rootNode;
  }

  /// Handle node selection
  void onSelect(MoinsenNode node) {
    setState(() {
      _selectedNode = node;
    });
  }

  /// Error handling
  void onError() {
    debugPrint('Error occurred while loading children');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Nodes Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                'Selected node: ${_selectedNode?.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
