package br.gov.sp.centralcidadao.dto;

import br.gov.sp.centralcidadao.domain.TipoNotificacao;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotificacaoDTO {
    
    private Long id;
    private Long cidadaoId;
    private String titulo;
    private String mensagem;
    private TipoNotificacao tipo;
    private Boolean lida;
    private LocalDateTime dataCriacao;
}
