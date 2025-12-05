package br.gov.sp.centralcidadao.service;

import br.gov.sp.centralcidadao.domain.Cidadao;
import br.gov.sp.centralcidadao.domain.Notificacao;
import br.gov.sp.centralcidadao.domain.TipoNotificacao;
import br.gov.sp.centralcidadao.dto.NotificacaoDTO;
import br.gov.sp.centralcidadao.repository.CidadaoRepository;
import br.gov.sp.centralcidadao.repository.NotificacaoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NotificacaoService {

    private final NotificacaoRepository notificacaoRepository;
    private final CidadaoRepository cidadaoRepository;

    public List<NotificacaoDTO> listarPorCidadao(Long cidadaoId) {
        return notificacaoRepository.findByCidadaoIdOrderByDataCriacaoDesc(cidadaoId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<NotificacaoDTO> listarNaoLidasPorCidadao(Long cidadaoId) {
        return notificacaoRepository.findByCidadaoIdAndLidaFalseOrderByDataCriacaoDesc(cidadaoId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public long contarNaoLidas(Long cidadaoId) {
        return notificacaoRepository.countByCidadaoIdAndLidaFalse(cidadaoId);
    }

    @Transactional
    public NotificacaoDTO marcarComoLida(Long id) {
        Notificacao notificacao = notificacaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Notificação não encontrada: " + id));

        notificacao.setLida(true);
        notificacao = notificacaoRepository.save(notificacao);
        return toDTO(notificacao);
    }

    @Transactional
    public void marcarTodasComoLidas(Long cidadaoId) {
        notificacaoRepository.marcarTodasComoLidas(cidadaoId);
    }

    @Transactional
    public NotificacaoDTO criarNotificacao(Long cidadaoId, String titulo, String mensagem, TipoNotificacao tipo) {
        Cidadao cidadao = cidadaoRepository.findById(cidadaoId)
                .orElseThrow(() -> new RuntimeException("Cidadão não encontrado: " + cidadaoId));

        Notificacao notificacao = new Notificacao();
        notificacao.setCidadao(cidadao);
        notificacao.setTitulo(titulo);
        notificacao.setMensagem(mensagem);
        notificacao.setTipo(tipo);
        notificacao.setLida(false);

        notificacao = notificacaoRepository.save(notificacao);
        return toDTO(notificacao);
    }

    private NotificacaoDTO toDTO(Notificacao notificacao) {
        NotificacaoDTO dto = new NotificacaoDTO();
        dto.setId(notificacao.getId());
        dto.setCidadaoId(notificacao.getCidadao().getId());
        dto.setTitulo(notificacao.getTitulo());
        dto.setMensagem(notificacao.getMensagem());
        dto.setTipo(notificacao.getTipo());
        dto.setLida(notificacao.getLida());
        dto.setDataCriacao(notificacao.getDataCriacao());
        return dto;
    }
}
