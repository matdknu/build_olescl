// Mobile Menu Toggle
const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
const navMenu = document.querySelector('.nav-menu');

if (mobileMenuToggle) {
    mobileMenuToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
        
        // Animate hamburger icon
        const spans = mobileMenuToggle.querySelectorAll('span');
        if (navMenu.classList.contains('active')) {
            spans[0].style.transform = 'rotate(45deg) translateY(8px)';
            spans[1].style.opacity = '0';
            spans[2].style.transform = 'rotate(-45deg) translateY(-8px)';
        } else {
            spans[0].style.transform = 'none';
            spans[1].style.opacity = '1';
            spans[2].style.transform = 'none';
        }
    });
}

// Close mobile menu when clicking outside
document.addEventListener('click', (e) => {
    if (!navMenu.contains(e.target) && !mobileMenuToggle.contains(e.target)) {
        navMenu.classList.remove('active');
        const spans = mobileMenuToggle.querySelectorAll('span');
        spans[0].style.transform = 'none';
        spans[1].style.opacity = '1';
        spans[2].style.transform = 'none';
    }
});

// Tabs Functionality
const tabButtons = document.querySelectorAll('.tab-button');
const tabPanes = document.querySelectorAll('.tab-pane');

tabButtons.forEach(button => {
    button.addEventListener('click', () => {
        const targetTab = button.getAttribute('data-tab');
        
        // Remove active class from all buttons and panes
        tabButtons.forEach(btn => btn.classList.remove('active'));
        tabPanes.forEach(pane => pane.classList.remove('active'));
        
        // Add active class to clicked button and corresponding pane
        button.classList.add('active');
        document.getElementById(targetTab).classList.add('active');
    });
});

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
            // Close mobile menu if open
            navMenu.classList.remove('active');
        }
    });
});

// Add scroll effect to header
let lastScroll = 0;
const header = document.querySelector('.header');

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    
    if (currentScroll > 100) {
        header.style.boxShadow = '0 10px 15px -3px rgba(0, 0, 0, 0.2)';
    } else {
        header.style.boxShadow = '0 10px 15px -3px rgba(0, 0, 0, 0.1)';
    }
    
    lastScroll = currentScroll;
});

// Dropdown menu for mobile (touch devices)
if (window.innerWidth <= 768) {
    const dropdownToggles = document.querySelectorAll('.dropdown-toggle');
    
    dropdownToggles.forEach(toggle => {
        toggle.addEventListener('click', (e) => {
            e.preventDefault();
            const dropdown = toggle.parentElement;
            const dropdownMenu = dropdown.querySelector('.dropdown-menu');
            
            // Close other dropdowns
            dropdownToggles.forEach(otherToggle => {
                if (otherToggle !== toggle) {
                    const otherDropdown = otherToggle.parentElement;
                    const otherMenu = otherDropdown.querySelector('.dropdown-menu');
                    otherMenu.style.display = 'none';
                }
            });
            
            // Toggle current dropdown
            if (dropdownMenu.style.display === 'block') {
                dropdownMenu.style.display = 'none';
            } else {
                dropdownMenu.style.display = 'block';
            }
        });
    });
}

// Add active state to navigation links based on scroll position
const sections = document.querySelectorAll('section[id]');
const navLinks = document.querySelectorAll('.nav-menu a[href^="#"]');

window.addEventListener('scroll', () => {
    let current = '';
    
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        if (window.pageYOffset >= sectionTop - 200) {
            current = section.getAttribute('id');
        }
    });
    
    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === `#${current}`) {
            link.classList.add('active');
        }
    });
});

// Load and display publications
async function loadPublications() {
    try {
        const response = await fetch('data/publicaciones.json');
        const publicaciones = await response.json();
        
        // Mapeo de nombres de investigadores a sus slugs de perfil
        const investigadoresMap = {
            'Luciano Sáez Fuentealba': 'luciano-saez-fuentealba',
            'Luciano Sáez': 'luciano-saez-fuentealba',
            'Mónica Gerber': 'monica-gerber',
            'Monica Gerber': 'monica-gerber',
            'Mónica Gerber Plüss': 'monica-gerber',
            'Ana Figueiredo': 'ana-figueiredo',
            'Ana Figueiredo Mateus': 'ana-figueiredo',
            'Macarena Orchard': 'macarena-orchard',
            'Macarena Orchard Rieiro': 'macarena-orchard',
            'Joaquín Bahamondes': 'joaquin-bahamondes',
            'Cristóbal Moya': 'cristobal-moya',
            'Cristobal Moya': 'cristobal-moya',
            'Ismael Puga': 'ismael-puga',
            'Loreto Quiroz': 'loreto-quiroz',
            'Paz Irarrázabal González': 'paz-irarrazabal-gonzalez'
        };
        
        const container = document.getElementById('publicaciones-container');
        if (!container) return;
        
        // Agrupar por año
        const porAno = {};
        publicaciones.forEach(pub => {
            if (!porAno[pub.year]) {
                porAno[pub.year] = [];
            }
            porAno[pub.year].push(pub);
        });
        
        // Ordenar años descendente
        const anos = Object.keys(porAno).sort((a, b) => b - a);
        
        anos.forEach(ano => {
            const anoSection = document.createElement('div');
            anoSection.className = 'publicaciones-ano';
            anoSection.innerHTML = `<h3 style="font-size: 1.75rem; margin: 2rem 0 1rem; color: var(--primary-color); border-bottom: 2px solid var(--primary-color); padding-bottom: 0.5rem;">${ano}</h3>`;
            
            porAno[ano].forEach(pub => {
                const pubItem = document.createElement('div');
                pubItem.className = 'publicacion-item-main';
                
                // Crear lista de autores con enlaces
                const autoresHtml = pub.authors.map(author => {
                    const slug = investigadoresMap[author];
                    if (slug) {
                        return `<a href="equipo/${slug}.html" style="color: var(--primary-color); text-decoration: none; font-weight: 600;">${author}</a>`;
                    }
                    return author;
                }).join(', ');
                
                pubItem.innerHTML = `
                    <p style="margin-bottom: 0.5rem; line-height: 1.6;">
                        ${autoresHtml} (${pub.year}). ${pub.title}.
                        ${pub.journal ? `<em>${pub.journal}</em>.` : ''}
                        ${pub.doi ? `<a href="${pub.doi}" target="_blank" style="color: var(--primary-color); text-decoration: none; margin-left: 0.5rem;">DOI</a>` : ''}
                        ${pub.pdf ? `<a href="${pub.pdf}" target="_blank" style="color: var(--primary-color); text-decoration: none; margin-left: 0.5rem;">PDF</a>` : ''}
                    </p>
                `;
                
                anoSection.appendChild(pubItem);
            });
            
            container.appendChild(anoSection);
        });
    } catch (error) {
        console.error('Error loading publications:', error);
    }
}

// Load publications when page loads
if (document.getElementById('publicaciones-container')) {
    loadPublications();
}

// Load destacados
async function loadDestacados() {
    try {
        const response = await fetch('content/destacados-generated.html');
        const html = await response.text();
        const container = document.getElementById('destacados-container');
        if (container) {
            container.innerHTML = html;
        }
    } catch (error) {
        console.error('Error loading destacados:', error);
    }
}

// Load destacados when page loads
if (document.getElementById('destacados-container')) {
    loadDestacados();
}

