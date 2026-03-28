# ⚡ Smart POS System with Supabase

A modern, lightweight Point of Sale (POS) system built with Vanilla JavaScript and Supabase, featuring real-time database synchronization and Barcode/QR scanning capabilities.

---

## 🚀 Quick Setup — 4 Steps

Follow these steps to get your POS system up and running in minutes:

### Step 1 — Schema Deployment (Database Setup)
1. Go to [supabase.com](https://supabase.com) and open your project.
2. Navigate to **SQL Editor** in the left sidebar → Click **New query**.
3. Open your `schema.sql` file and copy the entire content.
4. Paste it into the SQL Editor and click **Run**.
5. Once the "Success" message appears, your tables and sample data are ready.

### Step 2 — Configuration (API Keys)
1. In Supabase, go to **Project Settings** → **API**.
2. Copy your **"anon / public"** key.
3. Open both `index.html` and `pos.html` in your code editor (VS Code/Notepad).
4. **Find & Replace:** Replace `__SUPABASE_ANON_KEY__` with your real key.
5. Save the files.

### Step 3 — Create Users
1. Go to **Authentication** → **Users** → **Add user**.
2. **Admin:** Use an email like `admin@yourshop.com` (Ensure "admin" is in the email string for full access).
3. **Cashier:** Use an email like `cashier@yourshop.com` (Standard access only).

### Step 4 — Launch
1. Open `index.html` in your browser.
2. Login with the credentials you created.
3. Your POS is ready! ✅

---

## ✅ Features Summary

| Feature | Details |
| :--- | :--- |
| 🔴 **DB Status** | Real-time online/offline indicator in the top bar. |
| 📱 **Camera Scan** | jsQR library integration for real-time barcode/QR detection. |
| 🛒 **Cart** | Support for walk-in customers and optional mobile number entry. |
| ⭐ **Loyalty** | Automatic points earning
