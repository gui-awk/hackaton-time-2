package br.gov.sp.centralcidadao.repository;

import br.gov.sp.centralcidadao.domain.Cidadao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CidadaoRepository extends JpaRepository<Cidadao, Long> {
    
    Optional<Cidadao> findByCpf(String cpf);
    
    Optional<Cidadao> findByEmail(String email);
    
    boolean existsByCpf(String cpf);
    
    boolean existsByEmail(String email);
}
