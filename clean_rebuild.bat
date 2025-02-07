@echo off
flutter clean
flutter pub get
flutter pub upgrade
flutter build apk --debug
