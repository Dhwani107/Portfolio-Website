<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Add Skill - Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
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
        <h1 class="section-title" style="text-align: center; margin-bottom: 2rem;">Add New Skill</h1>

        <div class="form-card">
            <form method="POST" action="../skillsCRUD">
                <input type="hidden" name="action" value="add">

                <div class="form-group">
                    <label for="skillName">Skill Name *</label>
                    <input type="text" id="skillName" name="skillName" placeholder="e.g., Python, React, Machine Learning" required>
                </div>

                <div class="form-group">
                    <label for="category">Category *</label>
                    <select id="category" name="category" required>
                        <option value="">Select Category</option>
                        <option value="Programming">Programming</option>
                        <option value="Data Science">Data Science</option>
                        <option value="Database">Database</option>
                        <option value="Visualization">Visualization</option>
                        <option value="Web Framework">Web Framework</option>
                        <option value="Tools">Tools</option>
                        <option value="Design">Design</option>
                        <option value="Soft Skills">Soft Skills</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="proficiencyLevel">Proficiency Level *</label>
                    <select id="proficiencyLevel" name="proficiencyLevel" required>
                        <option value="">Select Level</option>
                        <option value="Beginner">Beginner</option>
                        <option value="Intermediate">Intermediate</option>
                        <option value="Advanced">Advanced</option>
                        <option value="Expert">Expert</option>
                    </select>
                </div>

                <div class="form-actions">
                    <a href="manageSkills.jsp" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Add Skill</button>
                </div>
            </form>
        </div>
    </div>

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

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }

        .form-actions .btn {
            flex: 1;
        }

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

    <script src="../js/main.js"></script>
</body>
</html>
