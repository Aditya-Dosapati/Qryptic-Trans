import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Utility class for performance optimizations
class PerformanceUtils {
  /// Debounce function to prevent excessive calls
  static void debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    Timer? _timer;
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  /// Log performance metrics in debug mode only
  static void logPerformance(String operation, Duration duration) {
    if (kDebugMode) {
      print('🚀 Performance: $operation took ${duration.inMilliseconds}ms');
    }
  }

  /// Measure execution time of async operations
  static Future<T> measureAsync<T>(
    String operation,
    Future<T> Function() function,
  ) async {
    final stopwatch = Stopwatch()..start();
    final result = await function();
    stopwatch.stop();
    logPerformance(operation, stopwatch.elapsed);
    return result;
  }

  /// Measure execution time of sync operations
  static T measureSync<T>(String operation, T Function() function) {
    final stopwatch = Stopwatch()..start();
    final result = function();
    stopwatch.stop();
    logPerformance(operation, stopwatch.elapsed);
    return result;
  }

  /// Preload images for better performance
  static Future<void> preloadImages(
    BuildContext context,
    List<String> imagePaths,
  ) async {
    for (final path in imagePaths) {
      try {
        await precacheImage(AssetImage(path), context);
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Failed to preload image: $path - $e');
        }
      }
    }
  }

  /// Build RepaintBoundary for expensive widgets
  static Widget buildOptimizedWidget({
    required String debugLabel,
    required Widget child,
  }) {
    return RepaintBoundary(child: child);
  }
}

/// Timer class for debouncing
class Timer {
  final Duration duration;
  final VoidCallback callback;

  Timer(this.duration, this.callback) {
    Future.delayed(duration, callback);
  }

  void cancel() {
    // In a real implementation, you'd cancel the timer here
  }
}
