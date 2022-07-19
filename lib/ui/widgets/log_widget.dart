import 'package:flutter/material.dart';

class LogForm {
  final String input;
  final String result;
  LogForm({
    required this.input,
    required this.result,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogForm &&
          runtimeType == other.runtimeType &&
          input == other.input &&
          result == result;

  @override
  int get hashCode => Object.hash(input, result);
}

class LogWidget extends StatelessWidget {
  final int index;
  final LogForm logForm;

  const LogWidget(this.index, this.logForm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ElevatedButton(
          onPressed: () {},
          child: Text(
            '#${(index + 1)}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          logForm.result,
          textAlign: TextAlign.end,
          style: const TextStyle(fontSize: 25),
        ),
        subtitle: Text(
          logForm.input,
          textAlign: TextAlign.end,
        ),
      ),
    );
  }
}
