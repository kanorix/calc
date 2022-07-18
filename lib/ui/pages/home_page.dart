import 'package:calc/ui/widgets/input_widget.dart';
import 'package:calc/ui/widgets/log_widget.dart';
import 'package:calc/ui/widgets/result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logProvider = StateProvider((_) => <LogForm>[]);

class HomePage extends ConsumerWidget {
  HomePage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(logProvider);
    final rlogs = logs.reversed.toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                child: ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) {
                    final form = rlogs[index];
                    return Dismissible(
                      key: ObjectKey(form),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        rlogs.removeAt(index);
                        ref
                            .read(logProvider.state)
                            .update((state) => [...rlogs].reversed.toList());
                      },
                      background: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        padding: const EdgeInsets.all(10),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: LogWidget(index, form),
                    );
                  },
                  itemCount: logs.length,
                ),
              ),
            ),
            const ResultWidget(),
            const InputWidget(),
          ],
        ),
      ),
    );
  }
}
