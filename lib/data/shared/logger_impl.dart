import 'package:logger/logger.dart' as logger_lib;
import 'package:nurse_diary/domain/shared/logger.dart';

class LoggerImpl extends Logger {

  final logger_lib.Logger logger = logger_lib.Logger(
    printer: logger_lib.PrettyPrinter(
      methodCount: 0,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  final logger_lib.Logger loggerWithST = logger_lib.Logger(
    printer: logger_lib.PrettyPrinter(
      colors: true,
      printEmojis: true,
      printTime: true,
      errorMethodCount: 8,
    ),
  );

  @override
  void d(message) {
    logger.d(message);
  }

  @override
  void i(message) {
    logger.i(message);
  }

  @override
  void v(message) {
    logger.v(message);
  }

  @override
  void w(message) {
    loggerWithST.w(message);
  }

  @override
  void e(message) {
    loggerWithST.e(message);
  }

  @override
  void wtf(message) {
    loggerWithST.wtf(message);
  }

  @override
  void exception(Exception e) {
    loggerWithST.e(e);
  }
}
