abstract interface class HttpMetricHandle {
  void putAttribute(String name, String value);

  void setResponse({int? statusCode, int? payloadBytes, String? contentType});

  Future<void> stop();
}
