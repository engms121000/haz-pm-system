# HAz Construction PM System

A comprehensive construction project management system designed for Saudi Arabian contractors. Built as a single-page Progressive Web Application (PWA) with Arabic-English bilingual support and secure user authentication.

![HAz PM System](https://img.shields.io/badge/Version-2.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Auth](https://img.shields.io/badge/Auth-Supabase-orange)

## 🚀 Live Demo

[View Live Demo](https://YOUR_USERNAME.github.io/haz-pm-system/)

## ✨ Features

### 🔐 User Authentication (NEW)
- **Admin & User Accounts** - Role-based access control
- **Secure Registration** - Email/password with admin approval
- **Privacy Protection** - Admins can manage users without accessing their data
- **Status Management** - Pending, Active, Blocked states
- **Supabase Integration** - Enterprise-grade security

### 📋 Daily Reports
- **Work Items Management** - Track multiple work items with item codes and descriptions
- **Manpower Tracking** - Log labor categories, counts, hours, and costs
- **Equipment Tracking** - Record equipment usage with quantities and hourly rates
- **Subcontractor Management** - Track subcontractor costs with expenses/deductions
- **GPS Location** - Capture location via device GPS or interactive map picker
- **Photo Attachments** - Attach site photos to reports

### 👷 Crew Data Entry
- **Shareable Links** - Generate links with expiry time and user limits
- **Offline Support** - Works offline with localStorage
- **Real-time Calculations** - Automatic cost calculations

### 📊 Weekly Reports
- **Progress Items** - Track planned vs completed quantities
- **Import from Daily** - Auto-import data from daily reports
- **Cost Analysis** - Earned Value (EV), Actual Cost (AC), Cost Variance (CV)
- **Histogram Visualization** - Visual cost variance chart
- **Adjustable Quantities** - Manual adjustment for quantities and costs

### 📈 Monthly Reports (EVM)
- **Earned Value Management** - Full EVM calculations
- **Performance Indices** - CPI, SPI, TCPI
- **Forecasting** - EAC, ETC, VAC calculations

### 🛠️ Additional Features
- **🌐 Bilingual** - Arabic/English language toggle
- **📱 Responsive Design** - Works on desktop, tablet, and mobile
- **💰 15% VAT Support** - Saudi VAT calculations
- **🗺️ KML/KMZ Export** - Export locations for Google Earth
- **🌙 Dark Mode** - Comfortable viewing in low light
- **📲 PWA Ready** - Install as mobile app

## 🔐 Authentication Setup (Supabase)

### Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a free account
2. Create a new project
3. Wait for project to be ready (~2 minutes)

### Step 2: Run Database Setup

1. In Supabase, go to **SQL Editor**
2. Copy contents of `supabase-setup.sql` from this repo
3. Paste and click **Run**

### Step 3: Get API Keys

1. Go to **Project Settings** → **API**
2. Copy:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon public** key

### Step 4: Configure HAz PM System

1. Open HAz PM System → **Settings**
2. Scroll to **Supabase Authentication Settings**
3. Paste your URL and anon key
4. Click **Save Settings**

### Step 5: Create First Admin

1. Register a new account in the system
2. In Supabase SQL Editor, run:
   ```sql
   UPDATE profiles SET role = 'admin', status = 'active' WHERE email = 'your@email.com';
   ```
3. Login - you'll now have Admin Panel access

## 👑 Admin Panel Features

| Feature | Description |
|---------|-------------|
| **User Stats** | Total, Active, Pending, Blocked counts |
| **User Table** | View all registered users |
| **Approve** | Activate pending users |
| **Block** | Disable user access |
| **Unblock** | Restore blocked users |
| **Search** | Filter users by name/email/company |

**Privacy Note**: Admins can only see user registration info (name, email, company, status). They CANNOT access user project data, reports, or any business information.

## 📱 Installation

### Option 1: GitHub Pages (Recommended)

1. Fork this repository
2. Go to **Settings** → **Pages**
3. Select **Source**: `Deploy from a branch`
4. Select **Branch**: `main` and folder `/ (root)`
5. Click **Save**
6. Access at: `https://YOUR_USERNAME.github.io/haz-pm-system/`

### Option 2: Local Development

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/haz-pm-system.git

# Open in browser
open index.html
```

### Option 3: Deploy to Other Platforms

The system is a single HTML file with no dependencies, making it easy to deploy anywhere:
- **Netlify**: Drag and drop the folder
- **Vercel**: Import from GitHub
- **Firebase Hosting**: `firebase deploy`

## 🔧 Configuration

### Webhook Integration

To send data to your backend (n8n, Make, etc.):

1. Click the ⚙️ Settings button
2. Enter your webhook URL
3. Toggle "Enable Webhook"
4. Save settings

### Crew Link Generation

1. Fill in Project Code, Name, and Date
2. Select link validity (8h - 72h)
3. Select max users (1 - Unlimited)
4. Click "Generate Crew Link"
5. Share the link with field workers

## 🌐 Language Support

Toggle between English and Arabic using the language button in the top-right corner:

| Feature | English | العربية |
|---------|---------|---------|
| Direction | LTR | RTL |
| All Labels | ✅ | ✅ |
| Admin Panel | ✅ | ✅ |
| Auth Forms | ✅ | ✅ |

## 📊 Data Structure

### User Profile
```json
{
  "id": "uuid",
  "email": "user@company.com",
  "full_name": "Mohamed Ahmed",
  "company": "Al Rajhi Construction",
  "phone": "+966 5X XXX XXXX",
  "role": "user | admin",
  "status": "pending | active | blocked"
}
```

### Daily Report JSON
```json
{
  "projectCode": "PRJ001",
  "projectName": "King Abdullah Road",
  "reportDate": "2024-12-01",
  "location": { "lat": 24.7136, "lng": 46.6753 },
  "workItems": [...]
}
```

## 🌐 Browser Support

- ✅ Chrome 80+
- ✅ Firefox 75+
- ✅ Safari 13+
- ✅ Edge 80+
- ✅ Mobile browsers

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**HAz Project Management Solutions LLC**

- 🌐 Website: [hazpm.com](https://hazpm.com)
- 📧 Email: info@hazpm.com

## 🙏 Acknowledgments

- Supabase for authentication
- Google Maps API for location services
- Chart.js concepts for visualization
- Saudi construction industry standards

---

<div align="center">
  <b>Built with ❤️ for Saudi Construction Industry</b>
</div>
