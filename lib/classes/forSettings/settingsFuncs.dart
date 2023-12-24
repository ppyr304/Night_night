import 'package:flutter/material.dart';
import 'package:youtube_player/classes/forSettings/counters.dart';

double boxWidth = 60;

void showLimitTooltip(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        contentPadding: const EdgeInsets.all(16.0),
        children: [
          Text(message),
        ],
      );
    },
  );
}

class VideoAmountField extends StatefulWidget {
  const VideoAmountField({super.key});

  @override
  _VideoAmountFieldState createState() => _VideoAmountFieldState();
}

class _VideoAmountFieldState extends State<VideoAmountField> {
  final TextEditingController _controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  String input = '';

  @override
  void initState() {
    _controller.text = Counters.instance.maxVideos.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Videos: '),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: boxWidth,
          height: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              focusNode: focusNode,
              decoration: const InputDecoration(border: InputBorder.none),
              controller: _controller,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int enteredValue = int.tryParse(value) ?? 0;
                if (enteredValue >99) {
                  input = '99';
                  _controller.text = input;
                } else {
                  input = value;
                }
              },
              onEditingComplete: () {
                focusNode.unfocus();
                if (input == '0') {
                  Counters.instance.maxVideos = 0;
                } else {
                  int value = int.tryParse(input) ?? 0;
                  Counters.instance.maxVideos = value;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DurationField extends StatefulWidget {
  const DurationField({super.key});

  @override
  State<DurationField> createState() => _DurationFieldState();
}

class _DurationFieldState extends State<DurationField> {
  FocusNode fnh = FocusNode();
  FocusNode fnm = FocusNode();
  FocusNode fns = FocusNode();

  final TextEditingController _hController = TextEditingController();
  final TextEditingController _mController = TextEditingController();
  final TextEditingController _sController = TextEditingController();

  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  void setDuration() {
    print(hours);
    print(minutes);
    print(seconds);
  }

  @override
  void initState() {
    Duration duration = Counters.instance.maxDuration;

    hours = duration.inHours;
    minutes = duration.inMinutes % 60;
    seconds = duration.inSeconds % 60;

    _hController.text = hours.toString();
    _mController.text = minutes.toString();
    _sController.text = seconds.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Duration: '),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: boxWidth,
          height: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              focusNode: fnh,
              decoration: const InputDecoration(border: InputBorder.none),
              controller: _hController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int enteredValue = int.tryParse(value) ?? 0;
                if (enteredValue > 23) {
                  _hController.text = '24';
                  _mController.text = '0';
                  _sController.text = '0';
                  hours = 24;
                  minutes = 0;
                  seconds = 0;
                }
              },
              onEditingComplete: () {
                hours = int.tryParse(_hController.text) ?? 0;
                _hController.text = hours.toString();
                fnh.unfocus();
                setDuration();
              },
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('h'),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: boxWidth,
          height: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              focusNode: fnm,
              decoration: const InputDecoration(border: InputBorder.none),
              controller: _mController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int enteredValue = int.tryParse(value) ?? 0;
                if (enteredValue > 59) {
                  _mController.text = '59';
                }
                if (_hController.text == '24') {
                  _hController.text = '23';
                  hours = 23;
                }
              },
              onEditingComplete: () {
                minutes = int.tryParse(_mController.text) ?? 0;
                _mController.text = minutes.toString();
                fnm.unfocus();
                setDuration();
              },
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('m'),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: boxWidth,
          height: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              focusNode: fns,
              decoration: const InputDecoration(border: InputBorder.none),
              controller: _sController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int enteredValue = int.tryParse(value) ?? 0;
                if (enteredValue > 59) {
                  _sController.text = '59';
                }
                if (_hController.text == '24') {
                  _hController.text = '23';
                  hours = 23;
                }
              },
              onEditingComplete: () {
                seconds = int.tryParse(_sController.text) ?? 0;
                _sController.text = seconds.toString();
                fns.unfocus();
                setDuration();
              },
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('s'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _hController.dispose();
    _mController.dispose();
    _sController.dispose();
    super.dispose();
  }
}
