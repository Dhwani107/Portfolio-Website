package servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import db.DatabaseConnection;

/**
 * SkillCRUDServlet - Handles Skill CRUD operations
 */
public class SkillCRUDServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.equals("list")) {
            listSkills(request, response, session);
        } else if (action.equals("edit")) {
            editSkill(request, response, session);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jsp/dashboard.jsp");
            return;
        }
        
        if (action.equals("add")) {
            addSkill(request, response, session);
        } else if (action.equals("update")) {
            updateSkill(request, response, session);
        } else if (action.equals("delete")) {
            deleteSkill(request, response, session);
        }
    }
    
    private void listSkills(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int userId = (Integer) session.getAttribute("userId");
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "SELECT * FROM skills WHERE user_id = ? ORDER BY category, skill_name";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, userId);
            resultSet = preparedStatement.executeQuery();
            
            request.getRequestDispatcher("/jsp/manageSkills.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching skills");
            request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, resultSet);
        }
    }
    
    private void addSkill(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int userId = (Integer) session.getAttribute("userId");
        String category = request.getParameter("category");
        String skillName = request.getParameter("skillName");
        String proficiencyLevel = request.getParameter("proficiencyLevel");
        
        // Input validation
        if (skillName == null || skillName.trim().isEmpty()) {
            request.setAttribute("error", "Skill name is required");
            request.getRequestDispatcher("/jsp/addSkill.jsp").forward(request, response);
            return;
        }
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "INSERT INTO skills (user_id, category, skill_name, proficiency_level) VALUES (?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(query);
            
            preparedStatement.setInt(1, userId);
            preparedStatement.setString(2, category != null ? category : "Other");
            preparedStatement.setString(3, skillName);
            preparedStatement.setString(4, proficiencyLevel != null ? proficiencyLevel : "Intermediate");
            
            int result = preparedStatement.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/skillsCRUD?action=list");
            } else {
                request.setAttribute("error", "Failed to add skill");
                request.getRequestDispatcher("/jsp/addSkill.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            try {
                request.getRequestDispatcher("/jsp/addSkill.jsp").forward(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, null);
        }
    }
    
    private void editSkill(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int skillId = Integer.parseInt(request.getParameter("id"));
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "SELECT * FROM skills WHERE skill_id = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, skillId);
            resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                request.getRequestDispatcher("/jsp/editSkill.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, resultSet);
        }
    }
    
    private void updateSkill(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int skillId = Integer.parseInt(request.getParameter("skillId"));
        String category = request.getParameter("category");
        String skillName = request.getParameter("skillName");
        String proficiencyLevel = request.getParameter("proficiencyLevel");
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "UPDATE skills SET category=?, skill_name=?, proficiency_level=? WHERE skill_id=?";
            preparedStatement = connection.prepareStatement(query);
            
            preparedStatement.setString(1, category);
            preparedStatement.setString(2, skillName);
            preparedStatement.setString(3, proficiencyLevel);
            preparedStatement.setInt(4, skillId);
            
            preparedStatement.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/skillsCRUD?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, null);
        }
    }
    
    private void deleteSkill(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int skillId = Integer.parseInt(request.getParameter("id"));
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "DELETE FROM skills WHERE skill_id = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, skillId);
            
            preparedStatement.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/skillsCRUD?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, null);
        }
    }
}
