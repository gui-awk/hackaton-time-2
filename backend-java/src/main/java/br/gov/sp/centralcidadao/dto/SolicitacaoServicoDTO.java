package br.gov.sp.centralcidadao.dto;

import br.gov.sp.centralcidadao.domain.Prioridade;
import br.gov.sp.centralcidadao.domain.StatusSolicitacao;
import br.gov.sp.centralcidadao.domain.TipoServico;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SolicitacaoServicoDTO {
    
    private Long id;
    private String protocolo;
    
    @NotNull(message = "ID do cidadão é obrigatório")
    private Long cidadaoId;
    
    private String cidadaoNome;
    
    @NotNull(message = "Tipo de serviço é obrigatório")
    private TipoServico tipoServico;
    
    private String tipoServicoDescricao;
    
    @NotBlank(message = "Descrição é obrigatória")
    private String descricao;
    
    @NotBlank(message = "Endereço é obrigatório")
    private String endereco;
    
    private String bairro;
    private String pontoReferencia;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private String fotoUrl;
    private StatusSolicitacao status;
    private String statusDescricao;
    private Prioridade prioridade;
    private String prioridadeDescricao;
    private LocalDateTime dataSolicitacao;
    private LocalDateTime dataAtualizacao;
    private LocalDateTime dataConclusao;
}
