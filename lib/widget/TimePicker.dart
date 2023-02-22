import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  var min = 0;
  var sec = 0;
  final void Function(int,int) onDismiss;

  TimePicker({super.key,required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text('Select a Duration')),
      children: [
        Center(
          child: SizedBox(
            height: 200,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              onTimerDurationChanged: (value) {
                min = value.inMinutes;
                sec = value.inSeconds;
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: () {
                  onDismiss(min,sec);
                  Navigator.pop(context);
                },
                child: const Text('Submit')),
          ],
        )
      ],
    );
  }
}
