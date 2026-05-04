<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Dhwani's Portfolio</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .auth-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: -60px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        .auth-container::before,
        .auth-container::after {
            content: '';
            position: absolute;
            width: 320px;
            height: 320px;
            border-radius: 50%;
            filter: blur(40px);
            pointer-events: none;
        }

        .auth-container::before {
            top: 8%;
            left: 10%;
            background: rgba(255, 255, 255, 0.08);
        }

        .auth-container::after {
            right: 8%;
            bottom: 4%;
            background: rgba(190, 190, 190, 0.12);
        }

        .auth-box {
            background: linear-gradient(135deg, rgba(45, 45, 45, 0.9) 0%, rgba(40, 40, 40, 0.9) 100%);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 3rem;
            max-width: 440px;
            width: 100%;
            animation: slideInUp 0.6s ease-out;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.45);
            position: relative;
            z-index: 2;
            backdrop-filter: blur(10px);
        }

        .auth-box::before {
            content: '';
            position: absolute;
            top: -1px;
            left: 20px;
            right: 20px;
            height: 3px;
            border-radius: 999px;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.95), transparent);
        }

        .auth-chip {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.3rem 0.8rem;
            margin: 0 auto 1rem;
            border-radius: 999px;
            border: 1px solid var(--border);
            background: rgba(255,255,255,0.05);
            color: var(--text-light);
            font-size: 0.78rem;
            letter-spacing: 0.4px;
        }

        .auth-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-align: center;
            background: linear-gradient(135deg, #ffffff, #a0a0a0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .auth-subtitle {
            text-align: center;
            color: var(--secondary-grey);
            margin-bottom: 2rem;
            font-size: 0.95rem;
        }

        .auth-head {
            text-align: center;
            margin-bottom: 1rem;
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

        .form-group input {
            width: 100%;
            padding: 0.85rem 0.95rem;
            background: rgba(60, 60, 60, 0.5);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text-light);
            font-family: inherit;
            transition: var(--transition);
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--accent);
            background: rgba(80, 80, 80, 0.8);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.08);
        }

        .form-group input.error {
            border-color: #ff6b6b;
            background: rgba(200, 100, 100, 0.2);
        }

        .field-error {
            color: #ff6b6b;
            font-size: 0.85rem;
            margin-top: 0.3rem;
        }

        .submit-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, #ffffff, #d0d0d0);
            color: var(--button-primary-text, #111111);
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }

        .light-theme .submit-btn {
            background: linear-gradient(135deg, #141414, #2b2b2b);
            color: #ffffff;
        }

        .submit-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255, 255, 255, 0.3);
        }

        .submit-btn:active {
            transform: translateY(-1px);
        }

        .auth-link {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--secondary-grey);
        }

        .auth-link a {
            color: var(--accent);
            text-decoration: none;
            transition: var(--transition);
        }

        .auth-link a:hover {
            text-decoration: underline;
        }

        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }

        .error-message {
            background: rgba(200, 100, 100, 0.2);
            border: 1px solid rgba(200, 100, 100, 0.5);
            color: #ff6b6b;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1rem;
            animation: slideInDown 0.5s ease-out;
        }

        .success-message {
            background: rgba(100, 200, 100, 0.2);
            border: 1px solid rgba(100, 200, 100, 0.5);
            color: #90EE90;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1rem;
            animation: slideInDown 0.5s ease-out;
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

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .demo-info {
            background: rgba(100, 150, 200, 0.2);
            border: 1px solid rgba(100, 150, 200, 0.5);
            color: var(--text-light);
            padding: 1rem;
            border-radius: 10px;
            margin-top: 1.5rem;
            font-size: 0.85rem;
        }

        .auth-meta {
            display: flex;
            gap: 0.6rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
        }

        .meta-pill {
            font-size: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 999px;
            padding: 0.3rem 0.7rem;
            color: var(--secondary-grey);
            background: rgba(255,255,255,0.03);
        }

        @media (max-width: 768px) {
            .auth-container {
                margin-top: 0;
                padding: 1.2rem;
            }

            .auth-box {
                padding: 1.6rem 1.2rem;
                border-radius: 12px;
            }

            .auth-title {
                font-size: 1.65rem;
            }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-box">
            <div class="auth-head">
                <div class="auth-chip">Secure Access</div>
                <h1 class="auth-title">Login</h1>
                <p class="auth-subtitle">Access your admin panel</p>
            </div>

            <div class="auth-meta">
                <span class="meta-pill">Portfolio Admin</span>
                <span class="meta-pill">Protected Session</span>
            </div>

            <% 
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                if (error != null) {
            %>
                <div class="error-message"><%=error%></div>
            <% } %>
            <% if (success != null) { %>
                <div class="success-message"><%=success%></div>
            <% } %>

            <form method="POST" action="<%=request.getContextPath()%>/login">
                <div class="form-group">
                    <label for="username">Username *</label>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required>
                </div>

                <div class="form-group">
                    <label for="password">Password *</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>

                <div class="remember-forgot">
                    <label style="color: var(--secondary-grey);">
                        <input type="checkbox" name="remember" style="margin-right: 0.5rem;">
                        Remember me
                    </label>
                </div>

                <button type="submit" class="submit-btn">Login</button>

                <div class="auth-link">
                    Don't have an account? <a href="<%=request.getContextPath()%>/register.jsp">Register here</a>
                </div>

                <div class="demo-info">
                    <strong>Demo Account:</strong><br>
                    Username: dhwani_chauhan<br>
                    Password: demo@123456<br>
                    <em>(For testing purposes)</em>
                </div>
            </form>
        </div>
    </div>

    <script src="<%=request.getContextPath()%>/js/main.js"></script>
</body>
</html>
