package br.gov.sp.centralcidadao.dto;

import br.gov.sp.centralcidadao.domain.NivelEnsino;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EscolaDTO {
    
    private Long id;
    private String nome;
    private String endereco;
    private String bairro;
    private String cidade;
    private String telefone;
    private NivelEnsino nivelEnsino;
    private String nivelEnsinoDescricao;
    private Integer vagasTotais;
    private Integer vagasOcupadas;
    private Integer vagasDisponiveis;
    private Double percentualOcupacao;
    private String statusVagas; // "DISPONIVEL", "LIMITADO", "LOTADO"
}
