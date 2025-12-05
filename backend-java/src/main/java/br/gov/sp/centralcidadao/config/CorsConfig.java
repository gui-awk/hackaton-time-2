package br.gov.sp.centralcidadao.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.Arrays;

@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        
        // Permitir origens (Flutter web, localhost, etc.)
        config.setAllowedOrigins(Arrays.asList(
            "http://localhost:3000",
            "http://localhost:8080",
            "http://localhost:80",
            "http://127.0.0.1:3000",
            "http://127.0.0.1:8080"
        ));
        
        // Ou permitir todas as origens (para desenvolvimento)
        config.setAllowedOriginPatterns(Arrays.asList("*"));
        
        // Métodos HTTP permitidos
        config.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        
        // Headers permitidos
        config.setAllowedHeaders(Arrays.asList("*"));
        
        // Permitir credenciais
        config.setAllowCredentials(true);
        
        // Tempo de cache do preflight
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        return new CorsFilter(source);
    }
}
