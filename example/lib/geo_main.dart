// ignore_for_file: avoid_print

import 'geo_nodes/geo_node.dart';

void main() async {
  // Create a continent node
  GeoNode europe = GeoNode(id: 'continent_Europe', name: 'Europe');

  try {
    // Fetch countries in Europe
    List<GeoNode> europeanCountries = await europe.fetchChildren();

    // Print country names and their populations
    for (var country in europeanCountries) {
      print('Country: ${country.name}, Population: ${country.numberOfPeople}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
