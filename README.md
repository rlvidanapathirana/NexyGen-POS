# 🚀 Ultimate Cloud POS System

A high-performance, professional-grade Point of Sale (POS) solution built with **Vanilla JavaScript** and **Supabase**. This system offers a seamless retail experience with real-time cloud sync, hardware integration, and advanced business analytics.

---

## ⚡ Quick Start Guide

1.  **Database Setup**: Execute `schema_v4_full.sql` in your **Supabase SQL Editor** to initialize tables and sample data.
2.  **API Config**: Update the Supabase URL and `anon/public` key in `index.html` and `pos.html`.
3.  **Authentication**: Create users in Supabase Auth. Emails containing "admin" grant full access.
4.  **Deployment**: Open `index.html` via any web server or host it on GitHub Pages/Vercel.

---

## ✨ Full Feature Inventory

### 1. 🛒 Advanced Billing & Checkout
* **Multi-Method Payments**: Support for Cash, Card, QR, and BNPL (Koko, Mint Pay).
* **Split Payments**: Process a single bill using multiple payment methods simultaneously.
* **🎤 Voice-Activated Billing**: Hands-free item entry using Web Speech API.
* **Change Calculator**: Real-time cash change calculation with "Amount Short" warnings.
* **Transaction Refs**: Store reference codes for digital/bank payments.

### 2. 📦 Intelligent Inventory & Stock
* **Real-Time Sync**: Automated stock deduction upon sale completion.
* **Low Stock Alerts**: Visual warnings when items fall below a defined limit.
* **Multi-Price Variants**: Handle products with the same barcode but different prices/sizes.
* **⏳ Expiry Tracking**: Monitor shelf-life with "Expiring Soon" alerts and "Quick Discount" triggers.
* **Sugar/Ration Control**: Specialized limits for restricted items with per-customer monthly caps.

### 3. 👥 CRM & Loyalty Ecosystem
* **Smart Loyalty**: Earn points automatically based on spend; redeemable for instant discounts.
* **Customer Profiling**: Segment users by type (Walk-in, Online, Uber/PickMe).
* **Database Lookup**: Instant customer identification via mobile number.
* **Total Spent History**: Track the lifetime value of every registered customer.

### 4. 📊 Financial Intelligence & Reports
* **Z-Report (Day End)**: Summarize daily revenue and verify physical cash in the drawer.
* **Advanced Analytics**: Revenue breakdowns by payment type and customer category.
* **Top Products**: Track best-selling items by quantity and revenue.
* **PDF Exports**: High-fidelity PDF reports for Sales, Inventory, and Customers.

### 5. 💸 Expenses & Refunds
* **Integrated Expense Manager**: Log business costs (Staff, Utilities, Supplies) alongside sales.
* **Partial/Full Refunds**: Refund specific items or whole bills with automatic stock restoration.
* **Refund Vouchers**: Option to issue refunds as gift vouchers instead of cash.

### 6. 🎁 Vouchers & Digital Receipts
* **Gift Vouchers**: Generate unique codes with balance tracking and expiry dates.
* **WhatsApp Integration**: Share digital receipts instantly via WhatsApp (wa.me).
* **Thermal Layouts**: Optimized for 80mm and 58mm paper sizes.
* **Auto-Printing**: Optional automatic receipt printing after every checkout.

### 7. 🔌 Hardware & Scanning Power
* **Dual-Mode Scanning**: Supports Hardware Scanners (USB/BT) and Camera Scanning (jsQR).
* **Label Generator**: Create and print custom barcode labels for your inventory.
* **Cash Drawer Trigger**: ESC/POS command support to auto-open drawers.
* **Audio Feedback**: Interactive "Beep" sounds for successful scans and button clicks.

### 8. 🛠 System & Security
* **📴 Offline Mode**: Built-in Service Worker and queue to save sales without internet.
* **Dark Mode**: Fully responsive, eyes-friendly UI for night operations.
* **Happy Hour System**: Schedule time-based percentage discounts automatically.
* **Row Level Security (RLS)**: Secure data access via Supabase policies.

---

## 🛠 Tech Stack
| Tier | Technology |
| :--- | :--- |
| **Frontend** | Vanilla JavaScript (ES6+), Modern CSS3, HTML5 |
| **Backend** | Supabase (PostgreSQL, Auth, RLS) |
| **Scanning** | jsQR (QR & Barcode detection) |
| **Reporting** | jsPDF & jsPDF-AutoTable |
| **Offline** | Service Workers & LocalStorage Sync |

---

> **Developed by NextGenIT | Lakshan Vidanapathirana · 2026**
