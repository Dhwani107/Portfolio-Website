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
 * RegisterServlet - Handles user registration
 */
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        
        // Input validation
        if (username == null || username.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Validate password strength (minimum 8 characters)
        if (password.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters long");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Hash password
        String hashedPassword = hashPassword(password);
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            
            // Check if username or email already exists
            String checkQuery = "SELECT user_id FROM users WHERE username = ? OR email = ?";
            preparedStatement = connection.prepareStatement(checkQuery);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, email);
            ResultSet resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                request.setAttribute("error", "Username or email already exists");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Insert new user
            String insertQuery = "INSERT INTO users (username, email, password, first_name, last_name) VALUES (?, ?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(insertQuery);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, email);
            preparedStatement.setString(3, hashedPassword);
            preparedStatement.setString(4, firstName != null ? firstName : "");
            preparedStatement.setString(5, lastName != null ? lastName : "");
            
            int result = preparedStatement.executeUpdate();
            
            if (result > 0) {
                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            request.setAttribute("error", "Database error during registration");
            try {
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, null);
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
            return password; // Fallback - should not reach here
        }
    }
}
