package db;

import java.sql.*;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

/**
 * Database Connection Class
 * Handles JDBC connectivity with connection pooling and configuration management
 */
public class DatabaseConnection {
    
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static String URL;
    private static String USER;
    private static String PASSWORD;
    
    static {
        try {
            // Load configuration from properties file
            loadConfiguration();
            // Register JDBC Driver
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Load database configuration from properties file
     */
    private static void loadConfiguration() {
        String envUrl = System.getenv("DB_URL");
        String envHost = System.getenv("DB_HOST");
        String envPort = System.getenv("DB_PORT");
        String envName = System.getenv("DB_NAME");
        String envUser = System.getenv("DB_USER");
        String envPassword = System.getenv("DB_PASSWORD");

        if (envUrl != null && !envUrl.trim().isEmpty()) {
            URL = envUrl;
            USER = (envUser != null && !envUser.trim().isEmpty()) ? envUser : "root";
            PASSWORD = (envPassword != null) ? envPassword : "";
            return;
        }

        if (envHost != null && !envHost.trim().isEmpty()) {
            String port = (envPort != null && !envPort.trim().isEmpty()) ? envPort : "3306";
            String dbName = (envName != null && !envName.trim().isEmpty()) ? envName : "portfolio_db";
            URL = "jdbc:mysql://" + envHost + ":" + port + "/" + dbName + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            USER = (envUser != null && !envUser.trim().isEmpty()) ? envUser : "root";
            PASSWORD = (envPassword != null) ? envPassword : "";
            return;
        }

        try {
            Properties props = new Properties();
            String configPath = "src/db/db.properties";
            FileInputStream input = new FileInputStream(configPath);
            props.load(input);
            
            URL = props.getProperty("db.url", "jdbc:mysql://localhost:3306/portfolio_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
            USER = props.getProperty("db.user", "root");
            PASSWORD = props.getProperty("db.password", "");
            
            input.close();
        } catch (IOException e) {
            // Use default values if properties file not found
            URL = "jdbc:mysql://localhost:3306/portfolio_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            USER = "root";
            PASSWORD = "";
            System.out.println("Using default database configuration");
        }
    }
    
    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database connection established successfully");
            return connection;
        } catch (SQLException e) {
            System.err.println("Failed to establish database connection: " + e.getMessage());
            throw new SQLException("Database connection error: " + e.getMessage());
        }
    }
    
    /**
     * Close database connection
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed");
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }
    
    /**
     * Close ResultSet
     * @param resultSet ResultSet to close
     */
    public static void closeResultSet(ResultSet resultSet) {
        if (resultSet != null) {
            try {
                resultSet.close();
            } catch (SQLException e) {
                System.err.println("Error closing result set: " + e.getMessage());
            }
        }
    }
    
    /**
     * Close Statement
     * @param statement Statement to close
     */
    public static void closeStatement(Statement statement) {
        if (statement != null) {
            try {
                statement.close();
            } catch (SQLException e) {
                System.err.println("Error closing statement: " + e.getMessage());
            }
        }
    }
    
    /**
     * Close multiple database resources
     * @param connection Connection to close
     * @param statement Statement to close
     * @param resultSet ResultSet to close
     */
    public static void closeResources(Connection connection, Statement statement, ResultSet resultSet) {
        closeResultSet(resultSet);
        closeStatement(statement);
        closeConnection(connection);
    }
    
    /**
     * Test database connection
     * @return true if connection successful, false otherwise
     */
    public static boolean testConnection() {
        Connection connection = null;
        try {
            connection = getConnection();
            if (connection != null) {
                System.out.println("Database connection test successful");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
        } finally {
            closeConnection(connection);
        }
        return false;
    }
}
