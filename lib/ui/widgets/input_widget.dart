import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'input_button.dart';

class InputWidget extends ConsumerWidget {
  const InputWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen(inputProvider, (previous, next) {
    //   print('next: $next');
    // });

    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              InputButton("AC", color: Colors.blueGrey, small: true),
              InputButton("(", color: Colors.blueGrey, small: true),
              InputButton(")", color: Colors.blueGrey, small: true),
              InputButton(
                InputButton.delete,
                color: Colors.orange,
                small: true,
                icon: Icon(Icons.backspace_outlined),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              InputButton("7"),
              InputButton("8"),
              InputButton("9"),
              InputButton(InputButton.div, color: Colors.orange),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              InputButton("4"),
              InputButton("5"),
              InputButton("6"),
              InputButton(InputButton.multi, color: Colors.orange),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              InputButton("1"),
              InputButton("2"),
              InputButton("3"),
              InputButton(InputButton.minus, color: Colors.orange),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              InputButton("0"),
              InputButton(InputButton.dot),
              InputButton(InputButton.equal, color: Colors.orange),
              InputButton(InputButton.plus, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}
