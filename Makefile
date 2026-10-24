.PHONY: setup gen format analyze test goldens check run-mock run-dev run-staging run-prod \
	build-android build-ios splash clean

FLAVOR_ARGS_MOCK = --flavor dev --dart-define-from-file=config/mock.json
FLAVOR_ARGS_DEV = --flavor dev --dart-define-from-file=config/dev.json
FLAVOR_ARGS_STAGING = --flavor staging --dart-define-from-file=config/staging.json
FLAVOR_ARGS_PROD = --flavor prod --dart-define-from-file=config/prod.json
RELEASE_ARGS = --release --obfuscate

setup:
	flutter pub get
	$(MAKE) gen

gen:
	flutter gen-l10n
	dart run build_runner build

format:
	dart format lib test

analyze:
	flutter analyze --fatal-infos

test:
	flutter test --exclude-tags golden --coverage

goldens:
	flutter test --tags golden

# Same gate as CI.
check: gen
	dart format --output=none --set-exit-if-changed lib test
	flutter analyze --fatal-infos
	flutter test --exclude-tags golden

run-mock:
	flutter run $(FLAVOR_ARGS_MOCK)

run-dev:
	flutter run $(FLAVOR_ARGS_DEV)

run-staging:
	flutter run $(FLAVOR_ARGS_STAGING)

run-prod:
	flutter run $(FLAVOR_ARGS_PROD)

# Keep build/symbols: Crashlytics needs them to de-obfuscate stack traces.
build-android:
	flutter build appbundle $(RELEASE_ARGS) $(FLAVOR_ARGS_PROD) --split-debug-info=build/symbols/android

# iOS has no native flavors yet (see docs/ios-flavors.md), so no --flavor here.
build-ios:
	flutter build ipa $(RELEASE_ARGS) --dart-define-from-file=config/prod.json \
		--split-debug-info=build/symbols/ios --export-options-plist=ios/ExportOptions.plist

splash:
	dart run flutter_native_splash:create

clean:
	flutter clean
	rm -rf coverage test/goldens/failures
