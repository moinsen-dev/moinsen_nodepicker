abstract class MoinsenNode {
  final String id;
  final String? parentId;
  final String name;
  final bool hasChildren;

  MoinsenNode({
    required this.id,
    required this.name,
    this.parentId,
    required this.hasChildren,
  });

  /// Asynchronously fetches a node by its [id].
  Future<MoinsenNode> fetchNode(String id);

  /// Asynchronously fetches all children of the current node.
  Future<List<MoinsenNode>> fetchChildren();
}
