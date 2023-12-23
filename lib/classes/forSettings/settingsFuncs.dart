import 'package:flutter/material.dart';

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
  const VideoAmountField({Key? key}) : super(key: key);

  @override
  _VideoAmountFieldState createState() => _VideoAmountFieldState();
}

class _VideoAmountFieldState extends State<VideoAmountField> {
  final TextEditingController _controller = TextEditingController();
  String input = '';

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
          width: 100,
          height: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              decoration: const InputDecoration(border: InputBorder.none),
              controller: _controller,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int enteredValue = int.tryParse(value) ?? 0;
                if (enteredValue == 0) {
                  _controller.text = 'unlimited';
                }
                input = _controller.text;
              },
              onEditingComplete: () {
                if (input == 'unlimited') {}
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
  DurationField({super.key});

  @override
  State<DurationField> createState() => _DurationFieldState();
}

class _DurationFieldState extends State<DurationField> {
  final TextEditingController _hController = TextEditingController();
  final TextEditingController _mController = TextEditingController();
  final TextEditingController _sController = TextEditingController();

  String hInput = '';
  String mInput = '';
  String sInput = '';

  @override
  void initState() {


    _hController.text = '00';
    _mController.text = '00';
    _sController.text = '00';
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
          width: 50,
          height: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              decoration: const InputDecoration(border: InputBorder.none),
              controller: _hController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int enteredValue = int.tryParse(value) ?? 0;
                if (enteredValue == 0) {
                  _hController.text = '00';
                }
                hInput = _hController.text;
              },
              onEditingComplete: () {},
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
          width: 50,
          height: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              decoration: const InputDecoration(border: InputBorder.none),
              controller: _mController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int enteredValue = int.tryParse(value) ?? 0;
                if (enteredValue == 0) {
                  _mController.text = '00';
                }
                mInput = _mController.text;
              },
              onEditingComplete: () {},
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
          width: 50,
          height: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              decoration: const InputDecoration(border: InputBorder.none),
              controller: _sController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int enteredValue = int.tryParse(value) ?? 0;
                if (enteredValue == 0) {
                  _sController.text = '00';
                }
                sInput = _sController.text;
              },
              onEditingComplete: () {},
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
