package br.gov.sp.centralcidadao.service;

import br.gov.sp.centralcidadao.domain.*;
import br.gov.sp.centralcidadao.dto.SolicitacaoServicoDTO;
import br.gov.sp.centralcidadao.repository.CidadaoRepository;
import br.gov.sp.centralcidadao.repository.SolicitacaoServicoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SolicitacaoServicoService {

    private final SolicitacaoServicoRepository solicitacaoRepository;
    private final CidadaoRepository cidadaoRepository;
    private final NotificacaoService notificacaoService;

    public List<SolicitacaoServicoDTO> listarTodas() {
        return solicitacaoRepository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public SolicitacaoServicoDTO buscarPorId(Long id) {
        SolicitacaoServico solicitacao = solicitacaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Solicitação não encontrada: " + id));
        return toDTO(solicitacao);
    }

    public SolicitacaoServicoDTO buscarPorProtocolo(String protocolo) {
        SolicitacaoServico solicitacao = solicitacaoRepository.findByProtocolo(protocolo)
                .orElseThrow(() -> new RuntimeException("Solicitação não encontrada com protocolo: " + protocolo));
        return toDTO(solicitacao);
    }

    public List<SolicitacaoServicoDTO> listarPorCidadao(Long cidadaoId) {
        return solicitacaoRepository.findByCidadaoIdOrderByDataSolicitacaoDesc(cidadaoId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<SolicitacaoServicoDTO> listarPorTipo(TipoServico tipo) {
        return solicitacaoRepository.findByTipoServico(tipo).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<SolicitacaoServicoDTO> listarPorStatus(StatusSolicitacao status) {
        return solicitacaoRepository.findByStatus(status).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public SolicitacaoServicoDTO criar(SolicitacaoServicoDTO dto) {
        Cidadao cidadao = cidadaoRepository.findById(dto.getCidadaoId())
                .orElseThrow(() -> new RuntimeException("Cidadão não encontrado: " + dto.getCidadaoId()));

        SolicitacaoServico solicitacao = new SolicitacaoServico();
        solicitacao.setCidadao(cidadao);
        solicitacao.setTipoServico(dto.getTipoServico());
        solicitacao.setDescricao(dto.getDescricao());
        solicitacao.setEndereco(dto.getEndereco());
        solicitacao.setBairro(dto.getBairro());
        solicitacao.setPontoReferencia(dto.getPontoReferencia());
        solicitacao.setLatitude(dto.getLatitude());
        solicitacao.setLongitude(dto.getLongitude());
        solicitacao.setFotoUrl(dto.getFotoUrl());
        solicitacao.setStatus(StatusSolicitacao.ABERTA);
        solicitacao.setPrioridade(dto.getPrioridade() != null ? dto.getPrioridade() : Prioridade.MEDIA);

        solicitacao = solicitacaoRepository.save(solicitacao);

        // Criar notificação
        notificacaoService.criarNotificacao(
                cidadao.getId(),
                "Solicitação Registrada",
                "Sua solicitação de " + dto.getTipoServico().getDescricao() + 
                    " foi registrada com protocolo " + solicitacao.getProtocolo(),
                TipoNotificacao.SUCESSO
        );

        return toDTO(solicitacao);
    }

    @Transactional
    public SolicitacaoServicoDTO atualizarStatus(Long id, StatusSolicitacao novoStatus) {
        SolicitacaoServico solicitacao = solicitacaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Solicitação não encontrada: " + id));

        solicitacao.setStatus(novoStatus);

        if (novoStatus == StatusSolicitacao.CONCLUIDA) {
            solicitacao.setDataConclusao(LocalDateTime.now());
        }

        solicitacao = solicitacaoRepository.save(solicitacao);

        // Criar notificação
        notificacaoService.criarNotificacao(
                solicitacao.getCidadao().getId(),
                "Status da Solicitação Atualizado",
                "Sua solicitação " + solicitacao.getProtocolo() + " foi atualizada para: " + novoStatus.getDescricao(),
                TipoNotificacao.INFO
        );

        return toDTO(solicitacao);
    }

    private SolicitacaoServicoDTO toDTO(SolicitacaoServico solicitacao) {
        SolicitacaoServicoDTO dto = new SolicitacaoServicoDTO();
        dto.setId(solicitacao.getId());
        dto.setProtocolo(solicitacao.getProtocolo());
        dto.setCidadaoId(solicitacao.getCidadao().getId());
        dto.setCidadaoNome(solicitacao.getCidadao().getNome());
        dto.setTipoServico(solicitacao.getTipoServico());
        dto.setTipoServicoDescricao(solicitacao.getTipoServico().getDescricao());
        dto.setDescricao(solicitacao.getDescricao());
        dto.setEndereco(solicitacao.getEndereco());
        dto.setBairro(solicitacao.getBairro());
        dto.setPontoReferencia(solicitacao.getPontoReferencia());
        dto.setLatitude(solicitacao.getLatitude());
        dto.setLongitude(solicitacao.getLongitude());
        dto.setFotoUrl(solicitacao.getFotoUrl());
        dto.setStatus(solicitacao.getStatus());
        dto.setStatusDescricao(solicitacao.getStatus().getDescricao());
        dto.setPrioridade(solicitacao.getPrioridade());
        dto.setPrioridadeDescricao(solicitacao.getPrioridade().getDescricao());
        dto.setDataSolicitacao(solicitacao.getDataSolicitacao());
        dto.setDataAtualizacao(solicitacao.getDataAtualizacao());
        dto.setDataConclusao(solicitacao.getDataConclusao());
        return dto;
    }
}
