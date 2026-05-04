<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DatabaseConnection" %>
<%@ page import="java.util.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Projects - Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .page-shell {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 760px;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        thead {
            background: rgba(60, 60, 60, 0.5);
        }

        th {
            padding: 1rem;
            text-align: left;
            color: var(--accent);
            font-weight: 600;
            border-bottom: 2px solid var(--border);
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }

        tr:hover {
            background: rgba(60, 60, 60, 0.3);
        }

        .action-cell {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-sm {
            padding: 0.4rem 0.8rem;
            font-size: 0.85rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-block;
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

        .badge {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.85rem;
        }

        .badge-featured {
            background: rgba(255, 200, 0, 0.2);
            color: #FFD700;
            border: 1px solid rgba(255, 200, 0, 0.5);
        }

        .tech-list {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.8);
            animation: fadeIn 0.3s ease-out;
        }

        .modal-content {
            background: linear-gradient(135deg, rgba(45, 45, 45, 0.95), rgba(40, 40, 40, 0.95));
            margin: 5% auto;
            padding: 2rem;
            border: 1px solid var(--border);
            border-radius: 10px;
            max-width: 400px;
            animation: slideInUp 0.3s ease-out;
        }

        .modal-header {
            color: var(--accent);
            font-size: 1.3rem;
            margin-bottom: 1rem;
        }

        .modal-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 1.5rem;
        }

        .btn-confirm, .btn-cancel {
            padding: 0.6rem 1rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-confirm {
            background: rgba(200, 100, 100, 0.6);
            color: white;
        }

        .btn-confirm:hover {
            background: rgba(200, 100, 100, 0.8);
        }

        .btn-cancel {
            background: rgba(100, 100, 100, 0.6);
            color: white;
        }

        .btn-cancel:hover {
            background: rgba(100, 100, 100, 0.8);
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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

            th,
            td {
                white-space: nowrap;
                padding: 0.75rem;
                font-size: 0.9rem;
            }

            .action-cell {
                flex-direction: column;
                align-items: stretch;
            }

            .action-cell .btn-sm {
                text-align: center;
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
            <h1 class="section-title">Manage Projects</h1>
            <a href="addProject.jsp" class="btn btn-primary">+ Add New Project</a>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Technologies</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection connection = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        connection = DatabaseConnection.getConnection();
                        String query = "SELECT * FROM projects WHERE user_id = ? ORDER BY created_at DESC";
                        pstmt = connection.prepareStatement(query);
                        pstmt.setInt(1, userId);
                        rs = pstmt.executeQuery();

                        if (!rs.next()) {
                %>
                    <tr>
                        <td colspan="5" style="text-align: center; color: var(--secondary-grey);">
                            No projects found. <a href="addProject.jsp" style="color: var(--accent);">Create one</a>
                        </td>
                    </tr>
                <%
                        } else {
                            do {
                                int projectId = rs.getInt("project_id");
                                String technologies = rs.getString("technologies");
                                if (technologies == null) {
                                    technologies = "";
                                }
                                if (technologies.length() > 30) {
                                    technologies = technologies.substring(0, 30) + "...";
                                }
                %>
                    <tr>
                        <td><%=rs.getString("title")%></td>
                        <td class="tech-list"><%=technologies%></td>
                        <td>
                            <% if (rs.getBoolean("featured")) { %>
                                <span class="badge badge-featured">Featured</span>
                            <% } else { %>
                                <span style="color: var(--secondary-grey);">Draft</span>
                            <% } %>
                        </td>
                        <td style="font-size: 0.9rem; color: var(--secondary-grey);"><%=rs.getString("created_at").substring(0, 10)%></td>
                        <td>
                            <div class="action-cell">
                                <a href="editProject.jsp?id=<%=projectId%>" class="btn-sm btn-edit">Edit</a>
                                <form method="POST" action="<%=request.getContextPath()%>/projectsCRUD" style="display:inline; margin:0;" onsubmit="return confirm('Are you sure you want to delete this project?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%=projectId%>">
                                    <button type="submit" class="btn-sm btn-delete">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <%
                            } while (rs.next());
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        DatabaseConnection.closeResources(connection, pstmt, rs);
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <script src="../js/main.js"></script>
    <% if (successMessage != null) { %>
    <script>
        alert('<%=successMessage.replace("'", "\\'")%>');
    </script>
    <% } %>
</body>
</html>
