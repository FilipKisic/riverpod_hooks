import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

Function() useAsyncCallback<T>(
  Future<T> Function() callback, {
  List<Object?> keys = const [],
  Function()? onLoading,
  Function()? onDone,
  Function(T)? onData,
  Function(Object error)? onError,
  Function()? onElse,
  ValueNotifier<AsyncValue<T>?>? stateValue,
  String? debugKey,
}) {
  final onLoadingRef = useRef(onLoading)..value = onLoading;
  final onDoneRef = useRef(onDone)..value = onDone;
  final onDataRef = useRef(onData)..value = onData;
  final onErrorRef = useRef(onError)..value = onError;
  final onElseRef = useRef(onElse)..value = onElse;
  final stateValueRef = useRef(stateValue)..value = stateValue;

  return useCallback(() async {
    /// loading
    if (debugKey != null) log('Action[$debugKey] loading');
    final onLoading = onLoadingRef.value ?? onElseRef.value;
    onLoading?.call();
    stateValueRef.value?.value = const AsyncValue.loading();

    try {
      /// execute
      final result = await callback();

      /// data
      if (result is! Never) {
        onDataRef.value?.call(result);
      }

      stateValueRef.value?.value = AsyncValue.data(result);

      /// done
      if (debugKey != null) log('Action[$debugKey] done');
      final onDone = onDoneRef.value ?? onElseRef.value;
      onDone?.call();
    } catch (error, stack) {
      /// error
      if (debugKey != null) {
        log('Action[$debugKey] error');
        log(error.toString());
      }
      stateValueRef.value?.value = AsyncValue.error(error, stack);
      if (onErrorRef.value != null) {
        onErrorRef.value?.call(error);
      } else if (onElseRef.value != null) {
        onElseRef.value?.call();
      }
    }
  }, keys);
}
