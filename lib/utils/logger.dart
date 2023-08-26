import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

const _logLevel = Level.info;

class _DevFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kReleaseMode || event.level.value < _logLevel.value) {
      return false;
    }
    return true;
  }
}

final logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
  level: _logLevel,
  filter: _DevFilter(),
);
