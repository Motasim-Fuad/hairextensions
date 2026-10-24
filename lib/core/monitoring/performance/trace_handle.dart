abstract interface class TraceHandle {
  void putAttribute(String name, String value);

  void setMetric(String name, int value);

  void incrementMetric(String name, [int by = 1]);

  Future<void> stop();
}
