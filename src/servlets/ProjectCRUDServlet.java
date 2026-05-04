package servlets;

import java.io.*;
import java.sql.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import db.DatabaseConnection;

/**
 * ProjectCRUDServlet - Handles Project CRUD operations
 */
public class ProjectCRUDServlet extends HttpServlet {
    
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
            listProjects(request, response, session);
        } else if (action.equals("edit")) {
            editProject(request, response, session);
        } else if (action.equals("delete")) {
            deleteProject(request, response, session);
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
            addProject(request, response, session);
        } else if (action.equals("update")) {
            updateProject(request, response, session);
        } else if (action.equals("delete")) {
            deleteProject(request, response, session);
        }
    }
    
    private void listProjects(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int userId = (Integer) session.getAttribute("userId");
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "SELECT * FROM projects WHERE user_id = ? ORDER BY created_at DESC";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, userId);
            resultSet = preparedStatement.executeQuery();
            
            request.getRequestDispatcher("/jsp/manageProjects.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching projects");
            request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, resultSet);
        }
    }
    
    private void addProject(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int userId = (Integer) session.getAttribute("userId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String technologies = request.getParameter("technologies");
        String projectUrl = request.getParameter("projectUrl");
        String githubUrl = request.getParameter("githubUrl");
        String imageUrl = request.getParameter("imageUrl");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        boolean featured = request.getParameter("featured") != null;
        
        // Input validation
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Project title is required");
            request.getRequestDispatcher("/jsp/addProject.jsp").forward(request, response);
            return;
        }
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "INSERT INTO projects (user_id, title, description, technologies, project_url, github_url, image_url, start_date, end_date, featured) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(query);
            
            preparedStatement.setInt(1, userId);
            preparedStatement.setString(2, title);
            preparedStatement.setString(3, description);
            preparedStatement.setString(4, technologies);
            preparedStatement.setString(5, projectUrl);
            preparedStatement.setString(6, githubUrl);
            preparedStatement.setString(7, imageUrl);

            if (startDate == null || startDate.trim().isEmpty()) {
                preparedStatement.setNull(8, Types.DATE);
            } else {
                preparedStatement.setDate(8, Date.valueOf(startDate));
            }

            if (endDate == null || endDate.trim().isEmpty()) {
                preparedStatement.setNull(9, Types.DATE);
            } else {
                preparedStatement.setDate(9, Date.valueOf(endDate));
            }

            preparedStatement.setBoolean(10, featured);
            
            int result = preparedStatement.executeUpdate();
            
            if (result > 0) {
                appendProjectToSqlSeed(request, userId, title, description, technologies, projectUrl, githubUrl, imageUrl, startDate, endDate, featured);
                session.setAttribute("successMessage", "Project added successfully.");
                response.sendRedirect(request.getContextPath() + "/projectsCRUD?action=list");
            } else {
                request.setAttribute("error", "Failed to add project");
                request.getRequestDispatcher("/jsp/addProject.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            try {
                request.getRequestDispatcher("/jsp/addProject.jsp").forward(request, response);
            } catch (ServletException se) {
                se.printStackTrace();
            }
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, null);
        }
    }

    private void appendProjectToSqlSeed(HttpServletRequest request, int userId, String title, String description,
            String technologies, String projectUrl, String githubUrl, String imageUrl, String startDate,
            String endDate, boolean featured) {
        try {
            Path sqlFile = findPortfolioSqlPath(request);
            if (sqlFile == null) {
                return;
            }

            String insertStatement = "\n-- Auto-appended from dashboard add project\n"
                    + "INSERT INTO projects (user_id, title, description, technologies, project_url, github_url, image_url, start_date, end_date, featured) VALUES ("
                    + userId + ", "
                    + toSqlString(title) + ", "
                    + toSqlString(description) + ", "
                    + toSqlString(technologies) + ", "
                    + toSqlString(projectUrl) + ", "
                    + toSqlString(githubUrl) + ", "
                    + toSqlString(imageUrl) + ", "
                    + toSqlDate(startDate) + ", "
                    + toSqlDate(endDate) + ", "
                    + (featured ? "TRUE" : "FALSE")
                    + ");\n";

            Files.writeString(sqlFile, insertStatement, StandardCharsets.UTF_8, StandardOpenOption.APPEND);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Path findPortfolioSqlPath(HttpServletRequest request) {
        List<Path> candidates = new ArrayList<Path>();

        String configuredPath = System.getenv("PORTFOLIO_SQL_PATH");
        if (configuredPath != null && !configuredPath.trim().isEmpty()) {
            candidates.add(Paths.get(configuredPath.trim()));
        }

        String realPath = getServletContext().getRealPath("/");
        if (realPath != null && !realPath.trim().isEmpty()) {
            Path webRoot = Paths.get(realPath).normalize();
            Path current = webRoot;
            for (int i = 0; i < 8 && current != null; i++) {
                candidates.add(current.resolve("database/portfolio_db.sql").normalize());
                current = current.getParent();
            }
        }

        Path workingDir = Paths.get(System.getProperty("user.dir", "")).normalize();
        if (workingDir != null) {
            Path current = workingDir;
            for (int i = 0; i < 8 && current != null; i++) {
                candidates.add(current.resolve("database/portfolio_db.sql").normalize());
                current = current.getParent();
            }
        }

        for (Path candidate : candidates) {
            if (candidate != null && Files.exists(candidate) && Files.isRegularFile(candidate)) {
                return candidate;
            }
        }

        return null;
    }

    private String toSqlString(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "NULL";
        }

        String escaped = value.trim().replace("'", "''");
        return "'" + escaped + "'";
    }

    private String toSqlDate(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "NULL";
        }

        return toSqlString(value.trim());
    }
    
    private void editProject(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int projectId = Integer.parseInt(request.getParameter("id"));
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "SELECT * FROM projects WHERE project_id = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, projectId);
            resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                request.getRequestDispatcher("/jsp/editProject.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, resultSet);
        }
    }
    
    private void updateProject(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int userId = (Integer) session.getAttribute("userId");
        int projectId = Integer.parseInt(request.getParameter("projectId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String technologies = request.getParameter("technologies");
        String projectUrl = request.getParameter("projectUrl");
        String githubUrl = request.getParameter("githubUrl");
        String imageUrl = request.getParameter("imageUrl");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        boolean featured = request.getParameter("featured") != null;
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "UPDATE projects SET title=?, description=?, technologies=?, project_url=?, github_url=?, image_url=?, start_date=?, end_date=?, featured=? WHERE project_id=? AND user_id=?";
            preparedStatement = connection.prepareStatement(query);
            
            preparedStatement.setString(1, title);
            preparedStatement.setString(2, description);
            preparedStatement.setString(3, technologies);
            preparedStatement.setString(4, projectUrl);
            preparedStatement.setString(5, githubUrl);
            preparedStatement.setString(6, imageUrl);

            if (startDate == null || startDate.trim().isEmpty()) {
                preparedStatement.setNull(7, Types.DATE);
            } else {
                preparedStatement.setDate(7, Date.valueOf(startDate));
            }

            if (endDate == null || endDate.trim().isEmpty()) {
                preparedStatement.setNull(8, Types.DATE);
            } else {
                preparedStatement.setDate(8, Date.valueOf(endDate));
            }

            preparedStatement.setBoolean(9, featured);
            preparedStatement.setInt(10, projectId);
            preparedStatement.setInt(11, userId);
            
            int result = preparedStatement.executeUpdate();
            
            if (result > 0) {
                appendProjectUpdateToSqlSeed(request, userId, projectId, title, description, technologies, projectUrl, githubUrl, imageUrl, startDate, endDate, featured);
                response.sendRedirect(request.getContextPath() + "/projectsCRUD?action=list");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, null);
        }
    }
    
    private void deleteProject(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        int userId = (Integer) session.getAttribute("userId");
        String projectIdParam = request.getParameter("id");
        if (projectIdParam == null || projectIdParam.trim().isEmpty()) {
            projectIdParam = request.getParameter("projectId");
        }

        if (projectIdParam == null || projectIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        int projectId;
        try {
            projectId = Integer.parseInt(projectIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DatabaseConnection.getConnection();
            String query = "DELETE FROM projects WHERE project_id = ? AND user_id = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, projectId);
            preparedStatement.setInt(2, userId);
            
            int deletedRows = preparedStatement.executeUpdate();
            if (deletedRows > 0) {
                appendProjectDeleteToSqlSeed(request, userId, projectId);
                session.setAttribute("dashboardSuccessMessage", "Project deleted successfully.");
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/projectsCRUD?action=list");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/projectsCRUD?action=list");
        } finally {
            DatabaseConnection.closeResources(connection, preparedStatement, null);
        }
    }

    private void appendProjectUpdateToSqlSeed(HttpServletRequest request, int userId, int projectId, String title,
            String description, String technologies, String projectUrl, String githubUrl, String imageUrl,
            String startDate, String endDate, boolean featured) {
        try {
            Path sqlFile = findPortfolioSqlPath(request);
            if (sqlFile == null) {
                return;
            }

            String updateStatement = "\n-- Auto-appended from dashboard update project\n"
                    + "UPDATE projects SET "
                    + "title = " + toSqlString(title) + ", "
                    + "description = " + toSqlString(description) + ", "
                    + "technologies = " + toSqlString(technologies) + ", "
                    + "project_url = " + toSqlString(projectUrl) + ", "
                    + "github_url = " + toSqlString(githubUrl) + ", "
                    + "image_url = " + toSqlString(imageUrl) + ", "
                    + "start_date = " + toSqlDate(startDate) + ", "
                    + "end_date = " + toSqlDate(endDate) + ", "
                    + "featured = " + (featured ? "TRUE" : "FALSE")
                    + " WHERE project_id = " + projectId + " AND user_id = " + userId + ";\n";

            Files.writeString(sqlFile, updateStatement, StandardCharsets.UTF_8, StandardOpenOption.APPEND);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void appendProjectDeleteToSqlSeed(HttpServletRequest request, int userId, int projectId) {
        try {
            Path sqlFile = findPortfolioSqlPath(request);
            if (sqlFile == null) {
                return;
            }

            String deleteStatement = "\n-- Auto-appended from dashboard delete project\n"
                    + "DELETE FROM projects WHERE project_id = " + projectId + " AND user_id = " + userId + ";\n";

            Files.writeString(sqlFile, deleteStatement, StandardCharsets.UTF_8, StandardOpenOption.APPEND);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
