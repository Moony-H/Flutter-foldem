import 'dart:ui';

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/Round.dart';

class RoundSettingPage extends StatefulWidget {
  final List<Round> items;

  const RoundSettingPage({super.key, required this.items});

  @override
  RoundSettingPageState createState() {
    return RoundSettingPageState();
  }
}

class RoundSettingPageState extends State<RoundSettingPage> {
  @override
  Widget build(BuildContext context) {
    const title = 'Dismissing Items';

    return Scaffold(
        // appBar: AppBar(
        //   title: const Text(title),
        //   leading: IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {},
        //   ),
        // ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FreeListView(
              listWidget: List.generate(
                  widget.items.length,
                  (index) => RoundItemWidget(
                      index: index,
                      item: widget.items[index],
                      onDeleteButtonClicked: (i) {
                        setState(() {
                          widget.items.removeAt(i);
                        });
                      })),
              onReorder: (oldItemIndex, newItemIndex) {
                setState(() {
                  if (oldItemIndex < newItemIndex) {
                    newItemIndex -= 1;
                  }
                  final item = widget.items.removeAt(oldItemIndex);
                  widget.items.insert(newItemIndex, item);
                });
              },
              onDismissed: (direction, index) {
                setState(() {
                  widget.items.removeAt(index);
                });
              },
              onAddButtonClicked: () {
                setState(() {
                  widget.items.add(Round(
                      smallBlind:
                          widget.items[widget.items.length - 1].smallBlind,
                      bigBlind: widget.items[widget.items.length - 1].bigBlind,
                      ante: 0,
                      timeSec: 10));
                });
              },
            )));
  }
}



class RoundItemWidget extends StatefulWidget {
  final void Function(int) onDeleteButtonClicked;

  int index;
  final Round item;

  RoundItemWidget(
      {super.key,
      required this.index,
      required this.item,
      required this.onDeleteButtonClicked});

  @override
  State<StatefulWidget> createState() => _RoundItemWidgetState();
}

class _RoundItemWidgetState extends State<RoundItemWidget> {
  final smallController = TextEditingController();
  final bigController = TextEditingController();
  final anteController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    smallController.text = widget.item.smallBlind.toString();
    bigController.text = widget.item.bigBlind.toString();
    anteController.text = widget.item.ante.toString();
    timeController.text = widget.item.timeSec ~/ 60 >= 60
        ? ('${widget.item.timeSec ~/ 3600}H ${((widget.item.timeSec % 3600) ~/ 60).toString().padLeft(2,'0')}M')
        : '${widget.item.timeSec ~/ 60}M';

    return SizedBox(
      height: 88,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${widget.index + 1}'),
          SizedBox(
            width: calcWidth(context),
            child: TextField(
              controller: smallController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: 'Small Blind'),
            ),
          ),
          SizedBox(
            width: calcWidth(context),
            child: TextField(
              controller: bigController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: 'Big Blind'),
            ),
          ),
          SizedBox(
            width: calcWidth(context),
            child: TextField(
              controller: anteController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: 'Ante'),
            ),
          ),
          SizedBox(
            width: calcWidth(context),
            child: TextField(
                readOnly: true,
                controller: timeController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: 'Time'),
                onTap: () async {
                  var result = await showDurationPicker(
                      context: context,
                      initialTime: const Duration(minutes: 30));
                  if (result != null) {
                    print(result.inHours);
                    setState(() {

                      widget.item.timeSec =
                          result.inSeconds;
                    });
                  }
                }),
          ),
          IconButton(
              onPressed: () {
                widget.onDeleteButtonClicked(widget.index);
              },
              icon: const Icon(Icons.delete))
        ],
      ),
    );
  }

  double calcWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 250) {
      return 30.0;
    }
    if (screenWidth > 800) {
      return 160.0;
    }
    return screenWidth / 8;
  }
}

class FreeListView extends StatefulWidget {
  late final List<Widget> _listWidget;

  void Function(int, int) onReorder;
  void Function(DismissDirection, int) onDismissed;
  void Function() onAddButtonClicked;

  FreeListView(
      {super.key,
      required List<Widget> listWidget,
      required this.onReorder,
      required this.onDismissed,
      required this.onAddButtonClicked}) {
    _listWidget = listWidget;
  }

  @override
  State<StatefulWidget> createState() => FreeListViewState();
}

class FreeListViewState extends State<FreeListView> {
  @override
  Widget build(BuildContext context) {
    final newDismissibleWidgetList = List<Widget>.generate(
        widget._listWidget.length,
        (index) => Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              widget.onDismissed(direction, index);
            },
            child: widget._listWidget[index]));

    return Column(children: [
      ReorderableListView(
          shrinkWrap: true,
          onReorder: widget.onReorder,
          children: newDismissibleWidgetList),
      SizedBox(
          height: 88,
          child: Center(
            child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: widget.onAddButtonClicked),
          ))
    ]);
  }
}

//웹 대응
