class PendingCrashRecord {
  const PendingCrashRecord({required this.error, required this.stackTrace, required this.fatal, this.reason});

  final Object error;
  final StackTrace? stackTrace;
  final bool fatal;
  final String? reason;
}
