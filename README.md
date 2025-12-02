# HAz Construction PM System

A comprehensive construction project management system designed for Saudi Arabian contractors. Built as a single-page Progressive Web Application (PWA) with Arabic-English bilingual support.

![HAz PM System](https://img.shields.io/badge/Version-1.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 🚀 Live Demo

[View Live Demo](https://YOUR_USERNAME.github.io/haz-pm-system/)

## ✨ Features

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
- **Responsive Design** - Works on desktop, tablet, and mobile
- **15% VAT Support** - Saudi VAT calculations
- **KML/KMZ Export** - Export locations for Google Earth
- **Dark Mode** - Comfortable viewing in low light
- **PWA Ready** - Install as mobile app

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

## 📊 Data Structure

### Daily Report JSON
```json
{
  "projectCode": "PRJ001",
  "projectName": "King Abdullah Road",
  "reportDate": "2024-12-01",
  "location": { "lat": 24.7136, "lng": 46.6753 },
  "workItems": [
    {
      "itemNo": "ITEM-001",
      "itemDescription": "Excavation works",
      "manpower": [...],
      "equipment": [...],
      "subcontractor": [...]
    }
  ]
}
```

### Weekly Report JSON
```json
{
  "weekStartDate": "2024-12-01",
  "weekEndDate": "2024-12-07",
  "progressItems": [
    {
      "itemCode": "ITEM-001",
      "plannedQty": 1000,
      "completedQty": 850,
      "earnedValue": 212500,
      "actualCost": 200000,
      "costVariance": 12500
    }
  ]
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

- Google Maps API for location services
- Chart.js concepts for visualization
- Saudi construction industry standards

---

<div align="center">
  <b>Built with ❤️ for Saudi Construction Industry</b>
</div>
