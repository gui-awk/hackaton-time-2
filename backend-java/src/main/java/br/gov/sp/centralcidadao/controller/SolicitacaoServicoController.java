package br.gov.sp.centralcidadao.controller;

import br.gov.sp.centralcidadao.domain.StatusSolicitacao;
import br.gov.sp.centralcidadao.domain.TipoServico;
import br.gov.sp.centralcidadao.dto.SolicitacaoServicoDTO;
import br.gov.sp.centralcidadao.service.SolicitacaoServicoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/solicitacoes")
@RequiredArgsConstructor
@Tag(name = "Solicitações de Serviços", description = "Gerenciamento de solicitações de serviços urbanos")
@CrossOrigin(origins = "*")
public class SolicitacaoServicoController {

    private final SolicitacaoServicoService solicitacaoService;

    @GetMapping
    @Operation(summary = "Listar todas as solicitações")
    public ResponseEntity<List<SolicitacaoServicoDTO>> listarTodas() {
        return ResponseEntity.ok(solicitacaoService.listarTodas());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Buscar solicitação por ID")
    public ResponseEntity<SolicitacaoServicoDTO> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(solicitacaoService.buscarPorId(id));
    }

    @GetMapping("/protocolo/{protocolo}")
    @Operation(summary = "Buscar solicitação por protocolo")
    public ResponseEntity<SolicitacaoServicoDTO> buscarPorProtocolo(@PathVariable String protocolo) {
        return ResponseEntity.ok(solicitacaoService.buscarPorProtocolo(protocolo));
    }

    @GetMapping("/cidadao/{cidadaoId}")
    @Operation(summary = "Listar solicitações de um cidadão")
    public ResponseEntity<List<SolicitacaoServicoDTO>> listarPorCidadao(@PathVariable Long cidadaoId) {
        return ResponseEntity.ok(solicitacaoService.listarPorCidadao(cidadaoId));
    }

    @GetMapping("/tipo/{tipo}")
    @Operation(summary = "Listar solicitações por tipo de serviço")
    public ResponseEntity<List<SolicitacaoServicoDTO>> listarPorTipo(@PathVariable TipoServico tipo) {
        return ResponseEntity.ok(solicitacaoService.listarPorTipo(tipo));
    }

    @GetMapping("/status/{status}")
    @Operation(summary = "Listar solicitações por status")
    public ResponseEntity<List<SolicitacaoServicoDTO>> listarPorStatus(@PathVariable StatusSolicitacao status) {
        return ResponseEntity.ok(solicitacaoService.listarPorStatus(status));
    }

    @PostMapping
    @Operation(summary = "Criar nova solicitação de serviço")
    public ResponseEntity<SolicitacaoServicoDTO> criar(@Valid @RequestBody SolicitacaoServicoDTO dto) {
        SolicitacaoServicoDTO criada = solicitacaoService.criar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criada);
    }

    @PatchMapping("/{id}/status/{status}")
    @Operation(summary = "Atualizar status da solicitação")
    public ResponseEntity<SolicitacaoServicoDTO> atualizarStatus(
            @PathVariable Long id,
            @PathVariable StatusSolicitacao status) {
        return ResponseEntity.ok(solicitacaoService.atualizarStatus(id, status));
    }
}
