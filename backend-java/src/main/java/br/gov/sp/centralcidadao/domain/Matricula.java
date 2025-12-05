package br.gov.sp.centralcidadao.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "matriculas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Matricula {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 20)
    private String protocolo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cidadao_id", nullable = false)
    private Cidadao cidadao;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "escola_id", nullable = false)
    private Escola escola;

    @Column(name = "nome_aluno", nullable = false)
    private String nomeAluno;

    @Column(name = "data_nascimento")
    private LocalDate dataNascimento;

    @Enumerated(EnumType.STRING)
    @Column(name = "nivel_ensino", nullable = false)
    private NivelEnsino nivelEnsino;

    @Column(length = 50)
    private String serie;

    @Enumerated(EnumType.STRING)
    private StatusMatricula status = StatusMatricula.PENDENTE;

    @Column(columnDefinition = "TEXT")
    private String observacoes;

    @Column(name = "data_solicitacao")
    private LocalDateTime dataSolicitacao;

    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao;

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
        return "MAT" + System.currentTimeMillis();
    }
}
