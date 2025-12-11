<?php
/**
 * Template Name: Observatorio de Legitimidad
 * 
 * Template para la página principal del Observatorio de Legitimidad
 * 
 * @package ObservatorioLegitimidad
 */

get_header();
?>

<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
    <!-- Header con Menú -->
    <header class="header">
        <div class="container">
            <div class="logo">
                <h1><a href="<?php echo esc_url(home_url('/')); ?>" style="color: white; text-decoration: none;"><?php bloginfo('name'); ?></a></h1>
            </div>
            <nav class="nav">
                <?php
                wp_nav_menu(array(
                    'theme_location' => 'primary',
                    'container' => false,
                    'menu_class' => 'nav-menu',
                    'fallback_cb' => 'observatorio_fallback_menu',
                ));
                ?>
                <div class="mobile-menu-toggle">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </nav>
        </div>
    </header>

    <!-- Hero Section -->
    <section id="inicio" class="hero">
        <div class="hero-imagen"></div>
        <div class="container">
            <h2><?php bloginfo('name'); ?></h2>
            <p><?php bloginfo('description'); ?></p>
        </div>
    </section>

    <!-- Destacados Section -->
    <section class="destacados-section">
        <div class="container">
            <h2 class="section-title">Destacados</h2>
            <div class="destacados-grid">
                <article class="destacado-card evento">
                    <div class="destacado-imagen">
                        <img src="https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=250&fit=crop" alt="Seminario">
                    </div>
                    <div class="destacado-tipo">Evento</div>
                    <h3>Seminario "Legitimidad Institucional y Confianza Ciudadana"</h3>
                    <div class="destacado-fecha">15 Diciembre 2025</div>
                </article>
                <article class="destacado-card noticia">
                    <div class="destacado-imagen">
                        <img src="https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=400&h=250&fit=crop" alt="Conversatorio">
                    </div>
                    <div class="destacado-tipo">Noticia</div>
                    <h3>Con éxito se llevó a cabo el Conversatorio "A seis años del estallido social en Chile"</h3>
                    <div class="destacado-fecha">30 Octubre 2025</div>
                </article>
                <article class="destacado-card noticia">
                    <div class="destacado-imagen">
                        <img src="https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&h=250&fit=crop" alt="Investigación">
                    </div>
                    <div class="destacado-tipo">Noticia</div>
                    <h3>Investigadoras/es del Observatorio se adjudican el Concurso Núcleos Milenio 2025</h3>
                    <div class="destacado-fecha">5 Noviembre 2025</div>
                </article>
                <article class="destacado-card noticia">
                    <div class="destacado-imagen">
                        <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=400&h=250&fit=crop" alt="Jornada">
                    </div>
                    <div class="destacado-tipo">Noticia</div>
                    <h3>VI Jornada de Investigadoras e Investigadores Jóvenes en Temáticas de Legitimidad</h3>
                    <div class="destacado-fecha">30 Octubre 2025</div>
                </article>
            </div>
        </div>
    </section>

    <!-- Noticias Section -->
    <section id="noticias" class="noticias-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Noticias</h2>
                <a href="#lo-ultimo" class="ver-mas-link">Ver más →</a>
            </div>
            <div class="noticias-grid">
                <article class="noticia-card">
                    <div class="noticia-imagen">
                        <img src="https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&h=250&fit=crop" alt="Noticia">
                    </div>
                    <div class="noticia-fecha">5 Noviembre 2025</div>
                    <h3>Investigadoras/es del Observatorio se adjudican el Concurso Núcleos Milenio en Ciencias Sociales 2025</h3>
                </article>
                <article class="noticia-card">
                    <div class="noticia-imagen">
                        <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=400&h=250&fit=crop" alt="Noticia">
                    </div>
                    <div class="noticia-fecha">30 Octubre 2025</div>
                    <h3>Estudiantes de la práctica "Observando Legitimidad" realizan su primer ejercicio de entrevista</h3>
                </article>
                <article class="noticia-card">
                    <div class="noticia-imagen">
                        <img src="https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400&h=250&fit=crop" alt="Noticia">
                    </div>
                    <div class="noticia-fecha">30 Octubre 2025</div>
                    <h3>Clase abierta del curso "Sociología de la Legitimidad" con presentación de resultados</h3>
                </article>
            </div>
        </div>
    </section>

    <!-- Agenda Section -->
    <section id="eventos" class="agenda-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Agenda</h2>
                <a href="#eventos" class="ver-mas-link">Ver más →</a>
            </div>
            <div class="agenda-grid">
                <article class="agenda-item">
                    <div class="agenda-fecha">
                        <div class="agenda-dia">11</div>
                        <div class="agenda-mes">diciembre</div>
                    </div>
                    <div class="agenda-content">
                        <h3>Seminario Legitimidad, redes personales y actitudes políticas</h3>
                        <p class="agenda-lugar">Sala Taller T202, Facultad de Ciencias Sociales</p>
                        <p class="agenda-hora">9:00 a 12:30 hrs</p>
                    </div>
                </article>
                <article class="agenda-item">
                    <div class="agenda-fecha">
                        <div class="agenda-dia">10</div>
                        <div class="agenda-mes">enero</div>
                        <div class="agenda-ano">2026</div>
                    </div>
                    <div class="agenda-content">
                        <h3>Escuela de Formación "Crisis climática y legitimidad institucional"</h3>
                        <p class="agenda-hora">9:00 hrs</p>
                    </div>
                </article>
            </div>
        </div>
    </section>

    <!-- Proyectos Section -->
    <section id="proyectos" class="proyectos-section">
        <div class="container">
            <h2 class="section-title">Proyectos</h2>
            <div class="proyectos-cuadrantes">
                <a href="<?php echo esc_url(get_template_directory_uri()); ?>/proyectos/encuestas.html" class="proyecto-cuadrante">
                    <div class="proyecto-imagen">
                        <img src="https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=600&h=400&fit=crop" alt="Estudios de Encuesta">
                    </div>
                    <div class="proyecto-cuadrante-content">
                        <h3>Estudios de Encuesta</h3>
                        <p>Investigaciones basadas en encuestas representativas que analizan percepciones y actitudes sobre legitimidad institucional.</p>
                        <span class="proyecto-link">Ver proyectos →</span>
                    </div>
                </a>
                <a href="<?php echo esc_url(get_template_directory_uri()); ?>/proyectos/cualitativos.html" class="proyecto-cuadrante">
                    <div class="proyecto-imagen">
                        <img src="https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=600&h=400&fit=crop" alt="Estudios Cualitativos">
                    </div>
                    <div class="proyecto-cuadrante-content">
                        <h3>Estudios Cualitativos</h3>
                        <p>Investigaciones cualitativas que profundizan en las experiencias y narrativas sobre legitimidad institucional.</p>
                        <span class="proyecto-link">Ver proyectos →</span>
                    </div>
                </a>
                <a href="<?php echo esc_url(get_template_directory_uri()); ?>/proyectos/prensa-redes.html" class="proyecto-cuadrante">
                    <div class="proyecto-imagen">
                        <img src="https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=600&h=400&fit=crop" alt="Estudios de Prensa y Redes Sociales">
                    </div>
                    <div class="proyecto-cuadrante-content">
                        <h3>Estudios de Prensa y Redes Sociales</h3>
                        <p>Análisis de contenido de medios de comunicación y redes sociales sobre legitimidad y confianza institucional.</p>
                        <span class="proyecto-link">Ver proyectos →</span>
                    </div>
                </a>
                <a href="<?php echo esc_url(get_template_directory_uri()); ?>/proyectos/datos-administrativos.html" class="proyecto-cuadrante">
                    <div class="proyecto-imagen">
                        <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&h=400&fit=crop" alt="Estudios de Datos Administrativos">
                    </div>
                    <div class="proyecto-cuadrante-content">
                        <h3>Estudios de Datos Administrativos</h3>
                        <p>Análisis de datos administrativos y estadísticos para comprender patrones de legitimidad institucional.</p>
                        <span class="proyecto-link">Ver proyectos →</span>
                    </div>
                </a>
            </div>
        </div>
    </section>

    <!-- Nosotros Section -->
    <section id="nosotros" class="nosotros-section">
        <div class="container">
            <h2 class="section-title">Acerca del Observatorio</h2>
            <div class="nosotros-content">
                <div id="mision" class="nosotros-texto">
                    <h3>Misión</h3>
                    <p>El Observatorio de Legitimidad tiene como misión generar conocimiento científico de calidad sobre la legitimidad institucional en Chile, contribuyendo al debate público y a la formulación de políticas basadas en evidencia.</p>
                    
                    <h3>Visión</h3>
                    <p>Ser un referente nacional e internacional en la investigación sobre legitimidad institucional, desigualdades y cohesión social, promoviendo el diálogo entre la academia, la sociedad civil y los tomadores de decisión.</p>
                </div>
                <div id="equipo" class="equipo-section">
                    <h3 class="equipo-title">Equipo</h3>
                    <div class="equipo-grid">
                        <div class="equipo-card">
                            <div class="equipo-avatar">👤</div>
                            <h4>Dr. Investigador Principal</h4>
                            <p>Director del Observatorio</p>
                        </div>
                        <div class="equipo-card">
                            <div class="equipo-avatar">👤</div>
                            <h4>Dra. Investigadora</h4>
                            <p>Coordinadora de Investigación</p>
                        </div>
                        <div class="equipo-card">
                            <div class="equipo-avatar">👤</div>
                            <h4>Dr. Investigador</h4>
                            <p>Investigador Senior</p>
                        </div>
                        <div class="equipo-card">
                            <div class="equipo-avatar">👤</div>
                            <h4>Investigadora Joven</h4>
                            <p>Investigadora Asociada</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>Enlaces</h4>
                    <?php
                    wp_nav_menu(array(
                        'theme_location' => 'footer',
                        'container' => false,
                        'menu_class' => 'footer-menu',
                        'fallback_cb' => false,
                    ));
                    ?>
                </div>
                <div class="footer-section" id="contacto">
                    <h4>Contacto</h4>
                    <p>Email: observatorio@universidad.cl</p>
                    <p>Teléfono: +56 2 2676 8479</p>
                    <p>Dirección: Avenida Ejército #333, Santiago, Chile</p>
                </div>
                <div class="footer-section">
                    <h4>Investigación</h4>
                    <ul>
                        <li><a href="#proyectos">Proyectos</a></li>
                        <li><a href="#publicaciones">Publicaciones</a></li>
                        <li><a href="#tesis">Tesis y Prácticas</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; <?php echo date('Y'); ?> <?php bloginfo('name'); ?>. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>

    <?php wp_footer(); ?>
</body>
</html>

<?php
get_footer();

/**
 * Menú de fallback si no hay menú configurado
 */
function observatorio_fallback_menu() {
    echo '<ul class="nav-menu">';
    echo '<li><a href="' . esc_url(home_url('/')) . '">Inicio</a></li>';
    echo '<li><a href="#proyectos">Proyectos</a></li>';
    echo '<li><a href="#nosotros">Nosotros</a></li>';
    echo '<li><a href="#contacto">Contacto</a></li>';
    echo '</ul>';
}
?>


