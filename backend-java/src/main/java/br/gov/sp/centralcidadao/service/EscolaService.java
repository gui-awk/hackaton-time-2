package br.gov.sp.centralcidadao.service;

import br.gov.sp.centralcidadao.domain.Escola;
import br.gov.sp.centralcidadao.domain.NivelEnsino;
import br.gov.sp.centralcidadao.dto.EscolaDTO;
import br.gov.sp.centralcidadao.repository.EscolaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EscolaService {

    private final EscolaRepository escolaRepository;

    public List<EscolaDTO> listarTodas() {
        return escolaRepository.findByAtivoTrue().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public EscolaDTO buscarPorId(Long id) {
        Escola escola = escolaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Escola não encontrada: " + id));
        return toDTO(escola);
    }

    public List<EscolaDTO> buscarPorNivel(NivelEnsino nivel) {
        return escolaRepository.findByNivelEnsinoAndAtivoTrue(nivel).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<EscolaDTO> buscarPorBairro(String bairro) {
        return escolaRepository.findByBairroContainingIgnoreCase(bairro).stream()
                .filter(Escola::getAtivo)
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<EscolaDTO> buscarPorNome(String nome) {
        return escolaRepository.findByNomeContainingIgnoreCase(nome).stream()
                .filter(Escola::getAtivo)
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<EscolaDTO> buscarComVagasDisponiveis() {
        return escolaRepository.findEscolasComVagasDisponiveis().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<EscolaDTO> buscarComVagasDisponiveisPorNivel(NivelEnsino nivel) {
        return escolaRepository.findEscolasComVagasDisponiveisByNivel(nivel).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    private EscolaDTO toDTO(Escola escola) {
        EscolaDTO dto = new EscolaDTO();
        dto.setId(escola.getId());
        dto.setNome(escola.getNome());
        dto.setEndereco(escola.getEndereco());
        dto.setBairro(escola.getBairro());
        dto.setCidade(escola.getCidade());
        dto.setTelefone(escola.getTelefone());
        dto.setNivelEnsino(escola.getNivelEnsino());
        dto.setNivelEnsinoDescricao(escola.getNivelEnsino().getDescricao());
        dto.setVagasTotais(escola.getVagasTotais());
        dto.setVagasOcupadas(escola.getVagasOcupadas());
        dto.setVagasDisponiveis(escola.getVagasDisponiveis());
        dto.setPercentualOcupacao(escola.getPercentualOcupacao());
        dto.setStatusVagas(calcularStatusVagas(escola));
        return dto;
    }

    private String calcularStatusVagas(Escola escola) {
        int disponiveis = escola.getVagasDisponiveis();
        double percentual = escola.getPercentualOcupacao();

        if (disponiveis <= 0) {
            return "LOTADO";
        } else if (percentual >= 80) {
            return "LIMITADO";
        } else {
            return "DISPONIVEL";
        }
    }
}
