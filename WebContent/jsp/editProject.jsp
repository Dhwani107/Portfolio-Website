<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DatabaseConnection" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    int projectId = Integer.parseInt(request.getParameter("id") != null ? request.getParameter("id") : "0");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Project - Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .form-container {
            max-width: 700px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .form-card {
            background: linear-gradient(135deg, rgba(45, 45, 45, 0.7) 0%, rgba(40, 40, 40, 0.7) 100%);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--accent);
            font-weight: 600;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.8rem;
            background: rgba(60, 60, 60, 0.5);
            border: 1px solid var(--border);
            border-radius: 5px;
            color: var(--text-light);
            font-family: inherit;
            transition: var(--transition);
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent);
            background: rgba(80, 80, 80, 0.8);
            box-shadow: 0 0 15px rgba(255, 255, 255, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }

        .btn {
            flex: 1;
        }

        @media (max-width: 768px) {
            .form-container {
                padding: 0 1rem;
            }

            .form-card {
                padding: 1.2rem;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body class="authenticated">
    <header>
        <div class="navbar">
            <div class="logo">DC Admin</div>
            <nav>
                <ul>
                    <li><a href="dashboard.jsp">Dashboard</a></li>
                    <li><a href="manageProjects.jsp">Projects</a></li>
                </ul>
            </nav>
            <div class="nav-buttons">
                <button id="themeToggle" class="btn btn-secondary">☀️ Light Mode</button>
                <a href="../logout" class="btn btn-secondary">Logout</a>
            </div>
        </div>
    </header>

    <div class="form-container">
        <h1 class="section-title" style="text-align: center; margin-bottom: 2rem;">Edit Project</h1>

        <div class="form-card">
            <%
                Connection connection = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    connection = DatabaseConnection.getConnection();
                    String query = "SELECT * FROM projects WHERE project_id = ? AND user_id = ?";
                    pstmt = connection.prepareStatement(query);
                    pstmt.setInt(1, projectId);
                    pstmt.setInt(2, userId);
                    rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
            %>
            <form method="POST" action="../projectsCRUD">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="projectId" value="<%=projectId%>">

                <div class="form-group">
                    <label for="title">Project Title *</label>
                    <input type="text" id="title" name="title" value="<%=rs.getString("title")%>" required>
                </div>

                <div class="form-group">
                    <label for="description">Description *</label>
                    <textarea id="description" name="description" required><%=rs.getString("description")%></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="startDate">Start Date</label>
                        <input type="date" id="startDate" name="startDate" value="<%=rs.getString("start_date")%>">
                    </div>
                    <div class="form-group">
                        <label for="endDate">End Date</label>
                        <input type="date" id="endDate" name="endDate" value="<%=rs.getString("end_date")%>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="technologies">Technologies (comma-separated) *</label>
                    <input type="text" id="technologies" name="technologies" value="<%=rs.getString("technologies")%>" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="githubUrl" class="platform-with-icon">
                            <img src="../images/github-logo.svg" alt="GitHub" class="platform-icon">
                            GitHub URL
                        </label>
                        <input type="url" id="githubUrl" name="githubUrl" value="<%=rs.getString("github_url") != null ? rs.getString("github_url") : ""%>">
                    </div>
                    <div class="form-group">
                        <label for="projectUrl">Live Demo URL</label>
                        <input type="url" id="projectUrl" name="projectUrl" value="<%=rs.getString("project_url") != null ? rs.getString("project_url") : ""%>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="imageUrl">Project Image URL</label>
                    <input type="url" id="imageUrl" name="imageUrl" value="<%=rs.getString("image_url") != null ? rs.getString("image_url") : ""%>">
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="featured" name="featured" value="1" <%=rs.getBoolean("featured") ? "checked" : ""%>>
                        <label for="featured" style="margin: 0; font-weight: 400;">Mark as Featured Project</label>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="manageProjects.jsp" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Update Project</button>
                </div>
            </form>
            <%
                    } else {
                        out.println("<p style='color: var(--accent); text-align: center;'>Project not found</p>");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    DatabaseConnection.closeResources(connection, pstmt, rs);
                }
            %>
        </div>
    </div>

    <script src="../js/main.js"></script>
</body>
</html>
