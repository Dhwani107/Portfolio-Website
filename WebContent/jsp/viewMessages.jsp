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
    <title>Messages - Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .messages-container {
            max-width: 900px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .message-card {
            background: linear-gradient(135deg, rgba(45, 45, 45, 0.7) 0%, rgba(40, 40, 40, 0.7) 100%);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: var(--transition);
        }

        .message-card:hover {
            border-color: var(--accent);
            box-shadow: 0 5px 15px rgba(255, 255, 255, 0.1);
        }

        .message-card.unread {
            border-left: 4px solid var(--accent);
            background: linear-gradient(135deg, rgba(50, 50, 50, 0.8) 0%, rgba(45, 45, 45, 0.8) 100%);
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }

        .message-from {
            flex: 1;
        }

        .message-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--accent);
        }

        .message-email {
            color: var(--secondary-grey);
            font-size: 0.9rem;
        }

        .message-subject {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-light);
            margin-top: 0.5rem;
        }

        .message-date {
            color: var(--secondary-grey);
            font-size: 0.85rem;
            text-align: right;
        }

        .message-body {
            background: rgba(60, 60, 60, 0.3);
            border: 1px solid var(--border);
            border-radius: 5px;
            padding: 1rem;
            margin: 1rem 0;
            color: var(--text-light);
            line-height: 1.6;
            white-space: pre-wrap;
            word-wrap: break-word;
        }

        .message-actions {
            display: flex;
            gap: 0.5rem;
            justify-content: flex-end;
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

        .btn-reply {
            background: rgba(100, 150, 200, 0.4);
            color: var(--text-light);
            border: 1px solid rgba(100, 150, 200, 0.6);
        }

        .btn-reply:hover {
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

        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--secondary-grey);
            background: linear-gradient(135deg, rgba(45, 45, 45, 0.5) 0%, rgba(40, 40, 40, 0.5) 100%);
            border: 1px solid var(--border);
            border-radius: 8px;
            margin: 2rem 0;
        }

        .filter-bar {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 0.6rem 1rem;
            background: rgba(60, 60, 60, 0.5);
            border: 1px solid var(--border);
            border-radius: 5px;
            color: var(--text-light);
            cursor: pointer;
            transition: var(--transition);
        }

        .filter-btn.active {
            background: rgba(100, 150, 200, 0.5);
            border-color: var(--accent);
        }

        .filter-btn:hover {
            border-color: var(--accent);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .message-status {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            border-radius: 12px;
            font-size: 0.8rem;
        }

        .status-unread {
            background: rgba(255, 200, 0, 0.2);
            color: #FFD700;
        }

        .status-read {
            background: rgba(100, 200, 100, 0.2);
            color: #90EE90;
        }

        @media (max-width: 768px) {
            .messages-container {
                padding: 0 1rem;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.8rem;
            }

            .message-card {
                padding: 1rem;
            }

            .message-header {
                flex-direction: column;
                gap: 0.8rem;
            }

            .message-date {
                text-align: left;
            }

            .message-actions {
                justify-content: flex-start;
            }

            .message-actions .btn-sm {
                width: 100%;
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

    <div class="messages-container">
        <div class="page-header">
            <h1 class="section-title">Messages</h1>
        </div>

        <div class="filter-bar">
            <button class="filter-btn active" onclick="filterMessages('all')">All Messages</button>
            <button class="filter-btn" onclick="filterMessages('unread')">Unread</button>
            <button class="filter-btn" onclick="filterMessages('read')">Read</button>
        </div>

        <div id="messagesContainer">
        <%
            Connection connection = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            boolean hasMessages = false;
            try {
                connection = DatabaseConnection.getConnection();
                String query = "SELECT * FROM messages ORDER BY created_at DESC";
                pstmt = connection.prepareStatement(query);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    hasMessages = true;
                    String messageId = String.valueOf(rs.getInt("message_id"));
                    String readStatus = rs.getBoolean("is_read") ? "read" : "unread";
        %>
            <div class="message-card <%=readStatus%>" data-status="<%=readStatus%>">
                <div class="message-header">
                    <div class="message-from">
                        <div class="message-name"><%=rs.getString("name")%></div>
                        <div class="message-email"><%=rs.getString("email")%></div>
                        <div class="message-subject"><%=rs.getString("subject") != null ? rs.getString("subject") : "No subject"%></div>
                        <span class="message-status <%=readStatus.equals("unread") ? "status-unread" : "status-read"%>">
                            <%=readStatus.equals("unread") ? "Unread" : "Read"%>
                        </span>
                    </div>
                    <div class="message-date"><%=rs.getString("created_at").substring(0, 10)%></div>
                </div>
                <div class="message-body"><%=rs.getString("message")%></div>
                <div class="message-actions">
                    <a href="mailto:<%=rs.getString("email")%>" class="btn-sm btn-reply">Reply via Email</a>
                </div>
            </div>
        <%
                }

                if (!hasMessages) {
        %>
            </div>
            <div class="empty-state">
                <p>No messages yet.</p>
                <p style="font-size: 0.9rem; margin-top: 0.5rem;">Contact messages from your portfolio website will appear here.</p>
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

    <script>
        function filterMessages(status) {
            const cards = document.querySelectorAll('.message-card');
            const buttons = document.querySelectorAll('.filter-btn');

            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');

            cards.forEach(card => {
                if (status === 'all') {
                    card.style.display = 'block';
                } else if (status === card.getAttribute('data-status')) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    </script>

    <script src="../js/main.js"></script>
</body>
</html>
