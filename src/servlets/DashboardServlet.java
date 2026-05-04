package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * DashboardServlet - Handles dashboard access and authentication
 */
public class DashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        Integer userId = null;
        
        if (session != null) {
            userId = (Integer) session.getAttribute("userId");
        }
        
        if (userId == null) {
            // User not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            // User is authenticated, forward to dashboard JSP
            request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
        }
    }
}
