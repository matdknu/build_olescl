<?php
/**
 * Observatorio de Legitimidad Theme Functions
 * 
 * @package ObservatorioLegitimidad
 */

// Prevenir acceso directo
if (!defined('ABSPATH')) {
    exit;
}

/**
 * Cargar estilos y scripts
 */
function observatorio_enqueue_scripts() {
    // Cargar estilos
    wp_enqueue_style(
        'observatorio-style',
        get_template_directory_uri() . '/style.css',
        array(),
        '1.0.0'
    );
    
    // Cargar JavaScript
    wp_enqueue_script(
        'observatorio-script',
        get_template_directory_uri() . '/script.js',
        array(),
        '1.0.0',
        true // Cargar en el footer
    );
}
add_action('wp_enqueue_scripts', 'observatorio_enqueue_scripts');

/**
 * Registrar menús de navegación
 */
function observatorio_register_menus() {
    register_nav_menus(array(
        'primary' => __('Menú Principal', 'observatorio-legitimidad'),
        'footer' => __('Menú Footer', 'observatorio-legitimidad'),
    ));
}
add_action('after_setup_theme', 'observatorio_register_menus');

/**
 * Soporte para características del tema
 */
function observatorio_theme_support() {
    // Soporte para título dinámico
    add_theme_support('title-tag');
    
    // Soporte para imágenes destacadas
    add_theme_support('post-thumbnails');
    
    // Soporte para HTML5
    add_theme_support('html5', array(
        'search-form',
        'comment-form',
        'comment-list',
        'gallery',
        'caption',
    ));
}
add_action('after_setup_theme', 'observatorio_theme_support');

/**
 * Agregar clases al body
 */
function observatorio_body_classes($classes) {
    $classes[] = 'observatorio-theme';
    return $classes;
}
add_filter('body_class', 'observatorio_body_classes');

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

