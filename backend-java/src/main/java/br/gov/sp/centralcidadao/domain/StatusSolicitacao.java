package br.gov.sp.centralcidadao.domain;

public enum StatusSolicitacao {
    ABERTA("Aberta"),
    EM_ANALISE("Em Análise"),
    EM_EXECUCAO("Em Execução"),
    CONCLUIDA("Concluída"),
    CANCELADA("Cancelada");

    private final String descricao;

    StatusSolicitacao(String descricao) {
        this.descricao = descricao;
    }

    public String getDescricao() {
        return descricao;
    }
}
