# 💰 Finance Tracker App

A modern Flutter application for tracking personal finances, including income and expenses management, with clean UI and state management using Bloc.

---

## 📱 Overview

Finance Tracker App helps users manage their daily financial activities by allowing them to:

- Track income and expenses
- Categorize transactions
- View statistics
- Fetch product data from backend API
- Navigate through a clean multi-page interface

---

## ✨ Features

### 💸 Transactions
- Add Income
- Add Expense
- Category selection with icons
- Real-time updates using Bloc

### 📊 Statistics
- Total income calculation
- Total expenses calculation
- Transaction count

### 👤 Profile Page
- User information UI
- Summary of financial data
- Clear all transactions

### 🌐 Backend Integration
- Fetch products from API:
  https://dummyjson.com/
- Product list (Master view)
- Product details (Detail view)

### 🎨 UI/UX
- Modern card-based design
- Gradient headers
- Responsive layout
- Clean navigation bar

---

## 🧠 Architecture

The project uses **Bloc (Business Logic Component)** for state management.
lib/
│
├── bloc/
│ ├── transaction_bloc.dart
│ ├── transaction_event.dart
│ └── transaction_state.dart
│
├── models/
│ ├── transaction_model.dart
│ └── product_model.dart
│
├── services/
│ └── api_service.dart
│
├── screens/
│ ├── home_page.dart
│ ├── add_income_page.dart
│ ├── add_expense_page.dart
│ ├── products_page.dart
│ ├── product_detail_page.dart
│ ├── profile_page.dart
│ └── main_navigation.dart
│
└── main.dart

---

## 🔧 Tech Stack

- **Flutter**
- **Dart**
- **flutter_bloc**
- **HTTP**
- **fl_chart**

---

## 🚀 Getting Started

### 1. Clone repository

```bash
git clone https://github.com/your-username/finance_app.git
cd finance_app
