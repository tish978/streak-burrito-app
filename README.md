# Streak Burrito - iOS Rewards App

Hey! 👋 This is my take on a Chipotle-style rewards app built with SwiftUI. It lets users earn points for their burrito purchases and keeps track of their daily streak - kind of like Snapchat streaks, but for burritos! 🌯

## 🎯 What's Cool About This App?

### Built with SwiftUI (Apple's Modern UI Framework)
- Uses the MVVM pattern to keep code clean and organized
- Updates the UI automatically when data changes (using @State and @ObservedObject)
- Has reusable UI components that I built from scratch!

### Fun UI Features
- Cool circular progress bar that animates smoothly
- Modern glass-like design (like the Apple Weather app)
- Haptic feedback when you tap buttons (that nice little vibration)
- Works great in both light and dark mode
- Smooth animations everywhere!

### Main Features
- **Points System**: Earn points for your burrito purchases and see them update instantly!
- **Cool Rewards**: Unlock and redeem rewards with your points

### Some Technical Stuff I'm Proud Of
- **Custom Theme**: Made my own color system that works across the app
- **Data Storage**: Your points and streaks are saved even when you close the app
- **Clean Code**: Split the code into small, focused pieces (like having separate files for points, notifications, etc.)
- **Easy Testing**: Used SwiftUI previews to build and test UI quickly
- **Works Everywhere**: Looks great on all iPhone sizes!

## 🛠 How I Built It

- **Main Framework**: SwiftUI (Apple's newest UI framework)
- **Code Pattern**: MVVM (helps keep the code organized)
- **Works On**: iOS 15.0 and up
- **Cool Tools I Used**:
  - SwiftUI's built-in state management (@State and @ObservedObject)
  - Local storage to save your data
  - Apple's notification system with custom actions
  - Custom animations to make everything smooth
  - Thread safety (so the app doesn't crash!)

## 💡 How Everything Works

### Points System
- You get points when you buy burritos (I made it update instantly!)
- The app keeps all your points even when you close it
- There's a cool progress ring that fills up as you earn points
- Everything syncs up nicely across the whole app

### Rewards
- Different rewards you can unlock (like free guac or drinks)
- Use your points to get rewards
- Locked rewards are grayed out until you have enough points
- Double-checks with you before using your points

### Cool UI Stuff I Added
- Buttons that spring when you press them (feels nice!)
- Glass-like backgrounds that look modern
- Little vibrations when you tap things
- Everything moves smoothly when it updates

## 🔨 Want to Try It Out?

Super easy to get started:
1. Download the code
2. Open `StreakBurrito.xcodeproj` in Xcode
3. Hit run and try it out!