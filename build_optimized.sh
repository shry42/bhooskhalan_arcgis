#!/bin/bash

echo "🚀 Building optimized APK for Play Store..."

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build optimized APK with size reduction
echo "📦 Building APK with size optimizations..."

# Build for specific architectures to reduce size
flutter build apk --release --split-per-abi --target-platform android-arm64

echo "✅ Build complete!"
echo "📱 APK location: build/app/outputs/flutter-apk/"
echo "📊 Expected size reduction: 40-60% smaller than universal APK" 