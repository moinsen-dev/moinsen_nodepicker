import 'dart:convert';

import 'package:http/http.dart' as http;

import 'geo_node.dart';

enum GeoNodeType { world, continent, country, region, subRegion, city, unknown }

class GeoApi {
  final baseUrl = 'https://restcountries.com/v3.1/';

  // List of valid continents as per Rest Countries API
  static final validContinents = [
    'Africa',
    'Americas',
    'Asia',
    'Europe',
    'Oceania',
    'Antarctic'
  ];

  Future<List<GeoNode>> fetchWorld(
    String parentId,
  ) async {
    final futures = validContinents
        .map((continent) => fetchContinentData(parentId, continent));

    return Future.wait(futures);
  }

  Future<GeoNode> fetchContinentData(String parentId, String continent) async {
    final response = await http.get(Uri.parse('${baseUrl}region/$continent'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      // Calculate total population and get a list of languages
      int totalPopulation = 0;
      Set<String> languages = {};
      for (var country in data) {
        totalPopulation += country['population'] as int;
        if (country['languages'] != null) {
          languages.addAll(country['languages'].values.cast<String>());
        }
      }

      return GeoNode(
        id: 'continent_${continent.replaceAll(' ', '_')}',
        name: continent,
        type: GeoNodeType.continent,
        numberOfPeople: totalPopulation,
        listOfLanguages: languages.toList(),
        numberOfCountries: data.length,
        parentId: parentId,
        hasChildren:
            data.isNotEmpty, // Continent has children if there are countries
      );
    } else {
      throw Exception('Failed to load continent data');
    }
  }

  /// Fetches countries in a continent.
  Future<List<GeoNode>> fetchCountriesInContinent(
      String parentId, String continentName) async {
    final response =
        await http.get(Uri.parse('${baseUrl}region/$continentName'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<GeoNode>((countryData) {
        return GeoNode(
          id: countryData['cca2'],
          name: countryData['name']['common'],
          numberOfPeople: countryData['population'],
          listOfLanguages: countryData['languages'] != null
              ? List<String>.from(countryData['languages'].values)
              : null,
          urlImageFlag: countryData['flags']['png'],
          flag: countryData['flag'],
          parentId: parentId,
          type: GeoNodeType.country,
          hasChildren: false,
        );
      }).toList();
    } else {
      throw Exception('Failed to load countries in continent');
    }
  }
}
