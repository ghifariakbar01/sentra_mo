import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'error_message_widget.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({super.key, required this.value, required this.data});
  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) => Center(child: ErrorMessageWidget(e.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class VAsyncWidgetScaffold<T> extends StatelessWidget {
  const VAsyncWidgetScaffold(
      {super.key,
      required this.value,
      required this.data,
      required this.appBar});
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) => Scaffold(
        appBar: AppBar(),
        body: Center(child: ErrorMessageWidget(e.toString())),
      ),
      loading: () => Scaffold(
        appBar: appBar,
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
