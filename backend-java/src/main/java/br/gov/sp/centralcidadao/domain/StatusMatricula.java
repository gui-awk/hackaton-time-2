package br.gov.sp.centralcidadao.domain;

public enum StatusMatricula {
    PENDENTE("Pendente"),
    EM_ANALISE("Em Análise"),
    APROVADA("Aprovada"),
    REJEITADA("Rejeitada"),
    CANCELADA("Cancelada");

    private final String descricao;

    StatusMatricula(String descricao) {
        this.descricao = descricao;
    }

    public String getDescricao() {
        return descricao;
    }
}
