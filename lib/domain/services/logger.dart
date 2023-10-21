
abstract class Logger {
  @override
  void d(message);

  @override
  void i(message);

  @override
  void v(message);

  @override
  void w(message);

  @override
  void e(message);

  @override
  void wtf(message);

  @override
  void exception(Exception e);
}
