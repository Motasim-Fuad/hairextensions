abstract final class TraceNames {
  static const String appStartup = 'app_startup';
  static const String firstFrameMetric = 'first_frame_ms';
  static const String featureAttribute = 'feature';
  static const String outcomeAttribute = 'outcome';
  static const String outcomeLoaded = 'loaded';
  static const String outcomeLeft = 'left';
  static const String _screenPrefix = 'screen';

  static String screen(String feature, String screen) => '${_screenPrefix}_${feature}_$screen';
}
