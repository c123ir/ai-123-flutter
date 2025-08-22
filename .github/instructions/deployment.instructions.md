---
applyTo: "lib_new/**"
---

# Deployment Instructions - رهنمای استقرار

## 🎯 مأموریت

تنظیم و بهینه‌سازی پروژه برای استقرار در محیط‌های مختلف

## 🏗️ Build Configuration Templates

### Environment Configuration

```dart
// lib_new/app/app_config.dart
enum Environment {
  development,
  staging,
  production,
}

class AppConfig {
  static Environment _environment = Environment.development;

  static Environment get environment => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  // API Configuration
  static String get baseUrl {
    switch (_environment) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://staging-api.yourapp.com';
      case Environment.production:
        return 'https://api.yourapp.com';
    }
  }

  // Database Configuration
  static String get databaseUrl {
    switch (_environment) {
      case Environment.development:
        return 'mysql://localhost:3306/ai_123_dev';
      case Environment.staging:
        return 'mysql://staging-db.yourapp.com:3306/ai_123_staging';
      case Environment.production:
        return 'mysql://prod-db.yourapp.com:3306/ai_123_prod';
    }
  }

  // SMS Configuration
  static Map<String, String> get smsConfig {
    switch (_environment) {
      case Environment.development:
        return {
          'provider': 'mock',
          'apiKey': 'dev-key',
        };
      case Environment.staging:
        return {
          'provider': '0098sms',
          'apiKey': const String.fromEnvironment('SMS_API_KEY_STAGING'),
        };
      case Environment.production:
        return {
          'provider': '0098sms',
          'apiKey': const String.fromEnvironment('SMS_API_KEY_PROD'),
        };
    }
  }

  // Debug Configuration
  static bool get debugMode => _environment == Environment.development;
  static bool get enableLogging => _environment != Environment.production;
  static bool get enablePerformanceOverlay => _environment == Environment.development;
}
```

### Flutter Build Scripts

```yaml
# scripts/build.yaml
name: build_scripts

scripts:
  # Development builds
  build-dev-android:
    description: "Build Android APK for development"
    run: flutter build apk --debug --flavor development

  build-dev-ios:
    description: "Build iOS for development"
    run: flutter build ios --debug --flavor development

  # Staging builds
  build-staging-android:
    description: "Build Android APK for staging"
    run: flutter build apk --release --flavor staging

  build-staging-ios:
    description: "Build iOS for staging"
    run: flutter build ios --release --flavor staging

  # Production builds
  build-prod-android:
    description: "Build Android App Bundle for production"
    run: flutter build appbundle --release --flavor production

  build-prod-ios:
    description: "Build iOS for production"
    run: flutter build ios --release --flavor production

  # Web builds
  build-web-dev:
    description: "Build web for development"
    run: flutter build web --debug --dart-define=FLUTTER_WEB_USE_SKIA=true

  build-web-prod:
    description: "Build web for production"
    run: flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true

  # Clean and get dependencies
  clean-all:
    description: "Clean and get dependencies"
    run: |
      flutter clean
      flutter pub get
      cd ios && pod install && cd ..

  # Code generation
  generate-code:
    description: "Generate code files"
    run: |
      flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📱 Platform-Specific Configuration

### Android Configuration

```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.yourcompany.ai123"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName

        // Multi-dex support
        multiDexEnabled true

        // Persian/RTL support
        resConfigs "fa", "en"
    }

    flavorDimensions "environment"
    productFlavors {
        development {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "AI123 Dev"
        }

        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "AI123 Staging"
        }

        production {
            dimension "environment"
            resValue "string", "app_name", "AI123"
        }
    }

    buildTypes {
        debug {
            debuggable true
            minifyEnabled false
            shrinkResources false
        }

        release {
            debuggable false
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'

            // Signing configuration
            signingConfig signingConfigs.release
        }
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

### iOS Configuration

```ruby
# ios/Podfile
platform :ios, '12.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

  # Persian font support
  pod 'FirebaseCore'
  pod 'FirebaseCrashlytics'
  pod 'FirebaseAnalytics'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)

    target.build_configurations.each do |config|
      # Enable bitcode
      config.build_settings['ENABLE_BITCODE'] = 'YES'

      # iOS deployment target
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'

      # Code signing
      config.build_settings['CODE_SIGN_STYLE'] = 'Manual'
    end
  end
end
```

## 🌐 Web Deployment

### Web Configuration

```html
<!-- web/index.html -->
<!DOCTYPE html>
<html dir="rtl" lang="fa">
  <head>
    <!--
    The "Flutter Web Application" starter template provides
    a generic way to setup your Flutter Web application.
  -->
    <base href="$FLUTTER_BASE_HREF" />

    <meta charset="UTF-8" />
    <meta content="IE=Edge" http-equiv="X-UA-Compatible" />
    <meta name="description" content="AI 123 - Smart Assistant Application" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- iOS meta tags & icons -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="apple-mobile-web-app-title" content="AI 123" />
    <link rel="apple-touch-icon" href="icons/Icon-192.png" />

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="favicon.png" />

    <!-- Persian font preload -->
    <link
      rel="preload"
      href="fonts/Vazirmatn-Regular.ttf"
      as="font"
      type="font/ttf"
      crossorigin
    />

    <title>AI 123 - دستیار هوشمند</title>
    <link rel="manifest" href="manifest.json" />

    <style>
      html,
      body {
        margin: 0;
        padding: 0;
        font-family: "Vazirmatn", sans-serif;
        direction: rtl;
      }

      .loading {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        flex-direction: column;
      }

      .spinner {
        border: 4px solid #f3f3f3;
        border-top: 4px solid #2196f3;
        border-radius: 50%;
        width: 40px;
        height: 40px;
        animation: spin 1s linear infinite;
      }

      @keyframes spin {
        0% {
          transform: rotate(0deg);
        }
        100% {
          transform: rotate(360deg);
        }
      }
    </style>
  </head>
  <body>
    <div id="flutter_loading" class="loading">
      <div class="spinner"></div>
      <p>در حال بارگذاری...</p>
    </div>

    <script>
      window.addEventListener("flutter-first-frame", function () {
        const loading = document.getElementById("flutter_loading");
        if (loading) {
          loading.style.display = "none";
        }
      });
    </script>

    <script type="application/javascript" src="flutter.js" defer></script>
  </body>
</html>
```

### PWA Manifest

```json
{
  "name": "AI 123 - دستیار هوشمند",
  "short_name": "AI 123",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#2196F3",
  "theme_color": "#2196F3",
  "description": "دستیار هوشمند برای مدیریت کسب و کار",
  "orientation": "portrait",
  "dir": "rtl",
  "lang": "fa",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-maskable-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable"
    },
    {
      "src": "icons/Icon-maskable-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}
```

## 🐳 Docker Configuration

### Dockerfile for Web

```dockerfile
# Dockerfile.web
FROM nginx:alpine

# Copy web build
COPY build/web /usr/share/nginx/html

# Copy nginx configuration
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Persian font support
RUN apk add --no-cache fontconfig

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### Nginx Configuration

```nginx
# docker/nginx.conf
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private auth;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/x-javascript
        application/xml+rss
        application/javascript
        application/json;

    server {
        listen 80;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;

        # PWA support
        location / {
            try_files $uri $uri/ /index.html;

            # Cache static assets
            location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
                expires 1y;
                add_header Cache-Control "public, immutable";
            }
        }

        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "no-referrer-when-downgrade" always;
        add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    }
}
```

## 🚀 CI/CD Pipeline

### GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.16.0"
          channel: "stable"

      - name: Get dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Analyze code
        run: flutter analyze

  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.16.0"
          channel: "stable"

      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: "zulu"
          java-version: "11"

      - name: Get dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release --flavor production

      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-production-release.apk

  build-web:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.16.0"
          channel: "stable"

      - name: Get dependencies
        run: flutter pub get

      - name: Build web
        run: flutter build web --release

      - name: Deploy to Firebase Hosting
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT }}"
          channelId: live
          projectId: your-firebase-project-id
```

## 📊 Performance Optimization

### Build Optimization

```yaml
# pubspec.yaml optimizations
flutter:
  assets:
    - assets/
    - fonts/

  fonts:
    - family: Vazirmatn
      fonts:
        - asset: fonts/Vazirmatn-Regular.ttf
          weight: 400
        - asset: fonts/Vazirmatn-Bold.ttf
          weight: 700

  # Tree-shaking and optimization
  uses-material-design: true

  # Deferred loading
  deferred-components:
    - name: admin_features
      libraries:
        - package:ai_123/features/admin/admin.dart
```

### Performance Monitoring

```dart
// lib_new/core/monitoring/performance_monitor.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  void trackFrameRate() {
    if (kDebugMode) {
      WidgetsBinding.instance.addTimingsCallback((timings) {
        for (final timing in timings) {
          final buildDuration = timing.buildDuration.inMilliseconds;
          final rasterDuration = timing.rasterDuration.inMilliseconds;

          if (buildDuration > 16 || rasterDuration > 16) {
            debugPrint('Frame drop detected: build=${buildDuration}ms, raster=${rasterDuration}ms');
          }
        }
      });
    }
  }

  void trackMemoryUsage() {
    if (kDebugMode) {
      SystemChannels.system.invokeMethod('SystemChrome.getMemoryUsage').then((usage) {
        debugPrint('Memory usage: $usage');
      });
    }
  }
}
```

## 🔍 Validation Rules

### Deployment باید:

- ✅ Environment-specific configuration داشته باشد
- ✅ Platform-specific optimizations اعمال شده
- ✅ Security best practices رعایت شده
- ✅ Performance optimization اعمال شده
- ✅ CI/CD pipeline تنظیم شده
- ✅ Monitoring و logging فعال باشد
- ✅ Persian/RTL support حفظ شده
- ✅ PWA features فعال باشد (برای Web)

## 🎯 نکات مهم

1. **Environment separation اجباری است**
2. **Security keys را hardcode نکنید**
3. **Performance monitoring فعال کنید**
4. **Build size optimization انجام دهید**
5. **CI/CD pipeline تست شود**
6. **Error reporting تنظیم شود**
7. **Backup strategy داشته باشید**
8. **Rollback plan آماده کنید**
