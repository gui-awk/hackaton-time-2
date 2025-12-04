package br.gov.sp.centralcidadao.domain;

public enum TipoNotificacao {
    INFO("Informação"),
    ALERTA("Alerta"),
    SUCESSO("Sucesso"),
    ERRO("Erro");

    private final String descricao;

    TipoNotificacao(String descricao) {
        this.descricao = descricao;
    }

    public String getDescricao() {
        return descricao;
    }
}
