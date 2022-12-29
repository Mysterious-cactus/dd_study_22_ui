import 'package:flutter/material.dart';

extension Snackbar on BuildContext {
  /// Removes the current active [SnackBar], and replaces it with a new snackbar
  /// with content of [message].
  void removeAndShowSnackbar(final String message) {
    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
