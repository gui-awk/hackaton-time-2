package br.gov.sp.centralcidadao.domain;

public enum TipoServico {
    PODA("Poda de Árvore"),
    ILUMINACAO("Iluminação Pública"),
    OBRAS("Obras e Reparos"),
    LIMPEZA("Limpeza Urbana");

    private final String descricao;

    TipoServico(String descricao) {
        this.descricao = descricao;
    }

    public String getDescricao() {
        return descricao;
    }
}
