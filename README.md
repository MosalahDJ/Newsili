Newsily

Newsily is a modern Flutter news application that delivers the latest news across multiple categories with a clean UI, offline support, and professional state management using Bloc/Cubit.

🚀 Features

🗞️ Latest News from multiple categories

General

Business

Technology

Sports

Science

Health

Entertainment

📡 Online & Offline Support

Automatically caches news locally using SQLite

Shows last saved data when there is no internet connection

🔖 Bookmarks System

Save articles locally

View saved articles anytime (offline-ready)

🔄 Pull to Refresh

Refresh news manually

🧭 Category Tabs

Professional TabBar integrated into AppBar

📤 Share Articles

Share news via system share sheet

🦴 Skeleton Loading UI

Smooth loading experience using skeletonizer

🌙 Dark & Light Theme Support

🛠️ Tech Stack

Flutter

Dart

Bloc / Cubit – State management

HTTP – API requests

SQLite (sqflite) – Local caching & bookmarks

NewsAPI.org – News source

flutter_dotenv – Environment variables

share_plus – Sharing functionality

🧱 Project Architecture

The project follows a clean, scalable structure:

lib/
│── data/
│   ├── database/        # SQLite helpers
│   ├── models/          # Data models
│   ├── repositories/    # Data abstraction
│   └── web_services/    # API services
│
│── logic/
│   └── cubit/
│       ├── fetch_data/  # Fetching news
│       ├── home/        # Home interactions (share, UI logic)
│       └── save_articles/ # Bookmarks logic
│
│── presentation/
│   ├── screens/         # Pages
│   └── widgets/         # Reusable UI widgets
│
│── constants/
│── helper/
│── main.dart

🔐 Environment Setup

This app uses NewsAPI.

1️⃣ Create a .env file

2️⃣ Load it in main.dart

3️⃣ For Release Builds 

📱 Android Configuration

Ensure internet permission is enabled:

android/app/src/main/AndroidManifest.xml

<uses-permission android:name="android.permission.INTERNET"/>

🧠 State Management Strategy

FetchCubit
Handles fetching news (API + offline fallback)

BookmarksCubit
Handles saved articles (SQLite)

HomeCubit
Handles UI actions like sharing

This separation keeps the app:

✅ Maintainable

✅ Testable

✅ Scalable

⚠️ Known Limitations

NewsAPI free plan has request limits

📄 License

This project is for educational and portfolio purposes.
News data provided by NewsAPI.org.

👨‍💻 Author

Newsily
Built with ❤️ using Flutter & Bloc