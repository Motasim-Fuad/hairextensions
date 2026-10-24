# Performance

Budgets, the mechanisms already in place, and the checks to run before each release. Measure in profile or release
mode on a real low-end device (for example a Pixel 4a or Galaxy A-series and an iPhone XR or SE); debug and
simulator numbers mean nothing.

## Budgets

| Metric | Budget | Where to read it |
| --- | --- | --- |
| `main()` to first frame | 800 ms p90 on a low-end Android | `app_startup.first_frame_ms` in Firebase Performance |
| Cold start to interactive | 2 s p90 | Play vitals "slow cold start" below 5%; Xcode Organizer launch time |
| Frame build and raster | 8 ms each at 60 Hz (half the 16 ms frame) | DevTools performance view |
| Slow frames | Under 1% of frames over 16 ms; no frame over 700 ms | Play vitals, Firebase screen rendering |
| Screen ready | 300 ms local, 1 s remote, p90 | `screen_<feature>_<screen>` traces |
| Local query | 16 ms for any list query of 1,000 rows | Logger timing in profile builds |
| Android download size | Under 25 MB (arm64 bundle) | `flutter build appbundle --analyze-size --target-platform android-arm64` |
| iOS download size | Under 40 MB | App Store Connect, App Store file sizes |
| Memory | Under 200 MB resident on list and PDF screens | DevTools memory view |
| Crash-free users | 99.5% or higher | Crashlytics |

A regression of more than 10% against the previous release blocks promotion past 5%.

## Already built in

Know these before changing the code paths they protect.

- **Startup:** before `runApp` the bootstrap only configures DI, error handling, the bloc observer and
  `KeyValueStore.warmUp`. Firebase, consent, flags, connectivity and the device session start in
  `DeferredInitializer` after the first frame. Do not add awaits to `bootstrap()`.
- **Lazy DI:** every service is a lazy singleton; nothing is constructed until first use. Avoid `@singleton` and
  `@preResolve`, which run at startup.
- **Optional modules:** `CloudSyncModule` (sync engine and workmanager) only starts while `cloudSync` is on. New
  heavy features should be a `FeatureModule` so a flag can keep them out of memory.
- **Rebuilds:** pages use `BlocSelector`, and `buildWhen` and `listenWhen` on every builder and listener. Themes
  are built once and cached.
- **Tabs:** `StatefulShellRoute.indexedStack` keeps tab state alive, so returning to a tab does not reload it. Each
  tab's page must not poll while hidden.
- **Loading:** one `ShimmerScope` animation drives all skeletons on a page inside a `RepaintBoundary`, instead of
  one controller per placeholder.
- **Images:** `AppNetworkImage` decodes at display size (`memCacheWidth` from the layout width and pixel ratio), and
  `AppImageCacheManager` caps the disk cache by count and age.
- **Network:** large JSON responses parse in a background isolate (`parseInBackground` in `ApiClient`). The API
  cache table and offline-first repositories show local data first and refresh in the background.
- **Database:** every list query has an index (quotes by date and by type and status, lines by quote, sync queue by
  status and next attempt).
- **Remote Config:** fetched after the first frame, throttled to every 12 hours, no realtime listener.
- **Motion:** route transitions respect reduced motion.

## Rules for new code

1. Lists use `ListView.builder` or slivers, never `Column` with `map` over unbounded data. Give fixed-height rows
   `itemExtent` or `prototypeItem`.
2. Prefer `const` constructors; the analyzer enforces them where possible.
3. No `Opacity` or `ClipPath` animations over large subtrees; use `FadeTransition` or `AnimatedOpacity` on a small
   child.
4. Wrap independently animating regions (timers, progress, shimmer) in `RepaintBoundary`.
5. Work over about 8 ms (PDF building, CSV export, large price recalculations) runs in `Isolate.run`. PDF generation
   in particular must not run on the UI isolate.
6. Batch database writes in a transaction; never write rows one by one in a loop.
7. Page data larger than 200 rows: page it at the datasource (`LIMIT` and `OFFSET`, or keyset on `created_at`).
8. Streams and controllers are closed in `close()` or `dispose()`; repository streams are cancelled when the bloc
   closes.
9. Images from the network go through `AppNetworkImage`; bundled images are sized assets (1x, 2x, 3x) or SVG.
10. No work in `build()` beyond layout: formatting, sorting and filtering happen in the bloc or a selector.

## How to measure

```bash
# Startup timeline (writes build/start_up_info.json)
flutter run --profile --flavor dev --dart-define-from-file=config/dev.json --trace-startup

# Frame and memory profiling
flutter run --profile --flavor dev --dart-define-from-file=config/dev.json
# then open DevTools from the printed link: Performance, CPU profiler, Memory

# Size breakdown
flutter build appbundle --release --flavor prod --dart-define-from-file=config/prod.json \
  --analyze-size --target-platform android-arm64
```

Turn on "Track widget rebuilds" in DevTools for a page you changed: a scroll or a single field edit should rebuild
only the affected widgets.

## Release checklist

- [ ] Profiled the changed screens on the low-end Android device: no frames over budget while scrolling and typing.
- [ ] `app_startup` and screen traces of the previous release checked in Firebase Performance; no regression above 10%.
- [ ] No new `await` before `runApp`; no new eager singleton.
- [ ] App size checked against the budget; new packages justified.
- [ ] Image assets compressed and sized.
- [ ] New lists are lazy; new heavy work runs off the UI isolate.
- [ ] Play vitals (slow cold start, slow and frozen frames, ANR) and Xcode Organizer (launch, hangs, memory) for the
      current production build reviewed before promoting the next one.
