package br.gov.sp.centralcidadao.repository;

import br.gov.sp.centralcidadao.domain.Escola;
import br.gov.sp.centralcidadao.domain.NivelEnsino;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EscolaRepository extends JpaRepository<Escola, Long> {
    
    List<Escola> findByAtivoTrue();
    
    List<Escola> findByNivelEnsino(NivelEnsino nivelEnsino);
    
    List<Escola> findByBairroContainingIgnoreCase(String bairro);
    
    List<Escola> findByNivelEnsinoAndAtivoTrue(NivelEnsino nivelEnsino);
    
    @Query("SELECT e FROM Escola e WHERE e.ativo = true AND (e.vagasTotais - e.vagasOcupadas) > 0")
    List<Escola> findEscolasComVagasDisponiveis();
    
    @Query("SELECT e FROM Escola e WHERE e.ativo = true AND e.nivelEnsino = :nivel AND (e.vagasTotais - e.vagasOcupadas) > 0")
    List<Escola> findEscolasComVagasDisponiveisByNivel(NivelEnsino nivel);
    
    List<Escola> findByNomeContainingIgnoreCase(String nome);
}
