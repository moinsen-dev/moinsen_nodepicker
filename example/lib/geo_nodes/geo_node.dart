import 'package:moinsen_nodepicker/moinsen_nodepicker.dart';

import 'geo_api.dart';

/// Concrete class representing geographical nodes like continents, countries, regions, and cities.
class GeoNode extends MoinsenNode {
  // Additional data fields
  final int? numberOfPeople;
  final List<String>? listOfLanguages;
  final int? numberOfCities;
  final int? numberOfCountries; // Added this field
  final String? urlImageFlag;
  final String? flag;
  final GeoNodeType type;

  static final GeoApi _api = GeoApi();

  GeoNode({
    required super.id,
    required super.name,
    super.parentId,
    this.type = GeoNodeType.unknown,
    this.numberOfPeople,
    this.listOfLanguages,
    this.numberOfCities,
    this.numberOfCountries, // Added this parameter
    this.urlImageFlag,
    this.flag,
  });

  /// Fetches a node by its [id].
  @override
  Future<GeoNode> fetchNode(String id) async {
    if (id.startsWith('continent_')) {
      return await _api.fetchContinent(id);
    } else if (id.length == 2) {
      // Assume it's a country code
      return await _api.fetchCountry(id);
    } else {
      // Implement fetchRegion and fetchCity as needed
      throw UnimplementedError('fetchNode for this id is not implemented');
    }
  }

  /// Fetches all children of the current node.
  @override
  Future<List<GeoNode>> fetchChildren() async {
    if (id.startsWith('continent_')) {
      return await _api.fetchCountriesInContinent(name);
    } else if (id == 'world') {
      return await _api.fetchWorldContinents();
    } else if (id.length == 2) {
      return await _api.fetchRegionsInCountry(id);
    } else {
      throw UnimplementedError(
          'fetchChildren for this node is not implemented');
    }
  }

  @override
  List<MoinsenNode> get children => throw UnimplementedError();

  @override
  MoinsenNode get parent => throw UnimplementedError();
}
