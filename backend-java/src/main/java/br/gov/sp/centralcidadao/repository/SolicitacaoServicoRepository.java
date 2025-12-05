package br.gov.sp.centralcidadao.repository;

import br.gov.sp.centralcidadao.domain.SolicitacaoServico;
import br.gov.sp.centralcidadao.domain.StatusSolicitacao;
import br.gov.sp.centralcidadao.domain.TipoServico;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SolicitacaoServicoRepository extends JpaRepository<SolicitacaoServico, Long> {
    
    Optional<SolicitacaoServico> findByProtocolo(String protocolo);
    
    List<SolicitacaoServico> findByCidadaoId(Long cidadaoId);
    
    List<SolicitacaoServico> findByCidadaoIdOrderByDataSolicitacaoDesc(Long cidadaoId);
    
    List<SolicitacaoServico> findByTipoServico(TipoServico tipoServico);
    
    List<SolicitacaoServico> findByStatus(StatusSolicitacao status);
    
    List<SolicitacaoServico> findByCidadaoIdAndStatus(Long cidadaoId, StatusSolicitacao status);
    
    List<SolicitacaoServico> findByBairroContainingIgnoreCase(String bairro);
    
    boolean existsByProtocolo(String protocolo);
}
