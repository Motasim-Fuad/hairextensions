import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/monitoring/performance/performance_tracer.dart';
import 'package:hairextensions/core/monitoring/performance/trace_handle.dart';
import 'package:hairextensions/core/monitoring/performance/trace_names.dart';

part 'screen_load_tracer_state.dart';

/// Times a feature screen from first build until [isLoaded] turns true. Pass
/// the loaded flag from a BlocSelector so only this flip rebuilds.
class ScreenLoadTracer extends StatefulWidget {
  const ScreenLoadTracer({
    required this.feature,
    required this.screen,
    required this.isLoaded,
    required this.child,
    super.key,
  });

  final FeatureKey feature;
  final String screen;
  final bool isLoaded;
  final Widget child;

  @override
  State<ScreenLoadTracer> createState() => _ScreenLoadTracerState();
}
