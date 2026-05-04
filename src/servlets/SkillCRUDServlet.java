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

    private Integer parseIntParam(HttpServletRequest request, String... names) {
        if (names == null) {
            return null;
        }

        for (String name : names) {
            if (name == null || name.isEmpty()) {
                continue;
            }

            String value = request.getParameter(name);
            if (value == null) {
                continue;
            }

            value = value.trim();
            if (value.isEmpty()) {
                continue;
            }

            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                return null;
            }
        }

        return null;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.equals("list")) {
            listSkills(request, response, session);
        } else if (action.equals("edit")) {
            editSkill(request, response, session);
        } else if (action.equals("delete")) {
            // Allow delete via GET for consistency with other CRUD servlets.
            // The handler itself still validates session + parameters.
            deleteSkill(request, response, session);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
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
        // Keep the browser URL under /jsp so relative links inside JSPs keep working.
        response.sendRedirect(request.getContextPath() + "/jsp/manageSkills.jsp");
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
        ResultSet resultSet = null;
        
        try {
            connection = DatabaseConnection.getConnection();

            String normalizedCategory = (category != null && !category.trim().isEmpty()) ? category.trim() : "Other";
            String normalizedSkillName = skillName.trim();
            String normalizedProficiency = (proficiencyLevel != null && !proficiencyLevel.trim().isEmpty()) ? proficiencyLevel.trim() : "Intermediate";

            // Prevent duplicates for the same user (keeps UI clean and avoids confusion on delete).
            String duplicateQuery = "SELECT skill_id FROM skills WHERE user_id = ? AND category = ? AND skill_name = ? LIMIT 1";
            preparedStatement = connection.prepareStatement(duplicateQuery);
            preparedStatement.setInt(1, userId);
            preparedStatement.setString(2, normalizedCategory);
            preparedStatement.setString(3, normalizedSkillName);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                request.setAttribute("error", "Skill already exists in this category");
                request.getRequestDispatcher("/jsp/addSkill.jsp").forward(request, response);
                return;
            }

            DatabaseConnection.closeResources(null, preparedStatement, resultSet);
            preparedStatement = null;
            resultSet = null;

            String query = "INSERT INTO skills (user_id, category, skill_name, proficiency_level) VALUES (?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(query);
            
            preparedStatement.setInt(1, userId);
            preparedStatement.setString(2, normalizedCategory);
            preparedStatement.setString(3, normalizedSkillName);
            preparedStatement.setString(4, normalizedProficiency);
            
            int result = preparedStatement.executeUpdate();
            
            if (result > 0) {
                session.setAttribute("skillsSuccessMessage", "Skill added successfully.");
                response.sendRedirect(request.getContextPath() + "/jsp/manageSkills.jsp");
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
            DatabaseConnection.closeResources(connection, preparedStatement, resultSet);
        }
    }
    
    private void editSkill(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        Integer skillId = parseIntParam(request, "id", "skillId");
        if (skillId == null) {
            response.sendRedirect(request.getContextPath() + "/skillsCRUD?action=list");
            return;
        }
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
        int userId = (Integer) session.getAttribute("userId");
        Integer skillId = parseIntParam(request, "skillId", "id");
        if (skillId == null) {
            session.setAttribute("skillsErrorMessage", "Invalid skill id.");
            response.sendRedirect(request.getContextPath() + "/jsp/manageSkills.jsp");
            return;
        }
        String category = request.getParameter("category");
        String skillName = request.getParameter("skillName");
        String proficiencyLevel = request.getParameter("proficiencyLevel");
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "UPDATE skills SET category=?, skill_name=?, proficiency_level=? WHERE skill_id=? AND user_id=?";
            preparedStatement = connection.prepareStatement(query);
            
            preparedStatement.setString(1, category);
            preparedStatement.setString(2, skillName);
            preparedStatement.setString(3, proficiencyLevel);
            preparedStatement.setInt(4, skillId);
            preparedStatement.setInt(5, userId);
            
            int updated = preparedStatement.executeUpdate();
            if (updated > 0) {
                session.setAttribute("skillsSuccessMessage", "Skill updated successfully.");
            } else {
                session.setAttribute("skillsErrorMessage", "Skill not found or you don't have permission to update it.");
            }
            response.sendRedirect(request.getContextPath() + "/jsp/manageSkills.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("skillsErrorMessage", "Failed to update skill. Please try again.");
            response.sendRedirect(request.getContextPath() + "/jsp/manageSkills.jsp");
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, null);
        }
    }
    
    private void deleteSkill(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int userId = (Integer) session.getAttribute("userId");

        Integer skillId = parseIntParam(request, "id", "skillId");
        if (skillId == null) {
            session.setAttribute("skillsErrorMessage", "Invalid skill id.");
            response.sendRedirect(request.getContextPath() + "/jsp/manageSkills.jsp");
            return;
        }
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "DELETE FROM skills WHERE skill_id = ? AND user_id = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, skillId);
            preparedStatement.setInt(2, userId);

            int deleted = preparedStatement.executeUpdate();
            if (deleted > 0) {
                session.setAttribute("skillsSuccessMessage", "Skill deleted successfully.");
            } else {
                session.setAttribute("skillsErrorMessage", "Skill not found or already deleted.");
            }
            response.sendRedirect(request.getContextPath() + "/jsp/manageSkills.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("skillsErrorMessage", "Failed to delete skill. Please try again.");
            response.sendRedirect(request.getContextPath() + "/jsp/manageSkills.jsp");
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, null);
        }
    }
}
