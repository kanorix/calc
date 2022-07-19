import 'package:calc/ui/pages/home_page.dart';
import 'package:calc/ui/widgets/log_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'result_widget.dart';

class InputButton extends ConsumerWidget {
  static const String plus = "+";
  static const String minus = "-";
  static const String multi = "×";
  static const String div = "÷";
  static const String dot = ".";
  static const String equal = "=";
  static const String allClear = "AC";
  static const String leftParen = "(";
  static const String rightParen = ")";
  static const String delete = "Delete";

  static const List<String> unaryOperators = [plus, minus];
  static const List<String> operators = [plus, minus, multi, div];
  static const List<String> parenthesis = [leftParen, rightParen];

  final String char;
  final bool small;
  final Color color;
  final Widget? icon;

  const InputButton(
    this.char, {
    Key? key,
    this.small = false,
    this.color = Colors.cyan,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 85,
      height: small ? 45 : 55,
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
        ),
        child: icon ??
            Text(
              char,
              style: TextStyle(fontSize: small ? 25 : 32),
            ),
        onPressed: () {
          if (char == InputButton.equal) {
            final result = ref.read(resultProvider);
            final input = ref.read(inputProvider).join(' ');
            final logs = ref.read(logProvider);
            final latestLog = logs.isNotEmpty ? logs.last : null;
            final logForm = LogForm(input: input, result: result);

            if (!['', '?', 'NaN'].contains(result) || latestLog == logForm) {
              ref
                  .read(logProvider.state)
                  .update((state) => [...state, logForm]);
            }
          }
          final state = ref.read(inputProvider.state).update(update);
          ref.watch(inputControlProvider).text = state.join(' ');
        },
      ),
    );
  }

  List<String> update(final List<String> state) {
    final len = state.length;
    final curr = len != 0 ? state.last : "";
    final prevList = len < 2 ? <String>[] : state.sublist(0, state.length - 1);
    final prev = prevList.isNotEmpty ? prevList.last : '';
    // print('==> list updator: curr = $curr, prev = $prev, prevList = $prevList');
    // print('==> list updator: preprev = $preprev, prevList = $prevList');
    switch (char) {
      case InputButton.allClear:
      case InputButton.equal:
        return [];
      case InputButton.delete:
        final lastChars = curr.split('');
        final newStr =
            curr.isNotEmpty ? [...lastChars..removeLast()].join() : '';
        if (lastChars.isNotEmpty) {
          return [...prevList, newStr];
        } else {
          return prevList.isNotEmpty
              ? prevList.sublist(0, prevList.length)
              : [];
        }
      case InputButton.minus:
      case InputButton.plus:
      case InputButton.multi:
      case InputButton.div:
      case InputButton.leftParen:
      case InputButton.rightParen:
        return [...state, char];
      default:
        // 一つ前が演算子なら別のトークンとして
        if ( // len > 2 &&
            !unaryOperators.contains(prev) && operators.contains(curr)) {
          return [...state, char];
        }
        if (parenthesis.contains(curr)) {
          return [...state, char];
        }
        return [...prevList, curr + char];
    }
  }
}
