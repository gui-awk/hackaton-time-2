package br.gov.sp.centralcidadao.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI centralCidadaoOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Central do Cidadão API")
                        .description("API REST para o Portal Integrado de Serviços Urbanos")
                        .version("1.0.0")
                        .contact(new Contact()
                                .name("Central do Cidadão")
                                .email("contato@centralcidadao.gov.br"))
                        .license(new License()
                                .name("Apache 2.0")
                                .url("http://springdoc.org")));
    }
}
