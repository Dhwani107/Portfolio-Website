# Dhwani Chauhan - Dynamic Personal Portfolio Website

##  Project Overview

A fully functional, classy dynamic personal portfolio website built with HTML, CSS, JavaScript, JSP/Servlets, and MySQL database. Features a modern black/white/grey theme with smooth animations and continuous motion effects throughout the website.

| Field | Details |
|---|---|
| Author | Dhwani Chauhan |
| RollNo | 231001001440 |
| University | Techno India University |
| Degree | B.Tech Computer Science and Engineering |
| Date | April 2026 |
| Email | dhwanichauhan1072004@gmail.com |
| LinkedIn | https://www.linkedin.com/in/dhwani-chauhan-aaa5ab280/ |
| GitHub | https://github.com/Dhwani107 |

---

##  Features Implemented

### Module 1: Frontend Layout Development 
- **Responsive Design:** Mobile-friendly layout using CSS Grid and Flexbox
- **Semantic HTML:** Proper structure with semantic tags
- **Navigation:** Smooth navigation with fixed header
- **Sections:**
  - Home (Hero section with CTA buttons)
  - About (Profile and summary)
  - Skills (Categorized by type)
  - Projects (Featured projects with filtering)
  - Education (Academic background)
  - Contact (Contact form and info)

### Module 2: JavaScript Interactivity 
- **Client-side Validation:**
  - Contact form validation (Name, Email, Message)
  - Real-time field validation with error messages
  - Email format validation
  - Password strength validation on registration
  - Form submission via AJAX

- **Interactive Features:**
  - **Dark/Light Theme Toggle:** Switch between dark and light modes
  - **Project Search & Filter:** Live search and technology-based filtering
  - **Project Sorting:** Sort by latest, oldest, or alphabetical order
  - **Smooth Animations:** Fade-in, slide animations on page load
  - **Scroll-triggered Animations:** Elements animate as they come into view
  - **Hover Effects:** Interactive card animations with elevation
  - **Session Timeout Warning:** 30-minute session with warning at 25 minutes

### Module 3: Database Design 
**Database Name:** `portfolio_db`

**Tables:**
1. **users** - User authentication and profile
2. **about** - Portfolio headline and summary
3. **skills** - Skills with categories and proficiency levels
4. **projects** - Project details with technologies
5. **education** - Educational background
6. **messages** - Contact form submissions

**Schema Features:**
- Primary Keys and Foreign Keys properly defined
- Indexes for performance optimization
- Timestamps for tracking creation and updates
- Sample data inserted for all tables

### Module 4: JDBC Connectivity 
- **DatabaseConnection Class:**
  - JDBC driver registration and management
  - Connection pooling support
  - Prepared statement usage for security
  - Resource cleanup (Connection, Statement, ResultSet)
  - Configuration via properties file
  - Error handling and logging

### Module 5: Authentication Module 
- **Register Page & Servlet:**
  - User registration with validation
  - Duplicate username/email checking
  - Password strength requirements (min 8 characters)
  - SHA-256 password hashing

- **Login Page & Servlet:**
  - Username and password authentication
  - Session management
  - Redirect to dashboard on successful login
  - Session timeout configuration (30 minutes)

- **Logout Functionality:**
  - Session invalidation
  - Redirect to home page

### Module 6: Admin Dashboard 
Accessible only after login with complete CRUD operations:

- **Projects CRUD:**
  - Add new projects with technologies, URLs, dates
  - Edit existing projects
  - Delete projects with confirmation modal
  - List all projects with filtering

- **Skills CRUD :**
  - Add skills with categories and proficiency levels
  - Edit skill details
  - Delete skills
  - List skills organized by category

- **Dashboard Features:**
  - Statistics cards (Projects, Skills, Messages count)
  - Quick action buttons
  - Sidebar navigation menu
  - Responsive layout

### Module 7: Dynamic Portfolio Rendering 
- Projects displayed dynamically from database
- Skills organized by category and displayed in real-time
- Education details fetched and rendered
- About section populated from database

### Module 8: Basic Web Security 
- **Session Authentication :**
  - Protected dashboard pages
  - Session validation on each request
  - Redirect to login if session expired
  - HttpOnly cookies

- **Password Hashing :**
  - SHA-256 algorithm for password storage
  - No plain text passwords in database

- **Input Validation & Output Escaping :**
  - Server-side validation for all forms
  - HTML escaping to prevent XSS attacks
  - SQL PreparedStatement to prevent SQL injection
   - Email format validation

---

##  Design Highlights

### Color Scheme
- **Primary Dark:** #0a0a0a (Main background)
- **Primary Light:** #f5f5f5 (Light mode background)
- **Secondary Grey:** #2d2d2d (Cards and sections)
- **Accent:** #ffffff (Text and highlights)
- **Border:** #333333 (Subtle borders)

### Animations & Effects
- **Fade-in animations** on page load
- **Slide transitions** for navigation and modals
- **Float animations** on project cards
- **Glow effects** on hover for interactive elements
- **Shimmer effects** for loading states
- **Pulse animations** for continuous motion
- **Smooth scroll** behavior
- **Parallax effects** on hero section

### Continuous Motion
- Background gradient animation
- Floating card animations on hover
- Pulsing status indicators
- Rotating loading spinners
- Animated transitions between pages

---

##  Technology Stack

| Component | Technology |
|-----------|-----------|
| Frontend | HTML5, CSS3, JavaScript (ES6+) |
| Backend | Java, JSP, Servlets |
| Database | MySQL 5.7+ |
| Connection | JDBC (Java Database Connectivity) |
| Authentication | Session Management |
| Security | SHA-256 Hashing, Input Validation |
| Server | Apache Tomcat 9.0+ |
| IDE Recommended | Eclipse, IntelliJ IDEA, VS Code |

---

##  Project Structure

```
DhwaniPortfolio/
├── WebContent/
│   ├── index.jsp                 # Home page
│   ├── register.jsp              # Registration page
│   ├── login.jsp                 # Login page
│   ├── css/
│   │   └── style.css             # Main stylesheet with animations
│   ├── js/
│   │   └── main.js               # JavaScript for interactivity
│   ├── jsp/
│   │   ├── dashboard.jsp         # Admin dashboard
│   │   ├── manageProjects.jsp    # Projects management
│   │   ├── addProject.jsp        # Add new project
│   │   ├── editProject.jsp       # Edit project
│   │   ├── manageSkills.jsp      # Skills management
│   │   ├── addSkill.jsp          # Add new skill
│   │   ├── editSkill.jsp         # Edit skill
│   │   └── viewMessages.jsp      # View contact messages
│   ├── WEB-INF/
│   │   └── web.xml               # Deployment descriptor
│   └── images/
│       └── (placeholder for profile images)
├── src/
│   ├── db/
│   │   ├── DatabaseConnection.java
│   │   └── db.properties         # Database configuration
│   ├── models/
│   │   ├── User.java
│   │   ├── Project.java
│   │   ├── Models.java           # Skill, Education, About, Message
│   └── servlets/
│       ├── RegisterServlet.java
│       ├── LoginServlet.java
│       ├── LogoutServlet.java
│       ├── ProjectCRUDServlet.java
│       ├── SkillCRUDServlet.java
│       └── ContactServlet.java
├── database/
│   └── portfolio_db.sql          # Database schema and sample data
└── README.md
```

---

##  Setup & Installation Guide

### Prerequisites
1. **Java Development Kit (JDK) 8 or higher**
   ```bash
   java -version
   ```

2. **MySQL Server 5.7 or higher**
   ```bash
   mysql --version
   ```

3. **Apache Tomcat 9.0 or higher**

4. **Apache Commons Codec** (for password hashing)

5. **Docker Desktop** (for running with Docker and Docker Compose)

### Step 1: Database Setup

1. Create the database by importing the SQL file:
   ```bash
   mysql -u root -p < database/portfolio_db.sql
   ```

2. Verify the database:
   ```bash
   mysql -u root -p
   USE portfolio_db;
   SHOW TABLES;
   ```

### Step 2: Project Configuration

1. Update database connection details in `src/db/db.properties`:
   ```properties
   db.url=jdbc:mysql://localhost:3306/portfolio_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
   db.user=root
   db.password=YOUR_MYSQL_PASSWORD
   ```

2. Ensure MySQL server is running

### Step 2: Run via Docker (Recommended)

If you want to run the complete project with MySQL and Tomcat in containers, use Docker Compose from the `DhwaniPortfolio` folder:

1. Build and start the containers:
   ```bash
   docker compose up --build
   ```

2. Wait until both the database and application containers finish starting.

3. Open the application in your browser:
   - **Home Page:** http://localhost:8080/
   - **Registration:** http://localhost:8080/register.jsp
   - **Login:** http://localhost:8080/login.jsp
   - **Dashboard:** http://localhost:8080/jsp/dashboard.jsp

4. To stop the containers, run:
   ```bash
   docker compose down
   ```

### Step 3: Build the Project

1. Compile Java files:
   ```bash
   javac -d WebContent/WEB-INF/classes -cp src src/db/*.java
   javac -d WebContent/WEB-INF/classes -cp src src/models/*.java
   javac -d WebContent/WEB-INF/classes -cp src src/servlets/*.java
   ```

2. Add Commons Codec JAR to `WebContent/WEB-INF/lib/`

### Step 4: Deploy to Tomcat

1. Copy project folder to Tomcat webapps directory:
   ```bash
   cp -r DhwaniPortfolio/ $CATALINA_HOME/webapps/
   ```

2. Start Tomcat server:
   ```bash
   $CATALINA_HOME/bin/startup.sh
   ```

### Step 5: Access the Application

- **Home Page:** http://localhost:8080/DhwaniPortfolio/
- **Registration:** http://localhost:8080/DhwaniPortfolio/register.jsp
- **Login:** http://localhost:8080/DhwaniPortfolio/login.jsp
- **Dashboard:** http://localhost:8080/DhwaniPortfolio/jsp/dashboard.jsp

---

##  Demo Credentials

For testing the admin features:

| Field | Value |
|-------|-------|
| Username | dhwani_chauhan |
| Password | demo@123456 |

---

##  Admin Dashboard Access

After login, access the dashboard at:
- **Dashboard Home**: `http://localhost:8080/jsp/dashboard.jsp`
- **Manage Projects**: `http://localhost:8080/jsp/manageProjects.jsp`
- **Manage Skills**: `http://localhost:8080/jsp/manageSkills.jsp`
- **View Messages**: `http://localhost:8080/jsp/viewMessages.jsp`

**Module 6 Implementation**: Complete Admin Dashboard with full CRUD operations (6 Marks)
- Projects CRUD: Add, Edit, Delete, List 
- Skills CRUD: Add, Edit, Delete, List 

See [MODULE6_IMPLEMENTATION.md](MODULE6_IMPLEMENTATION.md) for details.

---

##  Features Walkthrough

### Public Portfolio
1. **Home Section:** Eye-catching hero with profile introduction
2. **About Section:** Professional summary with contact information
3. **Skills Section:** Skills organized by category with proficiency levels
4. **Projects Section:** 
   - Live search projects by name/description
   - Filter by technology
   - Sort by latest/oldest/alphabetical
5. **Education Section:** Academic qualifications with GPA
6. **Contact Section:** 
   - Contact form with client-side validation
   - Email validation
   - AJAX submission
   - Async feedback messages

### Admin Dashboard (After Login)
1. **Dashboard Home:** Statistics and quick actions
2. **Projects Management:**
   - View all projects in a table
   - Add new project
   - Edit existing projects
   - Delete with confirmation
3. **Skills Management:**
   - View skills in card layout
   - Add new skill with category
   - Edit skill details
   - Delete skills
4. **Messages:** View all contact form submissions

### Theme Toggle
- Switch between dark and light modes
- Preference saved in local storage
- Smooth transition between themes

---

##  Security Features

1. **Password Security:**
   - SHA-256 hashing
   - Minimum 8 characters required
   - Strength validation

2. **Session Security:**
   - HttpOnly cookies
   - 30-minute timeout
   - Session validation on protected pages
   - Automatic logout on expiry

3. **Input Security:**
   - Server-side validation
   - HTML escaping for XSS prevention
   - PreparedStatement for SQL injection prevention
   - Email format validation

---

##  Responsive Design

- **Desktop:** Full layout with all features
- **Tablet:** Optimized grid layout
- **Mobile:** Single column layout, touch-friendly buttons

---

##  Troubleshooting

### Database Connection Error
- Verify MySQL is running
- Check database configuration in `db.properties`
- Ensure correct username and password

### Page Not Found (404)
- Verify deployment path in Tomcat
- Check web.xml servlet mappings

### Session Expired
- Login again (sessions expire after 30 minutes)
- Clear browser cookies and try again

### CSS/JS Not Loading
- Hard refresh browser (Ctrl+F5)
- Check file paths are relative to root

---

##  Contact & Support

**Portfolio Owner:** Dhwani Chauhan  
**Email:** dhwanichauhan1072004@gmail.com  
**Phone:** +91 9674310571  
**LinkedIn:** https://www.linkedin.com/in/dhwani-chauhan-aaa5ab280/  
**GitHub:** https://github.com/Dhwani107

---

##  License

This portfolio website is created for educational purposes as part of Web Technology course (TIU-UCS-E322) assignment.

---

##  Special Features

1. **Continuous Animations:** Smooth, continuous motion throughout the site
2. **Dark/Light Theme:** Toggle between themes with persistent preference
3. **Real-time Validation:** Instant feedback on form fields
4. **Responsive Design:** Looks great on all devices
5. **Professional UI:** Classy black/white/grey theme with modern design
6. **Complete CRUD:** Full project and skill management system
7. **Security First:** Hashed passwords and input validation
8. **Production Ready:** Error handling and logging throughout

---

**Version:** 1.0  
**Last Updated:** March 2026  
**Status:** Complete & Ready for Deployment

For any issues or questions, please refer to the assignment guidelines or contact the course instructor.
