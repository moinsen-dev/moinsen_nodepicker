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

  /// Fetches a continent by its [continentId].
  Future<GeoNode> fetchContinent(String continentId) async {
    String continentName =
        continentId.replaceFirst('continent_', '').replaceAll('_', ' ');

    if (!validContinents.contains(continentName)) {
      throw Exception('Invalid continent ID');
    }

    return GeoNode(
      id: continentId,
      name: continentName,
      type: GeoNodeType.continent,
    );
  }

  Future<List<GeoNode>> fetchWorldContinents() async {
    final futures =
        validContinents.map((continent) => fetchContinentData(continent));

    return Future.wait(futures);
  }

  Future<GeoNode> fetchContinentData(String continent) async {
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
      );
    } else {
      throw Exception('Failed to load continent data');
    }
  }

  /// Fetches countries in a continent.
  Future<List<GeoNode>> fetchCountriesInContinent(String continentName) async {
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
          parentId: 'continent_${continentName.replaceAll(' ', '_')}',
          type: GeoNodeType.country,
        );
      }).toList();
    } else {
      throw Exception('Failed to load countries in continent');
    }
  }

  /// Fetches a country by its [countryCode].
  Future<GeoNode> fetchCountry(String countryCode) async {
    final response = await http.get(Uri.parse('${baseUrl}alpha/$countryCode'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      return GeoNode(
        id: data['cca2'],
        name: data['name']['common'],
        numberOfPeople: data['population'],
        listOfLanguages: data['languages'] != null
            ? List<String>.from(data['languages'].values)
            : null,
        urlImageFlag: data['flags']['png'],
        flag: data['flag'],
        type: GeoNodeType.country,
      );
    } else {
      throw Exception('Failed to load country data');
    }
  }

  /// Fetches regions in a country.
  Future<List<GeoNode>> fetchRegionsInCountry(String countryCode) async {
    final response = await http.get(Uri.parse('${baseUrl}alpha/$countryCode'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];

      // Check if the country has subdivisions
      if (data['subdivisions'] != null && data['subdivisions'] is Map) {
        final subdivisions = data['subdivisions'] as Map<String, dynamic>;
        return subdivisions.entries.map<GeoNode>((entry) {
          return GeoNode(
            id: '$countryCode-${entry.key}',
            name: entry.value,
            parentId: countryCode,
            type: GeoNodeType.region,
          );
        }).toList();
      } else {
        // If no subdivisions, return the country itself as a region
        return [
          GeoNode(
            id: countryCode,
            name: data['name']['common'],
            parentId: countryCode,
            type: GeoNodeType.region,
            numberOfPeople: data['population'],
            listOfLanguages: data['languages'] != null
                ? List<String>.from(data['languages'].values)
                : null,
            urlImageFlag: data['flags']['png'],
            flag: data['flag'],
          )
        ];
      }
    } else {
      throw Exception('Failed to load regions in country');
    }
  }

  /// Fetches cities in a region.
  Future<List<GeoNode>> fetchCitiesInRegion(String regionId) async {
    // The REST Countries API doesn't provide information about cities
    // Return an empty list as cities are not available through this API
    return [];
  }

  /// Fetches a region by its [regionId].
  Future<GeoNode> fetchRegion(String regionId) async {
    // The REST Countries API doesn't provide direct information about regions
    // We'll fetch the country data instead and return it as a region
    final countryCode = regionId
        .split('-')[0]; // Assuming regionId format is 'countryCode-regionCode'
    final response = await http.get(Uri.parse('${baseUrl}alpha/$countryCode'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      return GeoNode(
        id: regionId,
        name: data['name']['common'], // Using country name as region name
        parentId: countryCode,
        type: GeoNodeType.region,
        numberOfPeople: data['population'],
        listOfLanguages: data['languages'] != null
            ? List<String>.from(data['languages'].values)
            : null,
        urlImageFlag: data['flags']['png'],
        flag: data['flag'],
      );
    } else {
      throw Exception('Failed to load region data');
    }
  }

  /// Fetches a city by its [cityId].
  Future<GeoNode> fetchCity(String cityId) async {
    // The REST Countries API doesn't provide information about cities
    // Return an empty GeoNode with unknown type
    return GeoNode(
      id: cityId,
      name: 'Unknown City',
      type: GeoNodeType.unknown,
    );
  }
}
