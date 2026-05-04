/**
 * Main JavaScript File
 * Handles animations, interactions, and client-side validation
 */

document.addEventListener('DOMContentLoaded', function() {
    initializeAnimations();
    initializeFormValidation();
    initializeThemeToggle();
    initializeScrollAnimations();
    initializeProjectFiltering();
    initializeSkillLogos();
});

function initializeSkillLogos() {
    const skillTags = document.querySelectorAll('.skill-tag');
    if (!skillTags.length) {
        return;
    }

    skillTags.forEach((tag) => {
        if (tag.querySelector('.skill-logo')) {
            return;
        }

        const rawSkill = tag.textContent.trim();
        const logoInfo = getSkillLogoInfo(rawSkill);
        tag.textContent = '';

        if (logoInfo.url) {
            const logo = document.createElement('img');
            logo.className = 'skill-logo';
            logo.src = logoInfo.url;
            logo.alt = `${rawSkill} logo`;
            logo.loading = 'lazy';
            logo.referrerPolicy = 'no-referrer';
            logo.onerror = function () {
                this.remove();
                if (!tag.querySelector('.skill-logo-fallback')) {
                    const fallback = document.createElement('span');
                    fallback.className = 'skill-logo-fallback';
                    fallback.textContent = logoInfo.fallback;
                    tag.prepend(fallback);
                }
            };
            tag.appendChild(logo);
        }

        const textNode = document.createElement('span');
        textNode.className = 'skill-text';
        textNode.textContent = rawSkill;
        tag.appendChild(textNode);
    });
}

function getSkillLogoInfo(skill) {
    const value = skill.toLowerCase().trim();
    const normalized = value.replace(/[^a-z0-9]+/g, '');

    const exactLogos = {
        powerbi: { url: 'https://img.icons8.com/color/48/power-bi.png', fallback: 'BI' },
        tableau: { url: 'https://img.icons8.com/color/48/tableau-software.png', fallback: 'T' },
        excel: { url: 'https://img.icons8.com/color/48/microsoft-excel-2019--v1.png', fallback: 'X' },
        powerpoint: { url: 'https://img.icons8.com/color/48/microsoft-powerpoint-2019--v1.png', fallback: 'P' },
        word: { url: 'https://img.icons8.com/color/48/microsoft-word-2019--v1.png', fallback: 'W' },
        visualstudiocode: { url: 'https://img.icons8.com/color/48/visual-studio-code-2019.png', fallback: 'VS' },
        canva: { url: 'https://img.icons8.com/color/48/canva.png', fallback: 'C' }
    };

    if (exactLogos[normalized]) {
        return exactLogos[normalized];
    }

    const logoMap = [
        { match: ['python', 'numpy', 'pandas', 'scikit'], icon: 'python' },
        { match: ['c++', 'cpp'], icon: 'cplusplus' },
        { match: ['java'], icon: 'openjdk' },
        { match: ['javascript'], icon: 'javascript' },
        { match: ['mysql'], icon: 'mysql' },
        { match: ['mongodb'], icon: 'mongodb' },
        { match: ['power bi'], icon: 'powerbi' },
        { match: ['tableau'], icon: 'tableau' },
        { match: ['streamlit'], icon: 'streamlit' },
        { match: ['excel'], icon: 'microsoftexcel' },
        { match: ['powerpoint'], icon: 'microsoftpowerpoint' },
        { match: ['word'], icon: 'microsoftword' },
        { match: ['git/github', 'git', 'github'], icon: 'github' },
        { match: ['jupyter'], icon: 'jupyter' },
        { match: ['visual studio code', 'vscode'], icon: 'visualstudiocode' },
        { match: ['flask'], icon: 'flask' },
        { match: ['django'], icon: 'django' },
        { match: ['figma'], icon: 'figma' },
        { match: ['canva'], icon: 'canva' }
    ];

    const found = logoMap.find((entry) => entry.match.some((word) => value.includes(word)));
    if (found) {
        return {
            url: `https://cdn.simpleicons.org/${found.icon}`,
            fallback: found.icon.substring(0, 2).toUpperCase()
        };
    }

    return { url: '', fallback: '•' };
}

// ============================================
// ANIMATIONS
// ============================================

function initializeAnimations() {
    // Add animation class to elements on load
    const elements = document.querySelectorAll('.card, .section-title, .btn');
    elements.forEach((el, index) => {
        el.style.animationDelay = `${index * 0.1}s`;
    });

    // Continuous floating animation on hover
    const floatingElements = document.querySelectorAll('.project-image');
    floatingElements.forEach(el => {
        el.addEventListener('mouseenter', function() {
            this.style.animation = 'floatAnimation 3s ease-in-out infinite';
        });
        el.addEventListener('mouseleave', function() {
            this.style.animation = 'none';
        });
    });

    // Cursor effects
    initializeCursorEffects();
}

function initializeCursorEffects() {
    const mouse = { x: 0, y: 0 };
    
    document.addEventListener('mousemove', (e) => {
        mouse.x = e.clientX;
        mouse.y = e.clientY;
    });
}

// ============================================
// SCROLL ANIMATIONS
// ============================================

function initializeScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    document.querySelectorAll('.card, .project-card, .skill-category').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'all 0.6s ease-out';
        observer.observe(el);
    });
}

// ============================================
// FORM VALIDATION
// ============================================

function initializeFormValidation() {
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', handleContactFormSubmit);
    }

    // Real-time validation for input fields
    const inputs = document.querySelectorAll('input[type="email"], input[type="text"], textarea');
    inputs.forEach(input => {
        input.addEventListener('blur', validateField);
        input.addEventListener('input', removeErrorClass);
    });
}

function validateField(event) {
    const field = event.target;
    const fieldName = field.name;
    const fieldValue = field.value.trim();

    let isValid = true;
    let errorMessage = '';

    if (fieldName === 'name') {
        if (fieldValue.length < 2) {
            isValid = false;
            errorMessage = 'Name must be at least 2 characters long';
        }
    } else if (fieldName === 'email') {
        if (!isValidEmail(fieldValue)) {
            isValid = false;
            errorMessage = 'Please enter a valid email address';
        }
    } else if (fieldName === 'message') {
        if (fieldValue.length < 10) {
            isValid = false;
            errorMessage = 'Message must be at least 10 characters long';
        }
    } else if (fieldName === 'password') {
        if (fieldValue.length < 8) {
            isValid = false;
            errorMessage = 'Password must be at least 8 characters long';
        }
    }

    if (!isValid) {
        field.classList.add('error');
        showFieldError(field, errorMessage);
    } else {
        field.classList.remove('error');
        hideFieldError(field);
    }

    return isValid;
}

function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function showFieldError(field, message) {
    // Remove existing error message if any
    hideFieldError(field);
    
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.textContent = message;
    errorDiv.style.cssText = `
        color: #ff6b6b;
        font-size: 0.85rem;
        margin-top: 0.3rem;
        animation: slideInDown 0.3s ease-out;
    `;
    field.parentNode.insertBefore(errorDiv, field.nextSibling);
}

function hideFieldError(field) {
    const errorDiv = field.parentNode.querySelector('.field-error');
    if (errorDiv) {
        errorDiv.remove();
    }
}

function removeErrorClass(event) {
    event.target.classList.remove('error');
}

function handleContactFormSubmit(event) {
    event.preventDefault();

    const form = event.target;
    const formData = new FormData(form);
    const nameField = form.querySelector('input[name="name"]');
    const emailField = form.querySelector('input[name="email"]');
    const messageField = form.querySelector('textarea[name="message"]');

    // Validate all fields
    let isFormValid = true;
    isFormValid = validateField({ target: nameField }) && isFormValid;
    isFormValid = validateField({ target: emailField }) && isFormValid;
    isFormValid = validateField({ target: messageField }) && isFormValid;

    if (!isFormValid) {
        return;
    }

    // Show loading state
    const submitBtn = form.querySelector('button[type="submit"]');
    const originalText = submitBtn.textContent;
    submitBtn.disabled = true;
    submitBtn.textContent = 'Sending...';

    const payload = new URLSearchParams();
    formData.forEach((value, key) => {
        payload.append(key, value);
    });

    // Send form data via AJAX
    fetch('contact', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: payload.toString()
    })
    .then(response => response.json())
    .then(data => {
        showNotification(data.message, data.success ? 'success' : 'error');
        if (data.success) {
            form.reset();
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('An error occurred. Please try again.', 'error');
    })
    .finally(() => {
        submitBtn.disabled = false;
        submitBtn.textContent = originalText;
    });
}

// ============================================
// NOTIFICATIONS
// ============================================

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = type === 'success' ? 'success-message' : 'error-message';
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 80px;
        right: 20px;
        max-width: 400px;
        z-index: 2000;
        animation: slideInRight 0.5s ease-out;
    `;

    document.body.appendChild(notification);

    // Auto-remove after 5 seconds
    setTimeout(() => {
        notification.style.animation = 'slideInLeft 0.5s ease-out reverse';
        setTimeout(() => notification.remove(), 500);
    }, 5000);
}

// ============================================
// THEME TOGGLE (Dark/Light Mode)
// ============================================

function initializeThemeToggle() {
    const themeToggleBtn = document.getElementById('themeToggle');
    if (themeToggleBtn) {
        const savedTheme = localStorage.getItem('theme') || 'dark';
        setTheme(savedTheme);
        
        themeToggleBtn.addEventListener('click', toggleTheme);
    }
}

function toggleTheme() {
    const currentTheme = localStorage.getItem('theme') || 'dark';
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    setTheme(newTheme);
}

function setTheme(theme) {
    const root = document.documentElement;
    const themeToggleBtn = document.getElementById('themeToggle');
    const body = document.body;

    if (theme === 'light') {
        // Light mode colors
        root.style.setProperty('--primary-dark', '#f5f5f5');
        root.style.setProperty('--primary-light', '#0a0a0a');
        root.style.setProperty('--primary-grey', '#e0e0e0');
        root.style.setProperty('--accent', '#0a0a0a');
        root.style.setProperty('--secondary-grey', '#606060');
        root.style.setProperty('--text-dark', '#f5f5f5');
        root.style.setProperty('--text-light', '#1a1a1a');
        root.style.setProperty('--border', '#d0d0d0');
        root.style.setProperty('--button-primary-text', '#ffffff');
        
        document.body.style.background = 'linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%)';
        body.classList.add('light-theme');
        body.classList.remove('dark-theme');
        
        if (themeToggleBtn) {
            themeToggleBtn.textContent = '🌙 Dark Mode';
        }
    } else {
        // Dark mode colors
        root.style.setProperty('--primary-dark', '#0a0a0a');
        root.style.setProperty('--primary-light', '#f5f5f5');
        root.style.setProperty('--primary-grey', '#2d2d2d');
        root.style.setProperty('--accent', '#ffffff');
        root.style.setProperty('--secondary-grey', '#404040');
        root.style.setProperty('--text-dark', '#1a1a1a');
        root.style.setProperty('--text-light', '#e0e0e0');
        root.style.setProperty('--border', '#333333');
        root.style.setProperty('--button-primary-text', '#0f0f0f');
        
        document.body.style.background = 'linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%)';
        body.classList.add('dark-theme');
        body.classList.remove('light-theme');
        
        if (themeToggleBtn) {
            themeToggleBtn.textContent = '☀️ Light Mode';
        }
    }

    localStorage.setItem('theme', theme);
}

// ============================================
// PROJECT FILTERING & SORTING
// ============================================

function initializeProjectFiltering() {
    const filterBtn = document.querySelector('.filter-projects');
    const sortBtn = document.querySelector('.sort-projects');
    const searchInput = document.querySelector('.search-projects');

    if (filterBtn) {
        filterBtn.addEventListener('change', filterProjects);
    }

    if (sortBtn) {
        sortBtn.addEventListener('change', sortProjects);
    }

    if (searchInput) {
        searchInput.addEventListener('input', searchProjects);
    }
}

function filterProjects(event) {
    const selectedTech = event.target.value.toLowerCase();
    const projects = document.querySelectorAll('.project-card');

    projects.forEach(project => {
        const techs = project.getAttribute('data-technologies').toLowerCase();
        
        if (selectedTech === '' || techs.includes(selectedTech)) {
            project.style.display = 'block';
            project.style.animation = 'fadeInUp 0.6s ease-out';
        } else {
            project.style.display = 'none';
        }
    });
}

function sortProjects(event) {
    const sortType = event.target.value;
    const projectsContainer = document.querySelector('.projects-grid');
    const projects = Array.from(document.querySelectorAll('.project-card'));

    if (sortType === 'latest') {
        projects.sort((a, b) => {
            const dateA = new Date(a.getAttribute('data-date'));
            const dateB = new Date(b.getAttribute('data-date'));
            return dateB - dateA;
        });
    } else if (sortType === 'oldest') {
        projects.sort((a, b) => {
            const dateA = new Date(a.getAttribute('data-date'));
            const dateB = new Date(b.getAttribute('data-date'));
            return dateA - dateB;
        });
    } else if (sortType === 'alphabetical') {
        projects.sort((a, b) => {
            const titleA = a.getAttribute('data-title').toLowerCase();
            const titleB = b.getAttribute('data-title').toLowerCase();
            return titleA.localeCompare(titleB);
        });
    }

    // Reorder in DOM
    projects.forEach(project => {
        projectsContainer.appendChild(project);
        project.style.animation = 'none';
        setTimeout(() => {
            project.style.animation = 'fadeInUp 0.6s ease-out';
        }, 10);
    });
}

function searchProjects(event) {
    const searchTerm = event.target.value.toLowerCase();
    const projects = document.querySelectorAll('.project-card');

    projects.forEach(project => {
        const title = project.getAttribute('data-title').toLowerCase();
        const description = project.getAttribute('data-description').toLowerCase();

        if (title.includes(searchTerm) || description.includes(searchTerm)) {
            project.style.display = 'block';
            project.style.animation = 'fadeInUp 0.6s ease-out';
        } else {
            project.style.display = 'none';
        }
    });
}

// ============================================
// SMOOTH SCROLL FOR NAVIGATION LINKS
// ============================================

document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    });
});

// ============================================
// PARALLAX EFFECT FOR HERO
// ============================================

window.addEventListener('scroll', function() {
    const scrollPosition = window.scrollY;
    const heroElement = document.querySelector('.hero');
    
    if (heroElement) {
        heroElement.style.backgroundPosition = `0 ${scrollPosition * 0.5}px`;
    }
});

// ============================================
// SESSION TIMEOUT WARNING
// ============================================

function initializeSessionTimeout() {
    let timeout;
    const warningTime = 25 * 60 * 1000; // 25 minutes
    const logoutTime = 30 * 60 * 1000; // 30 minutes

    function resetTimeout() {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
            showNotification('Your session will expire soon. Please save your work.', 'warning');
        }, warningTime);
    }

    // Reset timer on user activity
    document.addEventListener('mousemove', resetTimeout);
    document.addEventListener('keypress', resetTimeout);
    document.addEventListener('click', resetTimeout);

    resetTimeout();
}

if (document.body.classList.contains('authenticated')) {
    initializeSessionTimeout();
}

// Export functions for use in JSP files
window.portfolioApp = {
    validateField,
    showNotification,
    toggleTheme,
    filterProjects,
    sortProjects,
    searchProjects
};
