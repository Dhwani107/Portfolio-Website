<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DatabaseConnection" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    int skillId = Integer.parseInt(request.getParameter("id") != null ? request.getParameter("id") : "0");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Skill - Dashboard</title>
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
        .form-group select {
            width: 100%;
            padding: 0.8rem;
            background: rgba(60, 60, 60, 0.5);
            border: 1px solid var(--border);
            border-radius: 5px;
            color: var(--text-light);
            font-family: inherit;
            transition: var(--transition);
            cursor: pointer;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--accent);
            background: rgba(80, 80, 80, 0.8);
            box-shadow: 0 0 15px rgba(255, 255, 255, 0.1);
        }

        .form-group select option {
            background: var(--primary-dark);
            color: var(--text-light);
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
                    <li><a href="manageSkills.jsp">Skills</a></li>
                </ul>
            </nav>
            <div class="nav-buttons">
                <button id="themeToggle" class="btn btn-secondary">☀️ Light Mode</button>
                <a href="../logout" class="btn btn-secondary">Logout</a>
            </div>
        </div>
    </header>

    <div class="form-container">
        <h1 class="section-title" style="text-align: center; margin-bottom: 2rem;">Edit Skill</h1>

        <div class="form-card">
            <%
                Connection connection = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    connection = DatabaseConnection.getConnection();
                    String query = "SELECT * FROM skills WHERE skill_id = ? AND user_id = ?";
                    pstmt = connection.prepareStatement(query);
                    pstmt.setInt(1, skillId);
                    pstmt.setInt(2, userId);
                    rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
            %>
            <form method="POST" action="../skillsCRUD">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="skillId" value="<%=skillId%>">

                <div class="form-group">
                    <label for="skillName">Skill Name *</label>
                    <input type="text" id="skillName" name="skillName" value="<%=rs.getString("skill_name")%>" required>
                </div>

                <div class="form-group">
                    <label for="category">Category *</label>
                    <select id="category" name="category" required>
                        <option value="">Select Category</option>
                        <option value="Programming" <%="Programming".equals(rs.getString("category")) ? "selected" : ""%>>Programming</option>
                        <option value="Data Science" <%="Data Science".equals(rs.getString("category")) ? "selected" : ""%>>Data Science</option>
                        <option value="Database" <%="Database".equals(rs.getString("category")) ? "selected" : ""%>>Database</option>
                        <option value="Visualization" <%="Visualization".equals(rs.getString("category")) ? "selected" : ""%>>Visualization</option>
                        <option value="Web Framework" <%="Web Framework".equals(rs.getString("category")) ? "selected" : ""%>>Web Framework</option>
                        <option value="Tools" <%="Tools".equals(rs.getString("category")) ? "selected" : ""%>>Tools</option>
                        <option value="Design" <%="Design".equals(rs.getString("category")) ? "selected" : ""%>>Design</option>
                        <option value="Soft Skills" <%="Soft Skills".equals(rs.getString("category")) ? "selected" : ""%>>Soft Skills</option>
                        <option value="Other" <%="Other".equals(rs.getString("category")) ? "selected" : ""%>>Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="proficiencyLevel">Proficiency Level *</label>
                    <select id="proficiencyLevel" name="proficiencyLevel" required>
                        <option value="">Select Level</option>
                        <option value="Beginner" <%="Beginner".equals(rs.getString("proficiency_level")) ? "selected" : ""%>>Beginner</option>
                        <option value="Intermediate" <%="Intermediate".equals(rs.getString("proficiency_level")) ? "selected" : ""%>>Intermediate</option>
                        <option value="Advanced" <%="Advanced".equals(rs.getString("proficiency_level")) ? "selected" : ""%>>Advanced</option>
                        <option value="Expert" <%="Expert".equals(rs.getString("proficiency_level")) ? "selected" : ""%>>Expert</option>
                    </select>
                </div>

                <div class="form-actions">
                    <a href="manageSkills.jsp" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Update Skill</button>
                </div>
            </form>
            <%
                    } else {
                        out.println("<p style='color: var(--accent); text-align: center;'>Skill not found</p>");
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
