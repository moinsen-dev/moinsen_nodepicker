import 'package:moinsen_nodepicker/moinsen_nodepicker.dart';

import 'utils.dart';

class SimpleNodeData extends MoinsenNode with SimpleUtils {
  final int numberOfChildren;

  List<MoinsenNode> _children = [];

  SimpleNodeData({
    required super.id,
    required super.name,
    required this.numberOfChildren,
    super.hasChildren = false,
    super.parentId,
  });

  String get nodeName => 'Node-${parentId == null ? '' : '${parentId!}-'}$id';

  @override
  Future<MoinsenNode> fetchNode(String id) async {
    await Future.delayed(Duration(milliseconds: delay(40, 300)));

    int childCount = generateNumberOfChildren();
    return SimpleNodeData(
      id: id,
      name: nodeName,
      numberOfChildren: childCount,
      hasChildren: childCount > 0,
    );
  }

  @override
  Future<List<MoinsenNode>> fetchChildren() async {
    await Future.delayed(Duration(milliseconds: delay(300, 1000)));

    _children = List.generate(numberOfChildren, (index) {
      int childCount = generateNumberOfChildren();
      return SimpleNodeData(
        id: index.toString(),
        name: nodeName,
        numberOfChildren: childCount,
        hasChildren: childCount > 0,
        parentId: id,
      );
    });

    return _children;
  }

  @override
  String toString() {
    // Display the node name, number of children, hasChildren, and parentId in a readable format
    return '$name, Children: $numberOfChildren, Has Children: $hasChildren, Parent: $parentId';
  }
}
