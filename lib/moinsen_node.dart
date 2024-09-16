abstract class MoinsenNode {
  final String id;
  final String? parentId;
  final String name;

  MoinsenNode({
    required this.id,
    required this.name,
    this.parentId,
  });

  MoinsenNode? get parent;
  List<MoinsenNode> get children;

  /// Asynchronously fetches a node by its [id].
  Future<MoinsenNode> fetchNode(String id);

  /// Asynchronously fetches all children of the current node.
  Future<List<MoinsenNode>> fetchChildren();
}
