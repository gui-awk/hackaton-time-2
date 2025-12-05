package br.gov.sp.centralcidadao.controller;

import br.gov.sp.centralcidadao.dto.CidadaoDTO;
import br.gov.sp.centralcidadao.service.CidadaoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cidadaos")
@RequiredArgsConstructor
@Tag(name = "Cidadãos", description = "Gerenciamento de cidadãos")
@CrossOrigin(origins = "*")
public class CidadaoController {

    private final CidadaoService cidadaoService;

    @GetMapping
    @Operation(summary = "Listar todos os cidadãos")
    public ResponseEntity<List<CidadaoDTO>> listarTodos() {
        return ResponseEntity.ok(cidadaoService.listarTodos());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Buscar cidadão por ID")
    public ResponseEntity<CidadaoDTO> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(cidadaoService.buscarPorId(id));
    }

    @GetMapping("/cpf/{cpf}")
    @Operation(summary = "Buscar cidadão por CPF")
    public ResponseEntity<CidadaoDTO> buscarPorCpf(@PathVariable String cpf) {
        return ResponseEntity.ok(cidadaoService.buscarPorCpf(cpf));
    }

    @PostMapping
    @Operation(summary = "Cadastrar novo cidadão")
    public ResponseEntity<CidadaoDTO> criar(@Valid @RequestBody CidadaoDTO dto) {
        CidadaoDTO criado = cidadaoService.criar(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criado);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Atualizar dados do cidadão")
    public ResponseEntity<CidadaoDTO> atualizar(@PathVariable Long id, @Valid @RequestBody CidadaoDTO dto) {
        return ResponseEntity.ok(cidadaoService.atualizar(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Remover cidadão")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        cidadaoService.deletar(id);
        return ResponseEntity.noContent().build();
    }
}
