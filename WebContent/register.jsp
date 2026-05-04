<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Dhwani's Portfolio</title>
    <link rel="stylesheet" href="css/style.css">
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
            filter: blur(42px);
            pointer-events: none;
        }

        .auth-container::before {
            top: 6%;
            left: 8%;
            background: rgba(255, 255, 255, 0.07);
        }

        .auth-container::after {
            bottom: 5%;
            right: 8%;
            background: rgba(185, 185, 185, 0.12);
        }

        .auth-box {
            background: linear-gradient(135deg, rgba(45, 45, 45, 0.9) 0%, rgba(40, 40, 40, 0.9) 100%);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 3rem;
            max-width: 460px;
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
            animation: slideInDown 0.3s ease-out;
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

        .password-requirements {
            background: rgba(100, 100, 100, 0.2);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
            font-size: 0.85rem;
            color: var(--secondary-grey);
        }

        .password-requirements li {
            margin-bottom: 0.3rem;
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
                <div class="auth-chip">Create Account</div>
                <h1 class="auth-title">Register</h1>
                <p class="auth-subtitle">Join my admin panel</p>
            </div>

            <div class="auth-meta">
                <span class="meta-pill">Secure Signup</span>
                <span class="meta-pill">Portfolio Access</span>
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

            <form method="POST" action="register">
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" placeholder="Enter your first name">
                </div>

                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" placeholder="Enter your last name">
                </div>

                <div class="form-group">
                    <label for="username">Username *</label>
                    <input type="text" id="username" name="username" placeholder="Choose a username" required 
                        pattern="[a-zA-Z0-9_]{3,}" title="Username must be at least 3 characters (letters, numbers, underscore)">
                </div>

                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>

                <div class="form-group">
                    <label for="password">Password *</label>
                    <input type="password" id="password" name="password" placeholder="Create a password" required 
                        minlength="8" title="Password must be at least 8 characters">
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                </div>

                <div class="password-requirements">
                    <strong>Password Requirements:</strong>
                    <ul>
                        <li>✓ Minimum 8 characters</li>
                        <li>✓ Mix of letters, numbers recommended</li>
                        <li>✓ Use special characters for strength</li>
                    </ul>
                </div>

                <button type="submit" class="submit-btn">Register</button>

                <div class="auth-link">
                    Already have an account? <a href="login.jsp">Login here</a>
                </div>
            </form>
        </div>
    </div>

    <script src="js/main.js"></script>
</body>
</html>
