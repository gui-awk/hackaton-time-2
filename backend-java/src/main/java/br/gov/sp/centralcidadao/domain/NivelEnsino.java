package br.gov.sp.centralcidadao.domain;

public enum NivelEnsino {
    INFANTIL("Educação Infantil"),
    FUNDAMENTAL_I("Ensino Fundamental I"),
    FUNDAMENTAL_II("Ensino Fundamental II"),
    MEDIO("Ensino Médio");

    private final String descricao;

    NivelEnsino(String descricao) {
        this.descricao = descricao;
    }

    public String getDescricao() {
        return descricao;
    }
}
