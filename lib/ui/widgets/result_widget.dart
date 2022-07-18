import 'package:calc/providers/stack.dart';
import 'package:flutter/material.dart' hide Stack;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'always_disabled_focus_node.dart';
import 'input_button.dart';

final inputControlProvider = Provider((_) => TextEditingController());
final inputProvider = StateProvider((_) => <String>[]);

final resultProvider = StateProvider<String>((ref) {
  final inputs = ref.watch(inputProvider);

  if (inputs.isEmpty) {
    return '';
  }

  if (!RegExp(
          r'([+-]?(?:\d+\.?\d*|\.\d+)){1}(([+-×÷]{1}([+-]?(?:\d+\.?\d*|\.\d+)))*|)')
      .hasMatch(inputs.join())) {
    return '?';
  }

  final result = calculate(inputs);
  return NumberFormat('###,###.########').format(result ?? 0).toString();
});

final binaryOperatorMap = {
  InputButton.plus: (num a, num b) => (a + b),
  InputButton.minus: (num a, num b) => (a - b),
  InputButton.multi: (num a, num b) => (a * b),
  InputButton.div: (num a, num b) => (a / b),
};

final operatorOrderMap = {
  InputButton.multi: 1,
  InputButton.div: 1,
  InputButton.plus: 2,
  InputButton.minus: 2,
};

List<String> toRpn(List<String> tokens) {
  final stack = Stack<String>();
  final result = <String>[];

  for (final token in tokens) {
    // print('token: $token');
    switch (token) {
      case InputButton.minus:
      case InputButton.plus:
        stack.push(token);
        break;
      case InputButton.multi:
      case InputButton.div:
      case InputButton.leftParen:
        stack.push(token);
        break;
      case InputButton.rightParen:
        while (stack.top != null && stack.top != InputButton.leftParen) {
          result.add(stack.pop()!);
        }
        stack.pop();
        break;
      default:
        result.add(token);
    }
    // print('>> rpn: $stack, result: $result');
  }
  while (stack.isNotEmpty) {
    result.add(stack.pop()!);
  }
  return result;
}

num? calculate(List<String> list) {
  final stack = Stack<num?>();
  final tokens = toRpn(list);

  // print('calc: $list');
  // print('calc: $tokens');

  if (list.isEmpty) {
    return null;
  }

  for (String token in tokens) {
    // print('calc => stack: $stack');
    final v = double.tryParse(token);

    // not numbers
    if (v == null) {
      final v2 = stack.pop() ?? 0;
      final v1 = stack.pop() ?? 0;
      stack.push(binaryOperatorMap[token]?.call(v1, v2));
    } else {
      stack.push(v);
    }
  }

  return stack.pop();

  // print('calc: $list');
  // final value = list.isNotEmpty ? list.first : "";
  // if (list.isEmpty || value == InputButton.rightParen) {
  //   return null;
  // }
  // final sublist = list.isNotEmpty ? list.sublist(1) : <String>[];
  // final subsublist = sublist.isNotEmpty ? sublist.sublist(1) : <String>[];
  // final v1 = value == InputButton.leftParen
  //     ? calculate(sublist) ?? 0
  //     : double.tryParse(value) ?? 0;

  // final operator = sublist.isNotEmpty ? sublist.first : '';
  // final v2 = calculate(subsublist);
  // if (operator == '' || v2 == null) {
  //   return v1;
  // }

  // print('calc => $v1 $operator $v2');

  // return binaryOperatorMap[operator]?.call(v1, v2);
}

class ResultWidget extends ConsumerWidget {
  const ResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(resultProvider);
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextFormField(
                  focusNode: AlwaysDisabledFocusNode(),
                  controller: ref.watch(inputControlProvider),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 30),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text(
                result,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
