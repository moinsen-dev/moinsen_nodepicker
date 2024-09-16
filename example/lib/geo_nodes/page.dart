import 'package:flutter/material.dart';
import 'package:moinsen_nodepicker/moinsen_nodepicker.dart';

import 'card.dart';
import 'geo_api.dart';
import 'geo_node.dart';

class GeoNodesPage extends StatefulWidget {
  const GeoNodesPage({super.key});

  @override
  State<GeoNodesPage> createState() => _GeoNodesPageState();
}

class _GeoNodesPageState extends State<GeoNodesPage> {
  GeoNode? _selectedNode;

  late GeoNode rootNode;
  List<MoinsenNode> nodePath = [];

  @override
  void initState() {
    rootNode = GeoNode(
      id: 'world',
      name: 'World',
      type: GeoNodeType.world,
      hasChildren: true, // The world node always has children (continents)
    );

    _selectedNode = rootNode;

    super.initState();
  }

  /// Behandlung der Knotenauswahl
  void onSelect(MoinsenNode node) async {
    setState(() {
      _selectedNode = node as GeoNode;
    });
  }

  void onPathUpdate(List<MoinsenNode> path) {
    nodePath = path;
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
      body: SingleChildScrollView(
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
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: GeoNodeCard(
                  node: _selectedNode as GeoNode,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
