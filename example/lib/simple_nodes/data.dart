import 'package:moinsen_nodepicker/moinsen_nodepicker.dart';

import 'utils.dart';

class SimpleNodeData with SimpleUtils implements MoinsenNode {
  @override
  final String id;

  @override
  final String name;

  @override
  final String? parentId;

  final int numberOfChildren;

  List<MoinsenNode> _children = [];
  MoinsenNode? _parent;

  SimpleNodeData({
    required this.id,
    required this.name,
    required this.numberOfChildren,
    this.parentId,
  });

  String get nodeName => 'Node-${parentId == null ? '' : '${parentId!}-'}$id';

  @override
  Future<MoinsenNode> fetchNode(String id) async {
    await Future.delayed(Duration(milliseconds: delay(40, 300)));

    return SimpleNodeData(
      id: id,
      name: nodeName,
      numberOfChildren: generateNumberOfChildren(),
    );
  }

  @override
  Future<List<MoinsenNode>> fetchChildren() async {
    await Future.delayed(Duration(milliseconds: delay(300, 1000)));

    _children = List.generate(numberOfChildren, (index) {
      return SimpleNodeData(
        id: index.toString(),
        name: nodeName,
        numberOfChildren: generateNumberOfChildren(),
        parentId: id,
      );
    });

    return _children;
  }

  @override
  List<MoinsenNode> get children => _children;

  @override
  MoinsenNode? get parent => _parent;

  @override
  String toString() {
    // Display the node name and the number of children and  parentId in a readable format
    return ' $name, Children: $numberOfChildren, Parent: $parentId';
  }
}
