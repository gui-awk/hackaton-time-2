package br.gov.sp.centralcidadao.controller;

import br.gov.sp.centralcidadao.dto.NotificacaoDTO;
import br.gov.sp.centralcidadao.service.NotificacaoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notificacoes")
@RequiredArgsConstructor
@Tag(name = "Notificações", description = "Gerenciamento de notificações")
@CrossOrigin(origins = "*")
public class NotificacaoController {

    private final NotificacaoService notificacaoService;

    @GetMapping("/cidadao/{cidadaoId}")
    @Operation(summary = "Listar notificações de um cidadão")
    public ResponseEntity<List<NotificacaoDTO>> listarPorCidadao(@PathVariable Long cidadaoId) {
        return ResponseEntity.ok(notificacaoService.listarPorCidadao(cidadaoId));
    }

    @GetMapping("/cidadao/{cidadaoId}/nao-lidas")
    @Operation(summary = "Listar notificações não lidas de um cidadão")
    public ResponseEntity<List<NotificacaoDTO>> listarNaoLidasPorCidadao(@PathVariable Long cidadaoId) {
        return ResponseEntity.ok(notificacaoService.listarNaoLidasPorCidadao(cidadaoId));
    }

    @GetMapping("/cidadao/{cidadaoId}/contador")
    @Operation(summary = "Contar notificações não lidas de um cidadão")
    public ResponseEntity<Map<String, Long>> contarNaoLidas(@PathVariable Long cidadaoId) {
        long count = notificacaoService.contarNaoLidas(cidadaoId);
        return ResponseEntity.ok(Map.of("count", count));
    }

    @PatchMapping("/{id}/lida")
    @Operation(summary = "Marcar notificação como lida")
    public ResponseEntity<NotificacaoDTO> marcarComoLida(@PathVariable Long id) {
        return ResponseEntity.ok(notificacaoService.marcarComoLida(id));
    }

    @PatchMapping("/cidadao/{cidadaoId}/marcar-todas-lidas")
    @Operation(summary = "Marcar todas as notificações de um cidadão como lidas")
    public ResponseEntity<Void> marcarTodasComoLidas(@PathVariable Long cidadaoId) {
        notificacaoService.marcarTodasComoLidas(cidadaoId);
        return ResponseEntity.noContent().build();
    }
}
