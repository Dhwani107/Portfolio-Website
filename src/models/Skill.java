package models;

/**
 * Skill Model Class
 */
public class Skill {
    private int skillId;
    private int userId;
    private String category;
    private String skillName;
    private String proficiencyLevel;
    private String createdAt;
    private String updatedAt;
    
    public Skill() {}
    
    public Skill(int userId, String category, String skillName, String proficiencyLevel) {
        this.userId = userId;
        this.category = category;
        this.skillName = skillName;
        this.proficiencyLevel = proficiencyLevel;
    }
    
    public int getSkillId() { return skillId; }
    public void setSkillId(int skillId) { this.skillId = skillId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getSkillName() { return skillName; }
    public void setSkillName(String skillName) { this.skillName = skillName; }
    
    public String getProficiencyLevel() { return proficiencyLevel; }
    public void setProficiencyLevel(String proficiencyLevel) { this.proficiencyLevel = proficiencyLevel; }
    
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    public String getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; }
}

/**
 * Education Model Class
 */
class Education {
    private int educationId;
    private int userId;
    private String institutionName;
    private String degree;
    private String fieldOfStudy;
    private String startDate;
    private String endDate;
    private double gpa;
    private String description;
    private String createdAt;
    private String updatedAt;
    
    public Education() {}
    
    public Education(int userId, String institutionName, String degree, String fieldOfStudy) {
        this.userId = userId;
        this.institutionName = institutionName;
        this.degree = degree;
        this.fieldOfStudy = fieldOfStudy;
    }
    
    public int getEducationId() { return educationId; }
    public void setEducationId(int educationId) { this.educationId = educationId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getInstitutionName() { return institutionName; }
    public void setInstitutionName(String institutionName) { this.institutionName = institutionName; }
    
    public String getDegree() { return degree; }
    public void setDegree(String degree) { this.degree = degree; }
    
    public String getFieldOfStudy() { return fieldOfStudy; }
    public void setFieldOfStudy(String fieldOfStudy) { this.fieldOfStudy = fieldOfStudy; }
    
    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
    
    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }
    
    public double getGpa() { return gpa; }
    public void setGpa(double gpa) { this.gpa = gpa; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    public String getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; }
}

/**
 * About Model Class
 */
class About {
    private int aboutId;
    private int userId;
    private String headline;
    private String summary;
    private String profileImage;
    private String backgroundImage;
    private String phone;
    private String email;
    private String linkedinUrl;
    private String githubUrl;
    private String createdAt;
    private String updatedAt;
    
    public About() {}
    
    public About(int userId, String headline, String summary) {
        this.userId = userId;
        this.headline = headline;
        this.summary = summary;
    }
    
    public int getAboutId() { return aboutId; }
    public void setAboutId(int aboutId) { this.aboutId = aboutId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getHeadline() { return headline; }
    public void setHeadline(String headline) { this.headline = headline; }
    
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    
    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }
    
    public String getBackgroundImage() { return backgroundImage; }
    public void setBackgroundImage(String backgroundImage) { this.backgroundImage = backgroundImage; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getLinkedinUrl() { return linkedinUrl; }
    public void setLinkedinUrl(String linkedinUrl) { this.linkedinUrl = linkedinUrl; }
    
    public String getGithubUrl() { return githubUrl; }
    public void setGithubUrl(String githubUrl) { this.githubUrl = githubUrl; }
    
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    public String getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; }
}

/**
 * Message Model Class
 */
class Message {
    private int messageId;
    private String name;
    private String email;
    private String subject;
    private String message;
    private boolean isRead;
    private String createdAt;
    
    public Message() {}
    
    public Message(String name, String email, String message) {
        this.name = name;
        this.email = email;
        this.message = message;
    }
    
    public int getMessageId() { return messageId; }
    public void setMessageId(int messageId) { this.messageId = messageId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public boolean isRead() { return isRead; }
    public void setIsRead(boolean isRead) { this.isRead = isRead; }
    
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
