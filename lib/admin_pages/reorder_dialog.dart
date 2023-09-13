import 'dart:ui';

import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';

class ReorderDialog extends StatefulWidget {
  final dynamic controller;
  final Function onReorder;
  const ReorderDialog(
      {Key? key, required this.controller, required this.onReorder})
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
    return ElevatedButton(
      style: AdminViewDialogStyles.elevatedButtonStyle,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
                data: AdminViewDialogStyles.dialogThemeData,
                child: AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reorder $sectionName'),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  contentPadding: AdminViewDialogStyles.contentPadding,
                  content: SizedBox(
                      width: AdminViewDialogStyles.reorderDialogWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(),
                          StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return ReorderableListView(
                                proxyDecorator: proxyDecorator,
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                shrinkWrap: true,
                                onReorder: (int oldIndex, int newIndex) {
                                  setState(() {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    final Tuple2<int, String> item =
                                        _items.removeAt(oldIndex);
                                    _items.insert(newIndex, item);
                                  });
                                },
                                children: <Widget>[
                                  for (int index = 0;
                                      index < _items.length;
                                      index += 1)
                                    Card(
                                      key: Key('$index'),
                                      child: ListTile(
                                        tileColor: Colors.white,
                                        title: Text(_items[index].item2,
                                            style: AdminViewDialogStyles
                                                .listTextStyle),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const Divider(),
                        ],
                      )),
                  actions: <Widget>[
                    Padding(
                      padding: AdminViewDialogStyles.actionPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: AdminViewDialogStyles.elevatedButtonStyle,
                            onPressed: () async {
                              await _controller.updateSectionOrder(_items);
                              widget.onReorder();
                            },
                            child: Text('OK',
                                style: AdminViewDialogStyles.buttonTextStyle),
                          ),
                          TextButton(
                            style: AdminViewDialogStyles.textButtonStyle,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel',
                                style: AdminViewDialogStyles.buttonTextStyle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          },
        );
      },
      child: Text('Reorder', style: AdminViewDialogStyles.buttonTextStyle),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color: Colors.black.withOpacity(0),
          shadowColor: Colors.black.withOpacity(0),
          child: child,
        );
      },
      child: child,
    );
  }
}
