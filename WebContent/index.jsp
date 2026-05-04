<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DatabaseConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // Get user session info
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    boolean isLoggedIn = userId != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dhwani Chauhan - Portfolio</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation Header -->
    <header>
        <div class="navbar">
            <div class="logo">DC</div>
            <nav>
                <ul>
                    <li><a href="#home">Home</a></li>
                    <li><a href="#about">About</a></li>
                    <li><a href="#skills">Skills</a></li>
                    <li><a href="#projects">Projects</a></li>
                    <li><a href="#education">Education</a></li>
                    <li><a href="#contact">Contact</a></li>
                </ul>
            </nav>
            <div class="nav-buttons">
                <button id="themeToggle" class="btn btn-secondary">☀️ Light Mode</button>
                <% if (isLoggedIn) { %>
                    <a href="jsp/dashboard.jsp" class="btn btn-primary">Dashboard</a>
                    <a href="logout" class="btn btn-secondary">Logout</a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-secondary">Login</a>
                    <a href="register.jsp" class="btn btn-primary">Register</a>
                <% } %>
            </div>
        </div>
    </header>

    <main>
        <!-- Hero Section -->
        <section class="hero" id="home">
            <div class="hero-content">
                <div class="hero-name-shell">
                    <h1 class="hero-name">Dhwani Chauhan</h1>
                </div>
                <p>Aspiring AI/ML Engineer & Data Scientist</p>
                <p class="hero-subtext">
                    Passionate about building AI-powered and data-driven solutions
                </p>
                <div class="hero-badges">
                    <span class="hero-badge">AI/ML</span>
                    <span class="hero-badge">Data Science</span>
                    <span class="hero-badge">GenAI • LLM • RAG</span>
                </div>
                <div class="cta-buttons">
                    <a href="#projects" class="btn btn-primary">View My Work</a>
                    <a href="#contact" class="btn btn-secondary">Get In Touch</a>
                </div>
                <div class="hero-stats">
                    <div class="stat-card">
                        <span class="stat-value">8.42</span>
                        <span class="stat-label">Current GPA</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-value">30+</span>
                        <span class="stat-label">Skills & Tools</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-value">2027</span>
                        <span class="stat-label">Graduation Year</span>
                    </div>
                </div>
                <div class="hero-signature-row">
                    <span class="signature-pill">Top 30 • SIH Internal Round</span>
                    <span class="signature-pill">IBM Certifications</span>
                    <span class="signature-pill">Open to Opportunities</span>
                </div>
            </div>
        </section>

        <!-- About Section -->
        <section id="about">
            <h2 class="section-title">About Me</h2>
            <p class="section-subtitle">Learn more about my journey and expertise</p>
            <% 
                Connection connection = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
            %>
            
            <div class="about-shell">
               
                <p style="color: light rgb(203, 195, 195); line-height: 1.8; margin-bottom: 2rem; text-align: justify;">
                    Aspiring AI/ML Engineer and Data Scientist with hands on experience in Python, NumPy, Pandas, and Scikit-learn for data analysis and machine learning. Skilled in data preprocessing, exploratory data analysis, visualization, and predictive modeling. Familiar with Power BI for dashboard and basic knowledge of C++ and Data Structures. Currently I am Working on deep diving into Generative AI, LLMs, RAG and Agentic AI systems to build AI-powered intelligent applications. Passionate about building data-driven and AI-powered solutions.
                </p>
                <div class="grid about-grid" align="center" >
                    <div class="card" >
                        <h3>Email</h3>
                        <p><a href="mailto:dhwanichauhan1072004@gmail.com" style="color: var(--text-light); text-decoration: none;">dhwanichauhan1072004@gmail.com</a></p>
                    </div>
                    <div class="card">
                        <h3>Phone</h3>
                        <p><a href="tel:+919674310571" style="color: var(--text-light); text-decoration: none;">+91 9674310571</a></p>
                    </div>
                    <div class="card" >
                        <h3 class="platform-with-icon">
                            <img src="images/linkedin-logo.svg" alt="LinkedIn" class="platform-icon">
                            LinkedIn
                        </h3>
                        <p><a href="https://www.linkedin.com/in/dhwani-chauhan-aaa5ab280/" target="_blank" style="color: var(--text-light); text-decoration: none;">View Profile</a></p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Skills Section -->
        <section id="skills">
            <h2 class="section-title">Skills</h2>
            <p class="section-subtitle">Technical expertise and competencies</p>
            
            <%
                connection = null;
                pstmt = null;
                rs = null;
                boolean hasSkills = false;
                try {
                    connection = DatabaseConnection.getConnection();
                    String query = "SELECT DISTINCT category FROM skills WHERE user_id = 1 ORDER BY category";
                    pstmt = connection.prepareStatement(query);
                    rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        hasSkills = true;
                        String category = rs.getString("category");
            %>
                <div class="skill-category">
                    <h3 class="category-title"><%=category%></h3>
                    <div class="skills-container">
            <%
                        // Inner query for skills in this category
                        PreparedStatement innerStmt = connection.prepareStatement(
                            "SELECT skill_name, proficiency_level FROM skills WHERE user_id = 1 AND category = ? ORDER BY skill_name"
                        );
                        innerStmt.setString(1, category);
                        ResultSet innerRs = innerStmt.executeQuery();
                        
                        while (innerRs.next()) {
            %>
                            <div class="skill-tag" title="<%=innerRs.getString("proficiency_level")%>">
                                <%=innerRs.getString("skill_name")%>
                            </div>
            <%
                        }
                        innerRs.close();
                        innerStmt.close();
            %>
                    </div>
                </div>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    DatabaseConnection.closeResources(connection, pstmt, rs);
                }

                if (!hasSkills) {
            %>
                <div class="skill-category">
                    <h3 class="category-title">Programming and Analysis</h3>
                    <div class="skills-container">
                        <div class="skill-tag">Python (NumPy, Pandas, Scikit-learn)</div>
                        <div class="skill-tag">Natural Language Processing</div>
                        <div class="skill-tag">Feature Engineering</div>
                        <div class="skill-tag">Model Training and Testing</div>
                        <div class="skill-tag">C++</div>
                    </div>
                </div>
                <div class="skill-category">
                    <h3 class="category-title">Databases</h3>
                    <div class="skills-container">
                        <div class="skill-tag">MySQL</div>
                        <div class="skill-tag">MongoDB</div>
                    </div>
                </div>
                <div class="skill-category">
                    <h3 class="category-title">Business Intelligence and Visualization</h3>
                    <div class="skills-container">
                        <div class="skill-tag">Power BI</div>
                        <div class="skill-tag">Tableau</div>
                        <div class="skill-tag">Streamlit</div>
                        <div class="skill-tag">Excel</div>
                        <div class="skill-tag">PowerPoint</div>
                        <div class="skill-tag">Word</div>
                    </div>
                </div>
                <div class="skill-category">
                    <h3 class="category-title">Tools</h3>
                    <div class="skills-container">
                        <div class="skill-tag platform-with-icon">
                            <img src="images/github-logo.svg" alt="GitHub" class="platform-icon">
                            Git/GitHub
                        </div>
                        <div class="skill-tag">Jupyter Notebook</div>
                        <div class="skill-tag">Visual Studio Code</div>
                    </div>
                </div>
                <div class="skill-category">
                    <h3 class="category-title">Web Framework</h3>
                    <div class="skills-container">
                        <div class="skill-tag">Flask</div>
                        <div class="skill-tag">Django</div>
                    </div>
                </div>
                <div class="skill-category">
                    <h3 class="category-title">Designing Tools</h3>
                    <div class="skills-container">
                        <div class="skill-tag">Canva</div>
                        <div class="skill-tag">Figma</div>
                    </div>
                </div>
                <div class="skill-category">
                    <h3 class="category-title">Soft Skills</h3>
                    <div class="skills-container">
                        <div class="skill-tag">Leadership</div>
                        <div class="skill-tag">Teamwork</div>
                        <div class="skill-tag">Content Writing</div>
                        <div class="skill-tag">Good Communication</div>
                    </div>
                </div>
            <%
                }
            %>
        </section>

        <!-- Projects Section -->
        <section id="projects">
            <h2 class="section-title">Featured Projects</h2>
            <p class="section-subtitle">Showcasing my recent work and innovations</p>
            
            <div class="project-controls">
                <input type="text" class="search-projects control-input" placeholder="Search projects...">
                <select class="sort-projects control-select">
                    <option value="">Sort by...</option>
                    <option value="latest">Latest First</option>
                    <option value="oldest">Oldest First</option>
                    <option value="alphabetical">Alphabetical</option>
                </select>
            </div>

            <div class="projects-grid">
            <%
                connection = null;
                pstmt = null;
                rs = null;
                try {
                    connection = DatabaseConnection.getConnection();
                    String query = "SELECT * FROM projects WHERE user_id = 1 ORDER BY start_date DESC";
                    pstmt = connection.prepareStatement(query);
                    rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        String technologies = rs.getString("technologies") != null ? rs.getString("technologies") : "";
                        String title = rs.getString("title") != null ? rs.getString("title") : "";
                        String description = rs.getString("description") != null ? rs.getString("description") : "";
                        String startDate = rs.getString("start_date") != null ? rs.getString("start_date") : "";
                        String imageUrl = rs.getString("image_url") != null ? rs.getString("image_url") : "";
            %>
                <div class="project-card" 
                    data-technologies="<%=technologies%>" 
                    data-title="<%=title%>"
                    data-description="<%=description%>"
                    data-date="<%=startDate%>">
                    <div class="project-image">
                    <%
                        if (!imageUrl.trim().isEmpty()) {
                    %>
                        <img src="<%=imageUrl%>" alt="<%=title%> cover image" class="project-cover-image" loading="lazy" onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-flex';">
                        <span class="project-fallback-icon" style="display: none;">🚀</span>
                    <%
                        } else {
                    %>
                        <span class="project-fallback-icon">🚀</span>
                    <%
                        }
                    %>
                    </div>
                    <div class="project-content">
                        <h3 class="project-title"><%=title%></h3>
                        <p class="project-description"><%=description%></p>
                        <div class="project-tech">
            <%
                            String[] techArray = technologies.split(",");
                            for (String tech : techArray) {
                                if (!tech.trim().isEmpty()) {
            %>
                                <span class="tech-tag"><%=tech.trim()%></span>
            <%
                                }
                            }
            %>
                        </div>
                        <div class="project-links">
            <%
                            if (rs.getString("github_url") != null && !rs.getString("github_url").isEmpty()) {
            %>
                                <a href="<%=rs.getString("github_url")%>" target="_blank" class="platform-with-icon">
                                    <img src="images/github-logo.svg" alt="GitHub" class="platform-icon">
                                    GitHub
                                </a>
            <%
                            }
                            if (rs.getString("project_url") != null && !rs.getString("project_url").isEmpty()) {
            %>
                                <a href="<%=rs.getString("project_url")%>" target="_blank">Live Demo</a>
            <%
                            }
            %>
                        </div>
                    </div>
                </div>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    DatabaseConnection.closeResources(connection, pstmt, rs);
                }
            %>
            </div>
        </section>

        <!-- Education Section -->
        <section id="education">
            <h2 class="section-title">Education</h2>
            <p class="section-subtitle">Academic background and achievements</p>
            
            <div class="grid education-grid">
            <%
                connection = null;
                pstmt = null;
                rs = null;
                boolean hasEducation = false;
                try {
                    connection = DatabaseConnection.getConnection();
                    String query = "SELECT * FROM education WHERE user_id = 1 ORDER BY end_date DESC";
                    pstmt = connection.prepareStatement(query);
                    rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        hasEducation = true;
            %>
                <div class="card">
                    <h3><%=rs.getString("degree")%> in <%=rs.getString("field_of_study")%></h3>
                    <p style="color: var(--accent); font-weight: 600; margin-bottom: 0.5rem;">
                        <%=rs.getString("institution_name")%>
                    </p>
                    <p style="color: var(--secondary-grey); font-size: 0.9rem; margin-bottom: 1rem;">
                        <%=rs.getString("start_date")%> to <%=rs.getString("end_date")%>
                    </p>
                    <% if (rs.getDouble("gpa") > 0) { %>
                    <p style="margin-bottom: 1rem;">
                        <strong>GPA:</strong> <%=rs.getDouble("gpa")%>
                    </p>
                    <% } %>
                    <p><%=rs.getString("description")%></p>
                </div>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    DatabaseConnection.closeResources(connection, pstmt, rs);
                }

                if (!hasEducation) {
            %>
                <div class="card">
                    <h3>B.Tech in Computer Science and Engineering</h3>
                    <p style="color: var(--accent); font-weight: 600; margin-bottom: 0.5rem;">
                        Techno India University, Kolkata
                    </p>
                    <p style="color: var(--secondary-grey); font-size: 0.9rem; margin-bottom: 1rem;">
                        Graduating in 2027
                    </p>
                    <p><strong>GPA:</strong> 8.42</p>
                </div>
                <div class="card">
                    <h3>Higher Secondary</h3>
                    <p style="color: var(--accent); font-weight: 600; margin-bottom: 0.5rem;">
                        H.M. Education Centre, Kolkata
                    </p>
                    <p style="color: var(--secondary-grey); font-size: 0.9rem; margin-bottom: 1rem;">
                        Completed in 2023
                    </p>
                    <p><strong>Score:</strong> 74.2%</p>
                </div>
                <div class="card">
                    <h3>Secondary</h3>
                    <p style="color: var(--accent); font-weight: 600; margin-bottom: 0.5rem;">
                        H.M. Education Centre, Kolkata
                    </p>
                    <p style="color: var(--secondary-grey); font-size: 0.9rem; margin-bottom: 1rem;">
                        Completed in 2021
                    </p>
                    <p><strong>Score:</strong> 95.6%</p>
                </div>
            <%
                }
            %>
            </div>
        </section>

        <!-- Contact Section -->
        <section id="contact">
            <h2 class="section-title">Get In Touch</h2>
            <p class="section-subtitle">Feel free to reach out for opportunities or just to connect</p>
            
            <div class="contact-grid">
                <div class="contact-info">
                    <div class="contact-item">
                        <h3>Email</h3>
                        <p><a href="mailto:dhwanichauhan1072004@gmail.com">dhwanichauhan1072004@gmail.com</a></p>
                    </div>
                    <div class="contact-item">
                        <h3>Phone</h3>
                        <p><a href="tel:+919674310571">+91 9674310571</a></p>
                    </div>
                    <div class="contact-item">
                        <h3>Social Links</h3>
                        <div class="social-links">
                            <a href="https://www.linkedin.com/in/dhwani-chauhan-aaa5ab280/" target="_blank" title="LinkedIn" class="platform-with-icon">
                                <img src="images/linkedin-logo.svg" alt="LinkedIn" class="platform-icon">
                                LinkedIn
                            </a>
                            <a href="https://github.com/Dhwani107" target="_blank" title="GitHub" class="platform-with-icon">
                                <img src="images/github-logo.svg" alt="GitHub" class="platform-icon">
                                GitHub
                            </a>
                        </div>
                    </div>
                </div>

                <form id="contactForm" class="contact-form">
                    <div class="form-group">
                        <label for="name">Your Name *</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Your Email *</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <input type="text" id="subject" name="subject">
                    </div>
                    <div class="form-group">
                        <label for="message">Message *</label>
                        <textarea id="message" name="message" required></textarea>
                    </div>
                    <button type="submit" class="submit-btn">Send Message</button>
                </form>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer>
        <div class="social-links">
            <a href="https://www.linkedin.com/in/dhwani-chauhan-aaa5ab280/" target="_blank" class="platform-with-icon">
                <img src="images/linkedin-logo.svg" alt="LinkedIn" class="platform-icon">
                LinkedIn
            </a>
            <a href="https://github.com/Dhwani107" target="_blank" class="platform-with-icon">
                <img src="images/github-logo.svg" alt="GitHub" class="platform-icon">
                GitHub
            </a>
        </div>
        <p>&copy; 2026 Dhwani Chauhan. All rights reserved.</p>
        <p class="footer-note">Designed with 💜 | Built with HTML, CSS, JavaScript & Java</p>
    </footer>

    <script src="js/main.js"></script>
</body>
</html>
