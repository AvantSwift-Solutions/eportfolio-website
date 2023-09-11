import 'dart:developer';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';

class ReorderDialog extends StatefulWidget {
  final dynamic controller;
  final Function onReorder;
  const ReorderDialog({Key? key, required this.controller, required this.onReorder})
      : super(key: key);

  @override
  State<ReorderDialog> createState() => _ReorderDialogState();
}

class _ReorderDialogState extends State<ReorderDialog> {
  late dynamic _controller;
  late final List<Tuple2<int, String>> _items;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _controller.getSectionTitles();
    setState(() {
      _items = items ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    String sectionName = _controller.getSectionName() ?? '';
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Reorder $sectionName'),
              content: SizedBox(
                width: 300,
                height: 300,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final Tuple2<int, String> item = _items.removeAt(oldIndex);
                          _items.insert(newIndex, item);
                        });
                      },
                      children: <Widget>[
                        for (int index = 0; index < _items.length; index += 1)
                          ListTile(
                            key: Key('$index'),
                            title: Text(_items[index].item2),
                          ),
                      ],
                    );
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await _controller.updateSectionOrder(_items);
                    widget.onReorder();
                    log(_items.toString());
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Reorder'),
    );
  }
}
