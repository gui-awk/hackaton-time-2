package br.gov.sp.centralcidadao.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "solicitacoes_servicos")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SolicitacaoServico {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 20)
    private String protocolo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cidadao_id", nullable = false)
    private Cidadao cidadao;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_servico", nullable = false)
    private TipoServico tipoServico;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String descricao;

    @Column(nullable = false)
    private String endereco;

    @Column(length = 100)
    private String bairro;

    @Column(name = "ponto_referencia")
    private String pontoReferencia;

    @Column(precision = 10, scale = 8)
    private BigDecimal latitude;

    @Column(precision = 11, scale = 8)
    private BigDecimal longitude;

    @Column(name = "foto_url", length = 500)
    private String fotoUrl;

    @Enumerated(EnumType.STRING)
    private StatusSolicitacao status = StatusSolicitacao.ABERTA;

    @Enumerated(EnumType.STRING)
    private Prioridade prioridade = Prioridade.MEDIA;

    @Column(name = "data_solicitacao")
    private LocalDateTime dataSolicitacao;

    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao;

    @Column(name = "data_conclusao")
    private LocalDateTime dataConclusao;

    @PrePersist
    protected void onCreate() {
        dataSolicitacao = LocalDateTime.now();
        dataAtualizacao = LocalDateTime.now();
        if (protocolo == null) {
            protocolo = gerarProtocolo();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        dataAtualizacao = LocalDateTime.now();
    }

    private String gerarProtocolo() {
        String prefixo = switch (tipoServico) {
            case PODA -> "POD";
            case ILUMINACAO -> "ILU";
            case OBRAS -> "OBR";
            case LIMPEZA -> "LIM";
        };
        return prefixo + System.currentTimeMillis();
    }
}
