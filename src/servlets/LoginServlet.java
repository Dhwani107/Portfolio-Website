package servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import db.DatabaseConnection;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import org.apache.commons.codec.binary.Hex;

/**
 * LoginServlet - Handles user login and session management
 */
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Input validation
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Hash password
        String hashedPassword = hashPassword(password);
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            
            // Query user from database
            String query = "SELECT user_id, first_name, last_name, email FROM users WHERE username = ? AND password = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, hashedPassword);
            
            resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                // User authenticated successfully
                HttpSession session = request.getSession();
                session.setAttribute("userId", resultSet.getInt("user_id"));
                session.setAttribute("username", username);
                session.setAttribute("firstName", resultSet.getString("first_name"));
                session.setAttribute("lastName", resultSet.getString("last_name"));
                session.setAttribute("email", resultSet.getString("email"));
                session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout
                
                // Redirect to dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                // Invalid credentials
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            request.setAttribute("error", "Database error during login");
            try {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, resultSet);
        }
    }
    
    /**
     * Hash password using SHA-256
     */
    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(password.getBytes());
            return Hex.encodeHexString(encodedHash);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return password;
        }
    }
}
