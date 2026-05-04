<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DatabaseConnection" %>
<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    String firstName = (String) session.getAttribute("firstName");
    String dashboardSuccessMessage = (String) session.getAttribute("dashboardSuccessMessage");
    if (dashboardSuccessMessage != null) {
        session.removeAttribute("dashboardSuccessMessage");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - <%=firstName%>'s Portfolio</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .dashboard-wrapper {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 2rem;
            align-items: stretch;
            margin-top: 1rem;
            max-width: 1400px;
            margin-left: auto;
            margin-right: auto;
            padding: 0 2rem;
        }

        .dashboard-page {
            padding-top: 82px;
        }

        .sidebar {
            background: linear-gradient(135deg, rgba(45, 45, 45, 0.7) 0%, rgba(40, 40, 40, 0.7) 100%);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 2rem;
            height: 100%;
            display: flex;
            flex-direction: column;
            position: relative;
            animation: slideInLeft 0.6s ease-out;
        }

        .dashboard-content {
            margin-top: 0;
        }

        .sidebar-header {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: var(--accent);
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border);
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 0.5rem;
        }

        .sidebar-menu a {
            display: block;
            padding: 0.8rem 1rem;
            color: var(--text-light);
            text-decoration: none;
            border-radius: 5px;
            transition: var(--transition);
            font-size: 0.95rem;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: rgba(100, 100, 100, 0.3);
            color: var(--accent);
            border-left: 3px solid var(--accent);
            padding-left: calc(1rem - 3px);
        }

        .sidebar-footer {
            margin-top: auto;
            padding-top: 2rem;
            border-top: 1px solid var(--border);
        }

        .dashboard-page header .navbar {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: auto 1fr auto;
            align-items: center;
            gap: 1.5rem;
        }

        .dashboard-page header nav {
            justify-self: center;
        }

        .dashboard-page header .nav-buttons {
            justify-self: end;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .dashboard-page .welcome-text {
            color: var(--text-light);
            opacity: 0.9;
            white-space: nowrap;
            font-weight: 500;
        }

        .sidebar-footer a {
            display: block;
            padding: 0.8rem 1rem;
            color: var(--accent);
            text-decoration: none;
            border-radius: 5px;
            transition: var(--transition);
            text-align: center;
            margin-bottom: 0.5rem;
        }

        .sidebar-footer a:hover {
            background: rgba(100, 100, 100, 0.3);
        }

        .dashboard-content {
            background: linear-gradient(135deg, rgba(45, 45, 45, 0.7) 0%, rgba(40, 40, 40, 0.7) 100%);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 2rem;
            animation: slideInRight 0.6s ease-out;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border);
        }

        .dashboard-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--accent);
            margin: 0;
        }

        .flash-success {
            background: rgba(80, 170, 120, 0.2);
            border: 1px solid rgba(80, 170, 120, 0.5);
            color: var(--text-light);
            border-radius: 8px;
            padding: 0.9rem 1rem;
            margin-bottom: 1rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: rgba(60, 60, 60, 0.5);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            transition: var(--transition);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            border-color: var(--accent);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--accent);
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--secondary-grey);
            font-size: 0.95rem;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .action-btn {
            background: linear-gradient(135deg, rgba(100, 150, 200, 0.4), rgba(80, 120, 180, 0.4));
            border: 1px solid rgba(100, 150, 200, 0.5);
            padding: 1rem;
            border-radius: 8px;
            color: var(--text-light);
            text-decoration: none;
            text-align: center;
            transition: var(--transition);
            font-weight: 600;
        }

        .action-btn:hover {
            background: linear-gradient(135deg, rgba(100, 150, 200, 0.6), rgba(80, 120, 180, 0.6));
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(100, 150, 200, 0.3);
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @media (max-width: 768px) {
            .dashboard-wrapper {
                grid-template-columns: 1fr;
            }

            .dashboard-page header .navbar {
                grid-template-columns: 1fr;
                gap: 0.8rem;
                justify-items: stretch;
            }

            .dashboard-page header nav,
            .dashboard-page header .nav-buttons {
                justify-self: stretch;
                width: 100%;
            }

            .dashboard-page header .nav-buttons {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 0.6rem;
                align-items: stretch;
            }

            .dashboard-page header .nav-buttons .btn {
                width: 100%;
                min-width: 0;
                text-align: center;
            }

            .dashboard-page .welcome-text {
                display: none;
            }

            .stat-card {
                padding: 1rem;
            }
        }
    </style>
</head>
<body class="authenticated dashboard-page">
    <!-- Navigation Header -->
    <header>
        <div class="navbar">
            <div class="logo">DC Admin</div>
            <nav>
                <ul>
                    <li><a href="../index.jsp">Back to Portfolio</a></li>
                </ul>
            </nav>
            <div class="nav-buttons">
                <button id="themeToggle" class="btn btn-secondary">☀️ Light Mode</button>
                <span class="welcome-text">Welcome, <%=firstName%>!</span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-secondary">Logout</a>
            </div>
        </div>
    </header>

    <div class="dashboard-wrapper">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">Dashboard Menu</div>
            <ul class="sidebar-menu">
                <li><a href="<%=request.getContextPath()%>/dashboard" class="active">Dashboard</a></li>
                <li><a href="<%=request.getContextPath()%>/jsp/manageProjects.jsp">Manage Projects</a></li>
                <li><a href="<%=request.getContextPath()%>/jsp/manageSkills.jsp">Manage Skills</a></li>
                <li><a href="<%=request.getContextPath()%>/jsp/viewMessages.jsp">Messages</a></li>
            </ul>
            <div class="sidebar-footer">
                <a href="<%=request.getContextPath()%>/index.jsp">View Public Portfolio</a>
                <a href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="dashboard-content">
            <% if (dashboardSuccessMessage != null) { %>
                <div class="flash-success"><%=dashboardSuccessMessage%></div>
            <% } %>

            <div class="dashboard-header">
                <h1 class="dashboard-title">Dashboard</h1>
                <p style="color: var(--secondary-grey);">Welcome back, <%=firstName%>!</p>
            </div>

            <!-- Statistics -->
            <div class="stats-grid">
                <%
                    Connection connection = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    int projectCount = 0, skillCount = 0, messageCount = 0;

                    try {
                        connection = DatabaseConnection.getConnection();

                        // Count projects
                        pstmt = connection.prepareStatement("SELECT COUNT(*) as count FROM projects WHERE user_id = ?");
                        pstmt.setInt(1, userId);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            projectCount = rs.getInt("count");
                        }

                        // Count skills
                        pstmt = connection.prepareStatement("SELECT COUNT(*) as count FROM skills WHERE user_id = ?");
                        pstmt.setInt(1, userId);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            skillCount = rs.getInt("count");
                        }

                        // Count messages
                        pstmt = connection.prepareStatement("SELECT COUNT(*) as count FROM messages WHERE is_read = false");
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            messageCount = rs.getInt("count");
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        DatabaseConnection.closeResources(connection, pstmt, rs);
                    }
                %>
                <div class="stat-card">
                    <div class="stat-number"><%=projectCount%></div>
                    <div class="stat-label">Projects</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%=skillCount%></div>
                    <div class="stat-label">Skills</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%=messageCount%></div>
                    <div class="stat-label">New Messages</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <h2 style="color: var(--accent); margin-bottom: 1rem; font-size: 1.3rem;">Quick Actions</h2>
            <div class="quick-actions">
                <a href="<%=request.getContextPath()%>/jsp/addProject.jsp" class="action-btn">+ Add Project</a>
                <a href="<%=request.getContextPath()%>/jsp/addSkill.jsp" class="action-btn">+ Add Skill</a>
                <a href="<%=request.getContextPath()%>/jsp/manageProjects.jsp" class="action-btn">Edit Projects</a>
                <a href="<%=request.getContextPath()%>/jsp/manageSkills.jsp" class="action-btn">Edit Skills</a>
                <a href="<%=request.getContextPath()%>/jsp/viewMessages.jsp" class="action-btn">View Messages</a>
                <a href="<%=request.getContextPath()%>/index.jsp" class="action-btn">View Portfolio</a>
            </div>

            <!-- Recent Activity -->
            <h2 style="color: var(--accent); margin-top: 2rem; margin-bottom: 1rem; font-size: 1.3rem;">Recent Activity</h2>
            <div style="background: rgba(60, 60, 60, 0.5); border: 1px solid var(--border); border-radius: 8px; padding: 1.5rem;">
                <p style="color: var(--secondary-grey); text-align: center;">Your dashboard is ready to use!</p>
                <p style="color: var(--secondary-grey); text-align: center; font-size: 0.9rem; margin-top: 1rem;">
                    Click on the menu items to manage your portfolio content.
                </p>
            </div>
        </main>
    </div>

    <script src="../js/main.js"></script>
</body>
</html>
