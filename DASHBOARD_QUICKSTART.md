# Quick Start Guide - Admin Dashboard CRUD Operations

## 🔐 Login

1. Go to `http://localhost:8080/login.jsp`
2. Enter credentials:
   - **Username**: `dhwani_chauhan`
   - **Password**: `demo@123456`
3. Click **Login** → You'll be redirected to the Dashboard

## 📊 Dashboard Homepage

After login, you'll see:
- **Statistics Cards**: Count of Projects, Skills, New Messages
- **Quick Actions Panel**: Fast access to all CRUD operations
- **Navigation Sidebar**: Menu to different admin sections

## 🚀 PROJECT CRUD OPERATIONS (4 Marks)

### ADD PROJECT
1. From Dashboard, click **"+ Add Project"**
2. Or navigate to: `manageProjects.jsp` → **"+ Add New Project"**
3. Fill in the form:
   - **Title** *(required)*
   - **Description**
   - **Technologies** (comma-separated)
   - **Project URL**
   - **GitHub URL**
   - **Image URL**
   - **Start Date** & **End Date**
   - **Featured** (checkbox - for featured projects)
4. Click **"Add Project"** → Redirects to Projects List

### VIEW/LIST PROJECTS
1. From Dashboard, click **"📝 Edit Projects"** or **"Manage Projects"** in sidebar
2. URL: `http://localhost:8080/jsp/manageProjects.jsp`
3. See table with all your projects:
   - Title
   - Technologies used
   - Status (Featured badge if applicable)
   - Creation date
   - Action buttons (Edit, Delete)

### EDIT PROJECT
1. From Projects List, click **"Edit"** button on any project
2. Pre-filled form will open with current project data
3. Update any fields
4. Click **"Update Project"** → Changes saved, redirects to list

### DELETE PROJECT
1. From Projects List, click **"Delete"** button on any project
2. Confirmation modal appears
3. Click **"Confirm"** to permanently delete
4. Project removed from database, page refreshed

---

## 💡 SKILLS CRUD OPERATIONS (2 Marks)

### ADD SKILL
1. From Dashboard, click **"+ Add Skill"**
2. Or navigate to: `manageSkills.jsp` → **"+ Add New Skill"**
3. Fill in the form:
   - **Skill Name** *(required)* - e.g., "Python", "React"
   - **Category** - e.g., "Programming", "Data Science"
   - **Proficiency Level** - Beginner, Intermediate, Advanced, Expert
4. Click **"Add Skill"** → Redirects to Skills List

### VIEW/LIST SKILLS
1. From Dashboard, click **"✏️ Edit Skills"** or **"Manage Skills"** in sidebar
2. URL: `http://localhost:8080/jsp/manageSkills.jsp`
3. See all your skills organized by category:
   - Grouped by category type
   - Shows skill name and proficiency level
   - Edit and Delete buttons for each skill

### EDIT SKILL
1. From Skills List, click **"Edit"** button on any skill
2. Pre-filled form will open
3. Update category, name, or proficiency level
4. Click **"Update Skill"** → Changes saved, redirects to list

### DELETE SKILL
1. From Skills List, click **"Delete"** button on any skill
2. Confirmation appears
3. Click **"Confirm"** to delete permanently
4. Skill removed, page refreshed

---

## 💌 VIEW MESSAGES

1. From Dashboard, click **"📧 View Messages"** or **"Messages"** in sidebar
2. See all contact form submissions from your portfolio
3. Mark messages as read/unread
4. View message details

---

## 🎨 OTHER FEATURES

### Theme Toggle
- Click **"☀️ Light/Dark Mode"** button in top navigation
- Toggles between light and dark theme
- Preference saved in browser

### Logout
- Click **"Logout"** button in top right
- Sessions cleared
- Redirected to homepage

### View Public Portfolio
- From Dashboard, click **"👁️ View Portfolio"**
- Opens your public portfolio page

---

## 📱 Dashboard Navigation

**Sidebar Menu:**
- 📊 Dashboard - Main dashboard with stats
- 🚀 Manage Projects - View/edit all projects
- 💡 Manage Skills - View/edit all skills  
- 💌 Messages - View contact form submissions

**Top Navigation:**
- DC Admin Logo - Links back to portfolio
- Back to Portfolio - Goes to public homepage
- Theme Toggle - Dark/Light mode
- Welcome Message - Shows your name
- Logout - Ends session

---

## ⚠️ Important Notes

### Security
- Session expires after 30 minutes of inactivity
- Automatic logout if you don't interact for 30 minutes
- All data is user-specific (can only see your own)
- Database secured with SHA-256 password hashing

### Data Validation
- Title/Skill name fields are required
- Date fields should be valid dates
- URLs should be valid format (auto-corrected)
- All input is sanitized to prevent injection attacks

### Error Handling
- If you see an error, check:
  1. All required fields are filled
  2. Session hasn't expired (log in again if needed)
  3. Database connection is working
  4. Try refreshing the page

---

## 🧪 Testing Scenario

**Complete workflow to test all features:**

1. ✅ Login with demo credentials
2. ✅ Add a new project (e.g., "My Portfolio Website")
3. ✅ View the project in list
4. ✅ Edit the project (update some fields)
5. ✅ Add a skill (e.g., "JavaScript")
6. ✅ View the skill in list
7. ✅ Edit the skill
8. ✅ View the public portfolio to see changes reflected
9. ✅ Delete a skill
10. ✅ Delete a project
11. ✅ Logout
12. ✅ Verify redirect to login page

---

## 📞 Troubleshooting

| Issue | Solution |
|-------|----------|
| Can't login | Check credentials: `dhwani_chauhan` / `demo@123456` |
| 404 after login | Clear browser cache, hard refresh (Ctrl+F5) |
| Changes not saved | Check for error messages, ensure all required fields filled |
| Session expired | Login again - sessions timeout after 30 minutes |
| Database error | Check Docker containers are running: `docker compose ps` |
| Page not loading | Restart containers: `docker compose down && docker compose up -d` |

---

## 📊 Marks Breakdown

| Feature | Marks | Status |
|---------|-------|--------|
| Projects CRUD (Add, Edit, Delete, List) | 4 | ✅ Complete |
| Skills CRUD (Add, Edit, Delete, List) | 2 | ✅ Complete |
| Session Authentication | Built-in | ✅ Included |
| Input Validation | Built-in | ✅ Included |
| Database Security | Built-in | ✅ Included |
| **Total** | **6** | **✅ Complete** |

---

**Last Updated**: March 21, 2026
**Version**: 1.0
**Framework**: Java Servlets, JSP, MySQL
