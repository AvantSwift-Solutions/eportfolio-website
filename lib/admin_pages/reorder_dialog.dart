import 'package:avantswift_portfolio/controllers/analytic_controller.dart';
import 'package:avantswift_portfolio/reposervice/analytic_repo_services.dart';
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
  final stackOptionsThreshold = 1000;

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
                  titlePadding: AdminViewDialogStyles.titleDialogPadding,
                  contentPadding: AdminViewDialogStyles.contentDialogPadding,
                  actionsPadding: AdminViewDialogStyles.actionsDialogPadding,
                  title: Container(
                      padding: AdminViewDialogStyles.titleContPadding,
                      color: AdminViewDialogStyles.bgColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(child: Text('Reorder $sectionName')),
                          const Divider()
                        ],
                      )),
                  content: SizedBox(
                    height: AdminViewDialogStyles.reorderDialogHeight,
                    child: SingleChildScrollView(
                      child: SizedBox(
                          width: AdminViewDialogStyles.reorderDialogWidth,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return ReorderableListView(
                                    proxyDecorator: proxyDecorator,
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
                                          index++)
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
                            ],
                          )),
                    ),
                  ),
                  actions: <Widget>[
                    Container(
                        padding: AdminViewDialogStyles.actionsContPadding,
                        color: AdminViewDialogStyles.bgColor,
                        child: Column(
                          children: [
                            const Divider(),
                            const SizedBox(
                                height: AdminViewDialogStyles.listSpacing),
                            if (MediaQuery.of(context).size.width >=
                                stackOptionsThreshold)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: AdminViewDialogStyles
                                        .elevatedButtonStyle,
                                    onPressed: () async {
                                      await _controller.applyDefaultOrder();
                                      widget.onReorder();
                                    },
                                    child: Text(
                                        'Order ${_controller.defaultOrderName()}',
                                        style: AdminViewDialogStyles
                                            .buttonTextStyle),
                                  ),
                                  Expanded(child: Container()),
                                  ElevatedButton(
                                    style: AdminViewDialogStyles
                                        .elevatedButtonStyle,
                                    onPressed: () async {
                                      await _controller
                                          .updateSectionOrder(_items);
                                      widget.onReorder();
                                    },
                                    child: Text('OK',
                                        style: AdminViewDialogStyles
                                            .buttonTextStyle),
                                  ),
                                  TextButton(
                                    style:
                                        AdminViewDialogStyles.textButtonStyle,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel',
                                        style: AdminViewDialogStyles
                                            .buttonTextStyle),
                                  ),
                                ],
                              ),
                            if (MediaQuery.of(context).size.width <
                                stackOptionsThreshold)
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style:
                                      AdminViewDialogStyles.elevatedButtonStyle,
                                  onPressed: () async {
                                    await _controller.applyDefaultOrder();
                                    widget.onReorder();
                                  },
                                  child: Text(
                                      'Order ${_controller.defaultOrderName()}',
                                      style: AdminViewDialogStyles
                                          .buttonTextStyle),
                                ),
                              ),
                            if (MediaQuery.of(context).size.width <
                                stackOptionsThreshold)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AdminViewDialogStyles.reorderOptionsSpacing,
                                  ElevatedButton(
                                    style: AdminViewDialogStyles
                                        .elevatedButtonStyle,
                                    onPressed: () async {
                                      await AnalyticController.wasEdited(
                                          AnalyticRepoService());
                                      await _controller
                                          .updateSectionOrder(_items);
                                      widget.onReorder();
                                    },
                                    child: Text('OK',
                                        style: AdminViewDialogStyles
                                            .buttonTextStyle),
                                  ),
                                  TextButton(
                                    style:
                                        AdminViewDialogStyles.textButtonStyle,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel',
                                        style: AdminViewDialogStyles
                                            .buttonTextStyle),
                                  ),
                                ],
                              ),
                          ],
                        ))
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
        return Material(
          elevation: 1,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }
}
