package br.gov.sp.centralcidadao.dto;

import br.gov.sp.centralcidadao.domain.NivelEnsino;
import br.gov.sp.centralcidadao.domain.StatusMatricula;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MatriculaDTO {
    
    private Long id;
    private String protocolo;
    
    @NotNull(message = "ID do cidadão é obrigatório")
    private Long cidadaoId;
    
    private String cidadaoNome;
    
    @NotNull(message = "ID da escola é obrigatório")
    private Long escolaId;
    
    private String escolaNome;
    
    @NotBlank(message = "Nome do aluno é obrigatório")
    private String nomeAluno;
    
    private LocalDate dataNascimento;
    
    @NotNull(message = "Nível de ensino é obrigatório")
    private NivelEnsino nivelEnsino;
    
    private String nivelEnsinoDescricao;
    private String serie;
    private StatusMatricula status;
    private String statusDescricao;
    private String observacoes;
    private LocalDateTime dataSolicitacao;
    private LocalDateTime dataAtualizacao;
}
