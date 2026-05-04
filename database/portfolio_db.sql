-- Portfolio Database Schema
-- Database: portfolio_db
-- Author: Dhwani Chauhan
-- Date: 2026

CREATE DATABASE IF NOT EXISTS portfolio_db;
USE portfolio_db;

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: about
CREATE TABLE IF NOT EXISTS about (
    about_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    headline VARCHAR(200),
    summary TEXT,
    profile_image VARCHAR(255),
    background_image VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    linkedin_url VARCHAR(255),
    github_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: skills
CREATE TABLE IF NOT EXISTS skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category VARCHAR(100),
    skill_name VARCHAR(100) NOT NULL,
    proficiency_level VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: projects
CREATE TABLE IF NOT EXISTS projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    technologies VARCHAR(500),
    project_url VARCHAR(255),
    github_url VARCHAR(255),
    image_url VARCHAR(255),
    start_date DATE,
    end_date DATE,
    featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: education
CREATE TABLE IF NOT EXISTS education (
    education_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    institution_name VARCHAR(200) NOT NULL,
    degree VARCHAR(100),
    field_of_study VARCHAR(100),
    start_date DATE,
    end_date DATE,
    gpa DECIMAL(3,2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: messages
CREATE TABLE IF NOT EXISTS messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200),
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample Data

-- Insert user (Admin - Dhwani Chauhan)
-- Password: demo@123456 (SHA-256 hashed)
INSERT INTO users (username, email, password, first_name, last_name) 
VALUES ('dhwani_chauhan', 'dhwanichauhan1072004@gmail.com', '2cca11490c8be9107c64b0c213ed5dc37d91ff8e3a0b42bb0780a91cba5cb210', 'Dhwani', 'Chauhan');

-- Get user_id for the next inserts
-- Note: In MySQL, the inserted user_id will be 1

-- Insert about information
INSERT INTO about (user_id, headline, summary, phone, email, linkedin_url, github_url) 
VALUES (1, 
    'Aspiring AI/ML Engineer & Data Scientist',
    'Aspiring AI/ML Engineer and Data Scientist with hands-on experience in Python, NumPy, Pandas, and Scikit-learn for data analysis and machine learning. Skilled in data preprocessing, exploratory data analysis, visualization, and predictive modeling. Familiar with Power BI, basic knowledge of C++ and Data Structures. Currently diving into Generative AI, LLMs, RAG and Agentic AI systems to build AI-powered intelligent applications. Passionate about building data-driven and AI-powered solutions.',
    '+91 9674315871',
    'dhwanichauhan1072004@gmail.com',
    'https://www.linkedin.com/in/dhwani-chauhan-aaa5ab280/',
    'https://github.com/Dhwani107'
);

-- Insert skills
INSERT INTO skills (user_id, category, skill_name, proficiency_level) VALUES
(1, 'Programming', 'Python', 'Advanced'),
(1, 'Programming', 'C++', 'Intermediate'),
(1, 'Programming', 'JavaScript', 'Intermediate'),
(1, 'Programming', 'Java', 'Intermediate'),
(1, 'Data Science', 'NumPy', 'Advanced'),
(1, 'Data Science', 'Pandas', 'Advanced'),
(1, 'Data Science', 'Scikit-learn', 'Advanced'),
(1, 'Data Science', 'Natural Language Processing', 'Intermediate'),
(1, 'Data Science', 'Feature Engineering', 'Advanced'),
(1, 'Data Science', 'Model Training and Testing', 'Advanced'),
(1, 'Database', 'MySQL', 'Advanced'),
(1, 'Database', 'MongoDB', 'Intermediate'),
(1, 'Visualization', 'Power BI', 'Advanced'),
(1, 'Visualization', 'Tableau', 'Intermediate'),
(1, 'Visualization', 'Streamlit', 'Intermediate'),
(1, 'Visualization', 'Excel', 'Advanced'),
(1, 'Visualization', 'PowerPoint', 'Advanced'),
(1, 'Visualization', 'Word', 'Advanced'),
(1, 'Web Framework', 'Flask', 'Intermediate'),
(1, 'Web Framework', 'Django', 'Intermediate'),
(1, 'Tools', 'Git/Github', 'Advanced'),
(1, 'Tools', 'Jupyter Notebook', 'Advanced'),
(1, 'Tools', 'Visual Studio Code', 'Advanced'),
(1, 'Design', 'Canva', 'Intermediate'),
(1, 'Design', 'Figma', 'Intermediate'),
(1, 'Soft Skills', 'Leadership', 'Advanced'),
(1, 'Soft Skills', 'Teamwork', 'Advanced'),
(1, 'Soft Skills', 'Content Writing', 'Advanced'),
(1, 'Soft Skills', 'Good Communication', 'Advanced');

-- Insert education
INSERT INTO education (user_id, institution_name, degree, field_of_study, start_date, end_date, gpa, description) VALUES
(1, 'Techno India University, Kolkata', 'B.Tech', 'Computer Science and Engineering', '2023-07-01', '2027-08-30', 8.57, 'Graduating in 2027'),
(1, 'H.M. Education Centre, Kolkata', 'Higher Secondary', 'Science Stream', '2021-07-01', '2023-05-31', NULL, 'Higher Secondary - 74.2% (Completed in 2023)'),
(1, 'H.M. Education Centre, Kolkata', 'Secondary', 'General', '2019-07-01', '2021-05-31', NULL, 'Secondary - 95.6% (Completed in 2021)');

-- Insert projects
DELETE FROM projects WHERE user_id = 1;

INSERT INTO projects (user_id, title, description, technologies, github_url, featured, start_date) VALUES
(1, 'Password Generator', 'A simple and user-friendly password generator with customizable length, character options, and instant copy-to-clipboard support.', 'HTML, CSS, JavaScript, Responsive Design', 'https://github.com/Dhwani107/Password-Generator', TRUE, '2025-06-01'),
(1, 'Hire Junc', 'A gig platform with escrow payments, support for technical and non-technical gigs, real-time in-built messaging with file sharing, and chatbot integration.', 'JavaScript, Real-time Chat, File Sharing, Escrow Workflow', 'https://github.com/Dhwani107/hire-junc-main', TRUE, '2025-07-01'),
(1, 'Resume Advisor', 'Resume Advisor provides personalized feedback on resume weaknesses, skill improvements, and keyword optimization to improve job-market success.', 'Resume Analysis, AI Insights, Skill Optimization, Keywords', 'https://github.com/Dhwani107/Resume-Advisor-APP', TRUE, '2025-05-01');

-- Sample message
INSERT INTO messages (name, email, subject, message, is_read) VALUES
('Test User', 'test@example.com', 'Portfolio Enquiry', 'Great portfolio! Would love to discuss collaboration opportunities.', FALSE);

-- Create indexes for better query performance
CREATE INDEX idx_user_id ON about(user_id);
CREATE INDEX idx_user_id ON skills(user_id);
CREATE INDEX idx_user_id ON projects(user_id);
CREATE INDEX idx_user_id ON education(user_id);
CREATE INDEX idx_email ON messages(email);
CREATE INDEX idx_created_at ON messages(created_at);

-- Display summary
SELECT 'Database setup completed successfully!' as message;
SELECT 'Created tables: users, about, skills, projects, education, messages' as tables;
