import 'package:flutter/cupertino.dart';
import 'package:moinsen_nodepicker/moinsen_nodepicker.dart';

import 'geo_api.dart';

class GeoNode extends MoinsenNode {
  // Additional data fields
  final int? numberOfPeople;
  final List<String>? listOfLanguages;
  final int? numberOfCities;
  final int? numberOfCountries;
  final String? urlImageFlag;
  final String? flag;
  final GeoNodeType type;

  static final GeoApi _api = GeoApi();

  GeoNode({
    required super.id,
    required super.name,
    super.parentId,
    required super.hasChildren,
    this.type = GeoNodeType.unknown,
    this.numberOfPeople,
    this.listOfLanguages,
    this.numberOfCities,
    this.numberOfCountries,
    this.urlImageFlag,
    this.flag,
  });

  List<MoinsenNode>? _children;

  List<MoinsenNode> get children {
    if (_children == null) {
      throw Exception(
          'Children have not been fetched yet. Call fetchChildren() first.');
    }
    return _children!;
  }

  @override
  Future<List<MoinsenNode>> fetchChildren() async {
    try {
      switch (type) {
        case GeoNodeType.world:
          _children = await _api.fetchWorld(id);
          break;
        case GeoNodeType.continent:
          _children = await _api.fetchCountriesInContinent(id, name);
          break;
        case GeoNodeType.country:
        case GeoNodeType.region:
        case GeoNodeType.subRegion:
        case GeoNodeType.city:
        case GeoNodeType.unknown:
          debugPrint(
              'Fetching children for ${type.toString()} is not implemented yet.');
          _children = [];
      }

      return _children!;
    } catch (e) {
      throw Exception('Failed to fetch children: $e');
    }
  }

  @override
  Future<MoinsenNode> fetchNode(String id) async {
    try {
      // Since there's no direct method to fetch a single node,
      // we'll fetch the parent's children and find the node with the matching id
      if (parentId == null) {
        throw Exception('Cannot fetch node without a parent id');
      }

      final parentNode = GeoNode(
        id: parentId!,
        name:
            '', // We don't know the parent's name, but it's not used in fetching
        hasChildren: true,
        type: type == GeoNodeType.country
            ? GeoNodeType.continent
            : GeoNodeType.world,
      );

      final siblings = await parentNode.fetchChildren();
      final node = siblings.firstWhere((node) => node.id == id);

      if (node is GeoNode) {
        return node;
      } else {
        throw Exception('Fetched node is not of type GeoNode');
      }
    } catch (e) {
      throw Exception('Failed to fetch node: $e');
    }
  }
}
