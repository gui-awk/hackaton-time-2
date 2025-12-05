package br.gov.sp.centralcidadao.repository;

import br.gov.sp.centralcidadao.domain.Notificacao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificacaoRepository extends JpaRepository<Notificacao, Long> {
    
    List<Notificacao> findByCidadaoIdOrderByDataCriacaoDesc(Long cidadaoId);
    
    List<Notificacao> findByCidadaoIdAndLidaFalseOrderByDataCriacaoDesc(Long cidadaoId);
    
    long countByCidadaoIdAndLidaFalse(Long cidadaoId);
    
    @Modifying
    @Query("UPDATE Notificacao n SET n.lida = true WHERE n.cidadao.id = :cidadaoId")
    void marcarTodasComoLidas(Long cidadaoId);
}
