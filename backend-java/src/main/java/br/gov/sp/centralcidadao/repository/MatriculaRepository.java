package br.gov.sp.centralcidadao.repository;

import br.gov.sp.centralcidadao.domain.Matricula;
import br.gov.sp.centralcidadao.domain.StatusMatricula;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MatriculaRepository extends JpaRepository<Matricula, Long> {
    
    Optional<Matricula> findByProtocolo(String protocolo);
    
    List<Matricula> findByCidadaoId(Long cidadaoId);
    
    List<Matricula> findByCidadaoIdOrderByDataSolicitacaoDesc(Long cidadaoId);
    
    List<Matricula> findByStatus(StatusMatricula status);
    
    List<Matricula> findByCidadaoIdAndStatus(Long cidadaoId, StatusMatricula status);
    
    List<Matricula> findByEscolaId(Long escolaId);
    
    boolean existsByProtocolo(String protocolo);
}
