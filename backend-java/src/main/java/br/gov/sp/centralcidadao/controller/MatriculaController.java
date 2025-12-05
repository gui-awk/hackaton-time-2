package br.gov.sp.centralcidadao.controller;

import br.gov.sp.centralcidadao.domain.StatusMatricula;
import br.gov.sp.centralcidadao.dto.MatriculaDTO;
import br.gov.sp.centralcidadao.service.MatriculaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/matriculas")
@RequiredArgsConstructor
@Tag(name = "Matrículas", description = "Gerenciamento de matrículas escolares")
@CrossOrigin(origins = "*")
public class MatriculaController {

    private final MatriculaService matriculaService;

    @GetMapping
    @Operation(summary = "Listar todas as matrículas")
    public ResponseEntity<List<MatriculaDTO>> listarTodas() {
        return ResponseEntity.ok(matriculaService.listarTodas());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Buscar matrícula por ID")
    public ResponseEntity<MatriculaDTO> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(matriculaService.buscarPorId(id));
    }

    @GetMapping("/protocolo/{protocolo}")
    @Operation(summary = "Buscar matrícula por protocolo")
    public ResponseEntity<MatriculaDTO> buscarPorProtocolo(@PathVariable String protocolo) {
        return ResponseEntity.ok(matriculaService.buscarPorProtocolo(protocolo));
    }

    @GetMapping("/cidadao/{cidadaoId}")
    @Operation(summary = "Listar matrículas de um cidadão")
    public ResponseEntity<List<MatriculaDTO>> listarPorCidadao(@PathVariable Long cidadaoId) {
        return ResponseEntity.ok(matriculaService.listarPorCidadao(cidadaoId));
    }

    @GetMapping("/status/{status}")
    @Operation(summary = "Listar matrículas por status")
    public ResponseEntity<List<MatriculaDTO>> listarPorStatus(@PathVariable StatusMatricula status) {
        return ResponseEntity.ok(matriculaService.listarPorStatus(status));
    }

    @PostMapping
    @Operation(summary = "Solicitar nova matrícula")
    public ResponseEntity<MatriculaDTO> criar(@Valid @RequestBody MatriculaDTO dto) {
        MatriculaDTO criada = matriculaService.criar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criada);
    }

    @PatchMapping("/{id}/status/{status}")
    @Operation(summary = "Atualizar status da matrícula")
    public ResponseEntity<MatriculaDTO> atualizarStatus(
            @PathVariable Long id,
            @PathVariable StatusMatricula status) {
        return ResponseEntity.ok(matriculaService.atualizarStatus(id, status));
    }
}
