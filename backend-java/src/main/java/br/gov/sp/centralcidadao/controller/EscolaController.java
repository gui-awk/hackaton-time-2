package br.gov.sp.centralcidadao.controller;

import br.gov.sp.centralcidadao.domain.NivelEnsino;
import br.gov.sp.centralcidadao.dto.EscolaDTO;
import br.gov.sp.centralcidadao.service.EscolaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/escolas")
@RequiredArgsConstructor
@Tag(name = "Escolas", description = "Consulta de escolas e vagas")
@CrossOrigin(origins = "*")
public class EscolaController {

    private final EscolaService escolaService;

    @GetMapping
    @Operation(summary = "Listar todas as escolas ativas")
    public ResponseEntity<List<EscolaDTO>> listarTodas() {
        return ResponseEntity.ok(escolaService.listarTodas());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Buscar escola por ID")
    public ResponseEntity<EscolaDTO> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(escolaService.buscarPorId(id));
    }

    @GetMapping("/nivel/{nivel}")
    @Operation(summary = "Buscar escolas por nível de ensino")
    public ResponseEntity<List<EscolaDTO>> buscarPorNivel(@PathVariable NivelEnsino nivel) {
        return ResponseEntity.ok(escolaService.buscarPorNivel(nivel));
    }

    @GetMapping("/bairro/{bairro}")
    @Operation(summary = "Buscar escolas por bairro")
    public ResponseEntity<List<EscolaDTO>> buscarPorBairro(@PathVariable String bairro) {
        return ResponseEntity.ok(escolaService.buscarPorBairro(bairro));
    }

    @GetMapping("/nome/{nome}")
    @Operation(summary = "Buscar escolas por nome")
    public ResponseEntity<List<EscolaDTO>> buscarPorNome(@PathVariable String nome) {
        return ResponseEntity.ok(escolaService.buscarPorNome(nome));
    }

    @GetMapping("/vagas-disponiveis")
    @Operation(summary = "Listar escolas com vagas disponíveis")
    public ResponseEntity<List<EscolaDTO>> buscarComVagasDisponiveis() {
        return ResponseEntity.ok(escolaService.buscarComVagasDisponiveis());
    }

    @GetMapping("/vagas-disponiveis/nivel/{nivel}")
    @Operation(summary = "Listar escolas com vagas disponíveis por nível")
    public ResponseEntity<List<EscolaDTO>> buscarComVagasDisponiveisPorNivel(@PathVariable NivelEnsino nivel) {
        return ResponseEntity.ok(escolaService.buscarComVagasDisponiveisPorNivel(nivel));
    }
}
