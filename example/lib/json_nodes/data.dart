import 'package:moinsen_nodepicker/moinsen_nodepicker.dart';

const _jsonNodes = {
  'id': '0',
  'name': 'Root',
  'children': [
    {
      'id': '1',
      'name': 'Node 1',
      'children': [
        {
          'id': '2',
          'name': 'Node 1.1',
          'children': [
            {
              'id': '3',
              'name': 'Node 1.1.1',
            },
            {
              'id': '4',
              'name': 'Node 1.1.2',
            },
          ],
        },
        {
          'id': '5',
          'name': 'Node 1.2',
        },
      ],
    },
    {
      'id': '6',
      'name': 'Node 2',
      'children': [
        {
          'id': '7',
          'name': 'Node 2.1',
        },
        {
          'id': '8',
          'name': 'Node 2.2',
        },
      ],
    },
  ],
};

class JsonNodeData extends MoinsenNode {
  JsonNodeData({
    required super.id,
    required super.name,
    super.parentId,
    required super.hasChildren,
  });

  @override
  String toString() {
    return 'JsonNodeData{id: $id, name: $name, hasChildren: $hasChildren}';
  }

  List<MoinsenNode> get children {
    return _getChildrenFromJson(id);
  }

  @override
  Future<List<MoinsenNode>> fetchChildren() async {
    return children;
  }

  @override
  Future<MoinsenNode> fetchNode(String id) async {
    return _findNodeById(id, _jsonNodes);
  }

  // Helper method to get children from _jsonNodes
  List<MoinsenNode> _getChildrenFromJson(String parentId) {
    var node = _findNodeInJson(parentId, _jsonNodes);
    if (node != null && node['children'] != null) {
      return (node['children'] as List)
          .map((child) => JsonNodeData(
                id: child['id'],
                name: child['name'],
                parentId: parentId,
                hasChildren: child['children'] != null &&
                    (child['children'] as List).isNotEmpty,
              ))
          .toList();
    }
    return [];
  }

  // Helper method to find a node in the _jsonNodes structure
  Map<String, dynamic>? _findNodeInJson(String id, Map<String, dynamic> json) {
    if (json['id'] == id) return json;
    if (json['children'] != null) {
      for (var child in json['children']) {
        var result = _findNodeInJson(id, child);
        if (result != null) return result;
      }
    }
    return null;
  }

  // Helper method to find and create a JsonNodeData from _jsonNodes
  JsonNodeData _findNodeById(String id, Map<String, dynamic> json) {
    var node = _findNodeInJson(id, json);
    if (node != null) {
      return JsonNodeData(
        id: node['id'],
        name: node['name'],
        parentId: _findParentId(id, json),
        hasChildren:
            node['children'] != null && (node['children'] as List).isNotEmpty,
      );
    }
    throw Exception('Node with id $id not found');
  }

  // Helper method to find the parent id of a node
  String? _findParentId(String id, Map<String, dynamic> json,
      [String? currentParentId]) {
    if (json['id'] == id) return currentParentId;
    if (json['children'] != null) {
      for (var child in json['children']) {
        var result = _findParentId(id, child, json['id']);
        if (result != null) return result;
      }
    }
    return null;
  }
}
