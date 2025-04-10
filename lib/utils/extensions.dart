import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

extension DebounceAndCancelExtension on Ref {
  /// Wait for [duration] (defaults to 500ms), and then return a [http.Client]
  /// which can be used to make a request.
  ///
  /// That client will automatically be closed when the provider is disposed.
  Future<http.Client> getDebouncedHttpClient([Duration? duration]) async {
    // First, we handle debouncing.
    var didDispose = false;
    onDispose(() => didDispose = true);

    // We delay the request by 500ms, to wait for the user to stop refreshing.
    await Future<void>.delayed(duration ?? const Duration(milliseconds: 500));

    // If the provider was disposed during the delay, it means that the user
    // refreshed again. We throw an exception to cancel the request.
    // It is safe to use an exception here, as it will be caught by Riverpod.
    if (didDispose) {
      throw Exception('Cancelled');
    }

    // We now create the client and close it when the provider is disposed.
    final client = http.Client();
    onDispose(client.close);

    // Finally, we return the client to allow our provider to make the request.
    return client;
  }
}

extension OpacityParsing on Color {
  // .addOpacity() has been depreciated
  // The propesed replacement .withValues(alpha: ) has a max of 255
  // Hence this extension method retains the scale of 0 to 1
  Color addOpacity(double opacity) {
    if (opacity >= 0.0 && opacity <= 1.0) {
      return withAlpha((255.0 * opacity).round());
    }
    return this;
  }
}
