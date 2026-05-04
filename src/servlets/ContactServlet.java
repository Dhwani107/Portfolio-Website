package servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import db.DatabaseConnection;

/**
 * ContactServlet - Handles contact form submissions
 */
public class ContactServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        
        // Server-side validation (client-side also done in JS)
        if (name == null || name.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Name is required\"}");
            return;
        }
        
        if (email == null || email.trim().isEmpty() || !isValidEmail(email)) {
            out.print("{\"success\": false, \"message\": \"Valid email is required\"}");
            return;
        }
        
        if (message == null || message.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Message is required\"}");
            return;
        }
        
        // Sanitize inputs to prevent XSS attacks
        name = sanitizeInput(name);
        email = sanitizeInput(email);
        subject = sanitizeInput(subject != null ? subject : "No subject");
        message = sanitizeInput(message);
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "INSERT INTO messages (name, email, subject, message) VALUES (?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(query);
            
            preparedStatement.setString(1, name);
            preparedStatement.setString(2, email);
            preparedStatement.setString(3, subject);
            preparedStatement.setString(4, message);
            
            int result = preparedStatement.executeUpdate();
            
            if (result > 0) {
                out.print("{\"success\": true, \"message\": \"Message sent successfully! I will get back to you soon.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to send message. Please try again.\"}");
            }
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            out.print("{\"success\": false, \"message\": \"Database error occurred\"}");
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, null);
        }
    }
    
    /**
     * Validate email format
     */
    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        return email.matches(emailRegex);
    }
    
    /**
     * Sanitize input to prevent XSS attacks
     */
    private String sanitizeInput(String input) {
        return input.replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;")
                   .replace("/", "&#x2F;");
    }
}
