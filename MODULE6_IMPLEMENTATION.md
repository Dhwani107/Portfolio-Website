# Module 6: Admin Dashboard CRUD Operations Implementation

## Overview
This document describes the complete implementation of Module 6 (Admin Dashboard with CRUD operations) worth 6 marks, distributed as:
- **Projects CRUD (4 marks)**: Add, Edit, Delete, List projects
- **Skills CRUD (2 marks)**: Add, Edit, Delete, List skills

## ✅ Implementation Status: COMPLETE

### Part A: Projects CRUD (4 Marks) - FULLY IMPLEMENTED

#### 1. **Create Project** (Add)
- **Endpoint**: `/projectsCRUD?action=add` (GET) or POST method
- **File**: `WebContent/jsp/addProject.jsp`
- **Functionality**:
  - Form to add new project with fields: title, description, technologies, URLs, dates
  - Input validation (title required)
  - Automatic timestamp and user_id tracking
  - Success redirect to project list
  - Error handling with user feedback
- **Servlet Method**: `ProjectCRUDServlet.addProject()`

#### 2. **Read Project** (List/Display)
- **Endpoint**: `/projectsCRUD?action=list` (GET)
- **File**: `WebContent/jsp/manageProjects.jsp`
- **Functionality**:
  - Displays all projects for logged-in user in table format
  - Shows: Title, Technologies, Status (Featured badge), Created date
  - Quick actions: Edit, Delete buttons for each project
  - Add New Project button
  - Empty state with helpful message
  - Responsive table design with hover effects
- **Servlet Method**: `ProjectCRUDServlet.listProjects()`

#### 3. **Update Project** (Edit)
- **Endpoint**: `/projectsCRUD?action=edit&id=PROJECT_ID` (GET) or POST
- **File**: `WebContent/jsp/editProject.jsp`
- **Functionality**:
  - Pre-populated form with existing project data
  - Update all project fields
  - Preserves original project ID
  - Success redirect to project list
  - Error handling with database validation
- **Servlet Method**: `ProjectCRUDServlet.editProject()` and `updateProject()`

#### 4. **Delete Project**
- **Endpoint**: `/projectsCRUD?action=delete&id=PROJECT_ID` (POST)
- **File**: Confirmation modal in `manageProjects.jsp`
- **Functionality**:
  - Delete confirmation modal
  - Removes project from database
  - Redirect back to project list on success
  - Cascading delete (orphan protection via FK constraint)
- **Servlet Method**: `ProjectCRUDServlet.deleteProject()`

**Database Table**: `projects`
```sql
Columns:
- project_id (PK, Auto-increment)
- user_id (FK to users)
- title (200 chars, Required)
- description (Text)
- technologies (500 chars)
- project_url (255 chars)
- github_url (255 chars)
- image_url (255 chars)
- start_date (Date)
- end_date (Date)
- featured (Boolean, Default: false)
- created_at (Timestamp, Default: CURRENT_TIMESTAMP)
- updated_at (Timestamp, Auto-updated)
```

---

### Part B: Skills CRUD (2 Marks) - FULLY IMPLEMENTED

#### 1. **Create Skill** (Add)
- **Endpoint**: `/skillsCRUD?action=add` (GET) or POST method
- **File**: `WebContent/jsp/addSkill.jsp`
- **Functionality**:
  - Form to add new skill with fields: category, skill name, proficiency level
  - Input validation (skill name required)
  - Default values: Category="Other", Proficiency="Intermediate"
  - Automatic timestamp and user_id tracking
  - Success redirect to skill list
- **Servlet Method**: `SkillCRUDServlet.addSkill()`

#### 2. **Read Skill** (List/Display)
- **Endpoint**: `/skillsCRUD?action=list` (GET)
- **File**: `WebContent/jsp/manageSkills.jsp`  
- **Functionality**:
  - Displays all skills for logged-in user
  - Organized by category
  - Shows: Skill name, Category, Proficiency level
  - Edit and Delete buttons for each skill
  - Add New Skill button
  - Card-based responsive layout
- **Servlet Method**: `SkillCRUDServlet.listSkills()`

#### 3. **Update Skill** (Edit)
- **Endpoint**: `/skillsCRUD?action=edit&id=SKILL_ID` (GET) or POST
- **File**: `WebContent/jsp/editSkill.jsp`
- **Functionality**:
  - Pre-populated form with skill data
  - Update category, name, and proficiency level
  - Success redirect to skill list
  - Error handling with database validation
- **Servlet Method**: `SkillCRUDServlet.editSkill()` and `updateSkill()`

#### 4. **Delete Skill**
- **Endpoint**: `/skillsCRUD?action=delete&id=SKILL_ID` (POST)
- **File**: Inline delete in `manageSkills.jsp`
- **Functionality**:
  - Confirmation before delete
  - Removes skill from database
  - Redirect back to skill list
  - Cascading delete protection via FK constraints
- **Servlet Method**: `SkillCRUDServlet.deleteSkill()`

**Database Table**: `skills`
```sql
Columns:
- skill_id (PK, Auto-increment)
- user_id (FK to users)
- category (100 chars)
- skill_name (100 chars, Required)
- proficiency_level (50 chars)
- created_at (Timestamp, Default: CURRENT_TIMESTAMP)
- updated_at (Timestamp, Auto-updated)
```

---

## 🔐 Authentication & Security Features

### Session Management
- User must be logged in to access dashboard
- Session check on every CRUD operation
- 30-minute session timeout
- Automatic redirect to login if session expired
- HttpOnly cookies for XSS protection

### Input Validation
- Server-side validation for all form inputs
- Required fields checked (title, skill_name)
- SQL injection prevention via PreparedStatement
- HTML escaping for XSS prevention
- User_id validation to prevent unauthorized access

### Database Security
- FOREIGN KEY constraints to maintain referential integrity
- User_id enforcement (users can only modify their own data)
- Cascading deletes for data consistency
- Password hashing using SHA-256

---

## 📋 Project Structure

### Servlet Files
- `src/servlets/ProjectCRUDServlet.java` - Project CRUD handler (Complete)
- `src/servlets/SkillCRUDServlet.java` - Skill CRUD handler (Complete)
- `src/servlets/LoginServlet.java` - Authentication handler
- `src/servlets/LogoutServlet.java` - Session logout

### JSP Files
```
WebContent/jsp/
├── dashboard.jsp          - Main admin dashboard
├── manageProjects.jsp     - List all projects
├── addProject.jsp         - Add new project form
├── editProject.jsp        - Edit project form
├── manageSkills.jsp       - List all skills
├── addSkill.jsp           - Add new skill form
├── editSkill.jsp          - Edit skill form
└── viewMessages.jsp       - View contact messages
```

### Web Server Configuration
- `WebContent/WEB-INF/web.xml` - Servlet mappings configured
- Context path: `/projectsCRUD` for project operations
- Context path: `/skillsCRUD` for skill operations
- Session tracking via COOKIE (HttpOnly enabled)
- Security constraints on `/jsp/*` paths

---

## 🚀 Usage Instructions

### Demo Credentials
```
Username: dhwani_chauhan
Password: demo@123456
```

### Login Flow
1. Navigate to `http://localhost:8080/login.jsp`
2. Enter credentials above
3. Click "Login" → Redirects to `/jsp/dashboard.jsp`

### Dashboard Navigation
From dashboard, access:
- **"Manage Projects"** → `/projectsCRUD?action=list`
- **"Manage Skills"** → `/skillsCRUD?action=list`
- **"View Messages"** → `/jsp/viewMessages.jsp`

### Adding a Project
1. From Projects page, click "+ Add New Project"
2. Fill in form fields
3. Click "Add Project"
4. Redirects back to projects list

### Editing a Project
1. From Projects page, click "Edit" button on any project
2. Update fields
3. Click "Update Project"
4. Redirects back to projects list

### Deleting a Project
1. From Projects page, click "Delete" button
2. Confirm deletion in modal
3. Project removed from database
4. Redirects back to projects list

### Similar workflow for Skills

---

## 🛠️ Database Initialization

### Using Docker (Recommended)
```bash
# Database is auto-initialized from database/portfolio_db.sql
cd "path\to\DhwaniPortfolio"
docker compose up -d --build

# Verify demo user
docker exec dhwani-db mysql -uroot -prootpass portfolio_db -e \
  "SELECT username, first_name FROM users WHERE username='dhwani_chauhan';"
```

### Manual Setup
```bash
# Import SQL if using local MySQL
mysql -u root -p portfolio_db < database/portfolio_db.sql

# Verify connection (see db.properties)
```

---

## 🧪 Testing Checklist

- [ ] Login with demo credentials works
- [ ] Dashboard displays statistics (Projects, Skills, Messages count)
- [ ] Add new project - Success
- [ ] List projects shows all entries
- [ ] Edit project - Updates reflect
- [ ] Delete project - Confirmation modal works
- [ ] Add new skill - Success
- [ ] List skills organized by category  
- [ ] Edit skill - Updates reflect
- [ ] Delete skill - Confirmation works
- [ ] Session timeout after 30 minutes
- [ ] Logout works and clears session

---

## 🐛 Troubleshooting

### 404 Error After Login
**Cause**: Incorrect password hash or database connection issue
**Solution**: Verify demo user password hash:
```bash
docker exec dhwani-db mysql -uroot -prootpass portfolio_db \
  -e "SELECT username, password FROM users WHERE username='dhwani_chauhan';"
```
Expected hash: `2cca11490c8be9107c64b0c213ed5dc37d91ff8e3a0b42bb0780a91cba5cb210`

Update if needed:
```bash
docker exec dhwani-db mysql -uroot -prootpass portfolio_db \
  -e "UPDATE users SET password=SHA2('demo@123456', 256) WHERE username='dhwani_chauhan';"
```

### Database Connection Error
**Solution**: Check environment variables in `docker-compose.yml`:
- `DB_HOST`: should be `db` (container hostname)
- `DB_PORT`: should be `3306`
- `DB_USER`: should be `root`
- `DB_PASSWORD`: should be `rootpass`

### JSP Compilation Error
**Solution**: Clear Tomcat work directory and rebuild:
```bash
docker compose down
docker compose up -d --build
```

---

## 📊 Mark Distribution Summary

| Component | Marks | Status |
|-----------|-------|--------|
| Projects CRUD (Add, Edit, Delete, List) | 4 | ✅ Complete |
| Skills CRUD (Add, Edit, Delete) | 2 | ✅ Complete |
| **Total Module 6** | **6** | **✅ COMPLETE** |

---

## 📝 Notes

- All CRUD operations include proper error handling and user feedback
- Database transactions ensure data consistency
- Foreign key constraints prevent data orphaning
- Session authentication protects all admin operations
- Responsive design works on desktop, tablet, mobile
- Follows Java servlet best practices and security standards

---

**Implementation Date**: March 21, 2026
**Language**: Java, JSP, MySQL, HTML5/CSS3/JavaScript
**Framework**: Apache Tomcat 9.0, Servlets API 3.1
