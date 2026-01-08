#!/bin/bash

echo "🚀 TaskFlow Mobile - Standalone Edition"
echo "========================================"
echo ""
echo "✅ No server needed!"
echo "✅ Works 100% offline!"
echo "✅ All data on your phone!"
echo ""

cd taskflow_mobile

echo "📦 Installing dependencies..."
flutter pub get

echo ""
echo "🎯 Running app..."
echo ""
flutter run

echo ""
echo "✅ App is running!"
echo ""
echo "Quick Test:"
echo "1. Create Project: Projects tab → + → 'Office Work'"
echo "2. Create Task: Today tab → + → 'Submit Report' → Set date"
echo "3. Complete Task: Swipe right → See badge notification!"
echo "4. View Badge: Profile tab → See unlocked badge"
echo ""
echo "🎉 Enjoy your standalone app!"
