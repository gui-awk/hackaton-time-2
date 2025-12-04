package br.gov.sp.centralcidadao.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "escolas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Escola {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nome;

    private String endereco;

    @Column(length = 100)
    private String bairro;

    @Column(length = 100)
    private String cidade;

    @Column(length = 20)
    private String telefone;

    @Enumerated(EnumType.STRING)
    @Column(name = "nivel_ensino", nullable = false)
    private NivelEnsino nivelEnsino;

    @Column(name = "vagas_totais")
    private Integer vagasTotais = 0;

    @Column(name = "vagas_ocupadas")
    private Integer vagasOcupadas = 0;

    private Boolean ativo = true;

    @Column(name = "data_cadastro")
    private LocalDateTime dataCadastro;

    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao;

    public Integer getVagasDisponiveis() {
        return vagasTotais - vagasOcupadas;
    }

    public Double getPercentualOcupacao() {
        if (vagasTotais == 0) return 0.0;
        return (vagasOcupadas.doubleValue() / vagasTotais.doubleValue()) * 100;
    }

    @PrePersist
    protected void onCreate() {
        dataCadastro = LocalDateTime.now();
        dataAtualizacao = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        dataAtualizacao = LocalDateTime.now();
    }
}
