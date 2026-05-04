<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DatabaseConnection" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Skills - Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .page-shell {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .skills-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .skill-item {
            background: linear-gradient(135deg, rgba(45, 45, 45, 0.7) 0%, rgba(40, 40, 40, 0.7) 100%);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.5rem;
            transition: var(--transition);
        }

        .skill-item:hover {
            transform: translateY(-5px);
            border-color: var(--accent);
            box-shadow: 0 10px 30px rgba(255, 255, 255, 0.1);
        }

        .skill-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }

        .skill-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--accent);
        }

        .skill-category {
            display: inline-block;
            background: rgba(100, 100, 100, 0.2);
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
            color: var(--secondary-grey);
            margin-top: 0.5rem;
        }

        .skill-level {
            color: var(--secondary-grey);
            font-size: 0.9rem;
            margin-top: 0.5rem;
        }

        .skill-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border);
        }

        .btn-sm {
            flex: 1;
            padding: 0.4rem 0.6rem;
            font-size: 0.85rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            text-align: center;
            display: block;
        }

        .btn-edit {
            background: rgba(100, 150, 200, 0.4);
            color: var(--text-light);
            border: 1px solid rgba(100, 150, 200, 0.6);
        }

        .btn-edit:hover {
            background: rgba(100, 150, 200, 0.6);
        }

        .btn-delete {
            background: rgba(200, 100, 100, 0.4);
            color: var(--text-light);
            border: 1px solid rgba(200, 100, 100, 0.6);
        }

        .btn-delete:hover {
            background: rgba(200, 100, 100, 0.6);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--secondary-grey);
        }

        .empty-state h3 {
            color: var(--accent);
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .page-shell {
                padding: 0 1rem;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .skills-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .skill-item {
                padding: 1rem;
            }

            .skill-actions {
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
                    <li><a href="../index.jsp">Back to Portfolio</a></li>
                </ul>
            </nav>
            <div class="nav-buttons">
                <button id="themeToggle" class="btn btn-secondary">☀️ Light Mode</button>
                <a href="../logout" class="btn btn-secondary">Logout</a>
            </div>
        </div>
    </header>

    <div class="page-shell">
        <div class="page-header">
            <h1 class="section-title">Manage Skills</h1>
            <a href="addSkill.jsp" class="btn btn-primary">+ Add New Skill</a>
        </div>

        <div class="skills-grid">
        <%
            Connection connection = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            boolean hasSkills = false;
            try {
                connection = DatabaseConnection.getConnection();
                String query = "SELECT * FROM skills WHERE user_id = ? ORDER BY category, skill_name";
                pstmt = connection.prepareStatement(query);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    int skillId = rs.getInt("skill_id");
                    hasSkills = true;
        %>
            <div class="skill-item">
                <div class="skill-header">
                    <div>
                        <div class="skill-name"><%=rs.getString("skill_name")%></div>
                        <div class="skill-category"><%=rs.getString("category")%></div>
                    </div>
                </div>
                <div class="skill-level">
                    <strong>Proficiency:</strong> <%=rs.getString("proficiency_level")%>
                </div>
                <div class="skill-actions">
                    <a href="editSkill.jsp?id=<%=skillId%>" class="btn-sm btn-edit">Edit</a>
                    <button onclick="confirmDelete(this.getAttribute('data-id'))" data-id="<%=skillId%>" class="btn-sm btn-delete">Delete</button>
                </div>
            </div>
        <%
                }

                if (!hasSkills) {
        %>
            </div>
            <div class="empty-state">
                <h3>No skills found</h3>
                <p>Start adding skills to showcase your expertise.</p>
                <a href="addSkill.jsp" class="btn btn-primary" style="max-width: 200px; margin: 1rem auto;">+ Add Your First Skill</a>
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
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal" style="
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.8);
    ">
        <div class="modal-content" style="
            background: linear-gradient(135deg, rgba(45, 45, 45, 0.95), rgba(40, 40, 40, 0.95));
            margin: 5% auto;
            padding: 2rem;
            border: 1px solid var(--border);
            border-radius: 10px;
            max-width: 400px;
        ">
            <div style="color: var(--accent); font-size: 1.3rem; margin-bottom: 1rem;">Delete Skill</div>
            <p style="color: var(--secondary-grey); margin-bottom: 1rem;">Are you sure you want to delete this skill?</p>
            <div style="display: flex; gap: 1rem; justify-content: flex-end; margin-top: 1.5rem;">
                <button style="padding: 0.6rem 1rem; background: rgba(100, 100, 100, 0.6); color: white; border: none; border-radius: 5px; cursor: pointer;" onclick="closeModal()">Cancel</button>
                <button style="padding: 0.6rem 1rem; background: rgba(200, 100, 100, 0.6); color: white; border: none; border-radius: 5px; cursor: pointer;" onclick="deleteSkill()">Delete</button>
            </div>
        </div>
    </div>

    <script>
        let skillIdToDelete = null;

        function confirmDelete(skillId) {
            skillIdToDelete = skillId;
            document.getElementById('deleteModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('deleteModal').style.display = 'none';
            skillIdToDelete = null;
        }

        function deleteSkill() {
            if (skillIdToDelete) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '../skillsCRUD';
                form.innerHTML = `
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${skillIdToDelete}">
                `;
                document.body.appendChild(form);
                form.submit();
            }
        }

        window.onclick = function(event) {
            const modal = document.getElementById('deleteModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>

    <script src="../js/main.js"></script>
</body>
</html>
