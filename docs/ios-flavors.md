# iOS flavors

Android already has `dev`, `staging` and `prod` product flavors. iOS needs matching Xcode schemes before
`flutter run --flavor <name>` works on iOS. Until then, run iOS without `--flavor`; the Dart side still reads the
flavor and environment from the config file.

These steps edit the Xcode project, so do them in Xcode rather than by hand.

1. Open `ios/Runner.xcworkspace`.
2. **Build configurations.** Project Runner, Info tab, Configurations. Duplicate each of Debug, Release and Profile
   three times and name them `Debug-dev`, `Debug-staging`, `Debug-prod`, and likewise for Release and Profile.
3. **Schemes.** Product, Scheme, Manage Schemes. Duplicate Runner three times as `dev`, `staging` and `prod`
   (shared). In each scheme point Run, Test, Analyze to `Debug-<flavor>`, Profile to `Profile-<flavor>` and
   Archive to `Release-<flavor>`.
4. **Bundle id and name.** Target Runner, Build Settings. Per configuration set:
   - `PRODUCT_BUNDLE_IDENTIFIER`: base id with `.dev` or `.staging` appended, nothing for prod.
   - Add a user-defined setting `APP_DISPLAY_NAME` (`P2P Dev`, `P2P Staging`, `Price to Profit`) and set
     `CFBundleDisplayName` in `Info.plist` to `$(APP_DISPLAY_NAME)`.
5. **Firebase.** Put each flavor's `GoogleService-Info.plist` in `ios/config/<flavor>/` and add a Run Script build
   phase before Compile Sources that copies the matching file:

   ```bash
   FLAVOR="${CONFIGURATION##*-}"
   cp "${PROJECT_DIR}/config/${FLAVOR}/GoogleService-Info.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
   ```

6. **Podfile.** Map the new configurations at the top of `ios/Podfile`:

   ```ruby
   project 'Runner', {
     'Debug-dev' => :debug, 'Debug-staging' => :debug, 'Debug-prod' => :debug,
     'Profile-dev' => :release, 'Profile-staging' => :release, 'Profile-prod' => :release,
     'Release-dev' => :release, 'Release-staging' => :release, 'Release-prod' => :release,
   }
   ```

   Then run `cd ios && pod install`.
7. **match and export.** Add the `.dev` and `.staging` bundle ids to `ios/fastlane/Matchfile` and
   `ios/ExportOptions.plist` if those builds go to TestFlight, and add `--flavor prod` to the iOS build in
   `ios/fastlane/Fastfile` and the `build-ios` Makefile target.
8. Verify: `flutter run --flavor dev --dart-define-from-file=config/mock.json` on a simulator.
