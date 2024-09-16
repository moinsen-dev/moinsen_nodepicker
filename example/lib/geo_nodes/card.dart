import 'package:flutter/material.dart';

import 'geo_node.dart';

class GeoNodeCard extends StatelessWidget {
  final GeoNode node;

  const GeoNodeCard({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (node.flag != null)
                  Text(
                    '${node.flag} - ',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                Text(
                  node.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${node.type.toString().split('.').last}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (node.numberOfPeople != null)
              Text(
                'Population: ${node.numberOfPeople!.toString()}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            if (node.listOfLanguages != null &&
                node.listOfLanguages!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Languages:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Wrap(
                    spacing: 8,
                    children: node.listOfLanguages!
                        .map((lang) => Chip(label: Text(lang)))
                        .toList(),
                  ),
                ],
              ),
            if (node.numberOfCities != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Number of cities: ${node.numberOfCities}'),
              ),
            if (node.urlImageFlag != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.network(
                  node.urlImageFlag!,
                  height: 60,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
