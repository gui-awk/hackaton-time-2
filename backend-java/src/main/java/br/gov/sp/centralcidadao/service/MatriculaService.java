package br.gov.sp.centralcidadao.service;

import br.gov.sp.centralcidadao.domain.*;
import br.gov.sp.centralcidadao.dto.MatriculaDTO;
import br.gov.sp.centralcidadao.repository.CidadaoRepository;
import br.gov.sp.centralcidadao.repository.EscolaRepository;
import br.gov.sp.centralcidadao.repository.MatriculaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MatriculaService {

    private final MatriculaRepository matriculaRepository;
    private final CidadaoRepository cidadaoRepository;
    private final EscolaRepository escolaRepository;
    private final NotificacaoService notificacaoService;

    public List<MatriculaDTO> listarTodas() {
        return matriculaRepository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public MatriculaDTO buscarPorId(Long id) {
        Matricula matricula = matriculaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Matrícula não encontrada: " + id));
        return toDTO(matricula);
    }

    public MatriculaDTO buscarPorProtocolo(String protocolo) {
        Matricula matricula = matriculaRepository.findByProtocolo(protocolo)
                .orElseThrow(() -> new RuntimeException("Matrícula não encontrada com protocolo: " + protocolo));
        return toDTO(matricula);
    }

    public List<MatriculaDTO> listarPorCidadao(Long cidadaoId) {
        return matriculaRepository.findByCidadaoIdOrderByDataSolicitacaoDesc(cidadaoId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<MatriculaDTO> listarPorStatus(StatusMatricula status) {
        return matriculaRepository.findByStatus(status).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public MatriculaDTO criar(MatriculaDTO dto) {
        Cidadao cidadao = cidadaoRepository.findById(dto.getCidadaoId())
                .orElseThrow(() -> new RuntimeException("Cidadão não encontrado: " + dto.getCidadaoId()));

        Escola escola = escolaRepository.findById(dto.getEscolaId())
                .orElseThrow(() -> new RuntimeException("Escola não encontrada: " + dto.getEscolaId()));

        // Verificar vagas disponíveis
        if (escola.getVagasDisponiveis() <= 0) {
            throw new RuntimeException("Escola sem vagas disponíveis: " + escola.getNome());
        }

        Matricula matricula = new Matricula();
        matricula.setCidadao(cidadao);
        matricula.setEscola(escola);
        matricula.setNomeAluno(dto.getNomeAluno());
        matricula.setDataNascimento(dto.getDataNascimento());
        matricula.setNivelEnsino(dto.getNivelEnsino());
        matricula.setSerie(dto.getSerie());
        matricula.setObservacoes(dto.getObservacoes());
        matricula.setStatus(StatusMatricula.PENDENTE);

        matricula = matriculaRepository.save(matricula);

        // Criar notificação
        notificacaoService.criarNotificacao(
                cidadao.getId(),
                "Matrícula Registrada",
                "Sua solicitação de matrícula foi registrada com protocolo " + matricula.getProtocolo(),
                TipoNotificacao.SUCESSO
        );

        return toDTO(matricula);
    }

    @Transactional
    public MatriculaDTO atualizarStatus(Long id, StatusMatricula novoStatus) {
        Matricula matricula = matriculaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Matrícula não encontrada: " + id));

        StatusMatricula statusAnterior = matricula.getStatus();
        matricula.setStatus(novoStatus);
        matricula = matriculaRepository.save(matricula);

        // Atualizar vagas da escola se aprovada
        if (novoStatus == StatusMatricula.APROVADA && statusAnterior != StatusMatricula.APROVADA) {
            Escola escola = matricula.getEscola();
            escola.setVagasOcupadas(escola.getVagasOcupadas() + 1);
            escolaRepository.save(escola);
        }

        // Criar notificação
        notificacaoService.criarNotificacao(
                matricula.getCidadao().getId(),
                "Status da Matrícula Atualizado",
                "Sua matrícula " + matricula.getProtocolo() + " foi atualizada para: " + novoStatus.getDescricao(),
                TipoNotificacao.INFO
        );

        return toDTO(matricula);
    }

    private MatriculaDTO toDTO(Matricula matricula) {
        MatriculaDTO dto = new MatriculaDTO();
        dto.setId(matricula.getId());
        dto.setProtocolo(matricula.getProtocolo());
        dto.setCidadaoId(matricula.getCidadao().getId());
        dto.setCidadaoNome(matricula.getCidadao().getNome());
        dto.setEscolaId(matricula.getEscola().getId());
        dto.setEscolaNome(matricula.getEscola().getNome());
        dto.setNomeAluno(matricula.getNomeAluno());
        dto.setDataNascimento(matricula.getDataNascimento());
        dto.setNivelEnsino(matricula.getNivelEnsino());
        dto.setNivelEnsinoDescricao(matricula.getNivelEnsino().getDescricao());
        dto.setSerie(matricula.getSerie());
        dto.setStatus(matricula.getStatus());
        dto.setStatusDescricao(matricula.getStatus().getDescricao());
        dto.setObservacoes(matricula.getObservacoes());
        dto.setDataSolicitacao(matricula.getDataSolicitacao());
        dto.setDataAtualizacao(matricula.getDataAtualizacao());
        return dto;
    }
}
