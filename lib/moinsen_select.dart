import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'moinsen_node.dart';

enum MoinsenSelectNodeMethod { onTap, onDoubleTap, onLongPress, onSwipe }

class MoinsenSelect extends StatefulWidget {
  final MoinsenNode node;
  final void Function(MoinsenNode node)? onSelect;
  final void Function()? onError;

  // New parameters
  final int? itemCount;
  final double itemExtent;
  final TextStyle? itemTextStyle;
  final Color? borderColor;
  final double borderWidth;
  final Color? backgroundColor;
  final Widget? loadingIndicator;
  final bool enableLongPress;
  final bool enableSwipeNavigation;

  // Added width and height parameters with default values
  final double width;
  final double height;
  final int visibleChildrenCount;

  // New parameter for MoinsenSelectNodeMethod
  final MoinsenSelectNodeMethod selectMethod;

  // New parameter for useArrows option
  final bool useArrows;

  // New parameter for showRootButton option
  final bool showRootButton;

  const MoinsenSelect({
    super.key,
    required this.node,
    this.onSelect,
    this.onError,
    this.itemCount,
    this.itemExtent = 22.0,
    this.itemTextStyle,
    this.borderColor,
    this.borderWidth = 2.0,
    this.backgroundColor,
    this.loadingIndicator,
    this.enableLongPress = true,
    this.enableSwipeNavigation = true,
    this.width = 300,
    this.height = 200,
    this.visibleChildrenCount = 5,
    this.selectMethod = MoinsenSelectNodeMethod.onTap, // Default to onTap
    this.useArrows = true, // Default to true
    this.showRootButton = true, // Default to true
  });

  @override
  MoinsenSelectState createState() => MoinsenSelectState();
}

class MoinsenSelectState extends State<MoinsenSelect> {
  MoinsenNode? selectedNode;
  List<MoinsenNode> childrenNodes = [];
  List<MoinsenNode> nodeStack = [];

  bool isLoading = false;
  bool hasChildren = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    selectedNode = widget.node;

    _loadChildren();
  }

  Future<void> _loadChildren() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      childrenNodes = await selectedNode!.fetchChildren();

      // Check if there are children
      if (childrenNodes.isEmpty) {
        // If there are no children, the current node remains visible
        if (selectedNode != null) {
          _setSelectedNode(selectedNode!);
          setState(() {
            hasChildren = false;
          });
        } else {
          hasChildren = true;
        }
      } else {
        _setSelectedNode(childrenNodes.first);
        setState(
          () {
            hasChildren = true;
          },
        );
      }
    } catch (e) {
      hasError = true;
      if (widget.onError != null) widget.onError!();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleNodeInteraction() async {
    if (selectedNode != null) {
      List<MoinsenNode> children = await selectedNode!.fetchChildren();

      if (children.isNotEmpty) {
        nodeStack.add(selectedNode!); // Store the entire MoinsenNode
        await _loadChildren();
      } else {
        // If there are no children, the current node remains visible
        _setSelectedNode(selectedNode!);
      }
    }
  }

  void _goToParent() {
    if (nodeStack.isNotEmpty) {
      setState(() {
        selectedNode = nodeStack.removeLast();
      });
      _loadChildren();
    }
  }

  void _goToChildren() async {
    await _handleNodeInteraction();
  }

  void _goToRoot() {
    setState(() {
      selectedNode = widget.node;
      nodeStack.clear();
    });
    _loadChildren();
  }

  void _setSelectedNode(MoinsenNode node) {
    setState(() {
      selectedNode = node;
    });

    if (widget.onSelect != null) {
      widget.onSelect!(selectedNode!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.selectMethod == MoinsenSelectNodeMethod.onTap
          ? _handleNodeInteraction
          : null,
      onDoubleTap: widget.selectMethod == MoinsenSelectNodeMethod.onDoubleTap
          ? _handleNodeInteraction
          : null,
      onLongPress: (widget.enableLongPress &&
              widget.selectMethod == MoinsenSelectNodeMethod.onLongPress)
          ? _handleNodeInteraction
          : null,
      onHorizontalDragEnd: (widget.enableSwipeNavigation &&
              widget.selectMethod == MoinsenSelectNodeMethod.onSwipe)
          ? (details) async {
              if (details.primaryVelocity! < 0) {
                // Swipe Left: Go back to the previous node
                if (nodeStack.isNotEmpty) {
                  _goToParent();
                }
              }
            }
          : null,
      child: _buildDecoration(),
    );
  }

  Widget _buildDecoration() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              widget.borderColor ?? (hasChildren ? Colors.green : Colors.red),
          width: widget.borderWidth,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: widget.backgroundColor,
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
          child: widget.loadingIndicator ?? const CircularProgressIndicator());
    }

    return Column(
      children: [
        if (widget.showRootButton)
          ElevatedButton(
            onPressed: _goToRoot,
            child: const Text('Root'),
          ),
        Expanded(
          child:
              widget.useArrows ? _buildArrowContent() : _buildCupertinoPicker(),
        ),
      ],
    );
  }

  Widget _buildArrowContent() {
    return Row(
      children: [
        Opacity(
          opacity: nodeStack.isNotEmpty ? 1.0 : 0,
          child: IconButton(
            iconSize: 50,
            icon: const Icon(Icons.arrow_back),
            onPressed: nodeStack.isNotEmpty ? _goToParent : null,
          ),
        ),
        Expanded(child: _buildCupertinoPicker()),
        Opacity(
          opacity: hasChildren ? 1.0 : 0.5,
          child: IconButton(
            iconSize: 50,
            icon: const Icon(Icons.arrow_forward),
            onPressed: hasChildren ? _goToChildren : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCupertinoPicker() {
    return CupertinoPicker(
      itemExtent: widget.itemExtent,
      onSelectedItemChanged: (int index) async {
        setState(() {
          selectedNode = childrenNodes[index];
        });

        _setSelectedNode(selectedNode!);

        // Check if the selected node has children
        List<MoinsenNode> children = await selectedNode!.fetchChildren();

        setState(() {
          hasChildren = children.isNotEmpty;
        });
      },
      useMagnifier: true,
      magnification: 1.1,
      squeeze: 1.2,
      diameterRatio: 1.1,
      looping: false,
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: widget.backgroundColor?.withOpacity(0.12) ??
            Colors.grey.withOpacity(0.12),
      ),
      children: childrenNodes
          .map((node) => Text(
                node.name,
                style: widget.itemTextStyle ??
                    TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
              ))
          .toList(),
    );
  }
}
