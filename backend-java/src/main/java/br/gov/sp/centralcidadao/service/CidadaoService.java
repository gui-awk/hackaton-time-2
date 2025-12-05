package br.gov.sp.centralcidadao.service;

import br.gov.sp.centralcidadao.domain.Cidadao;
import br.gov.sp.centralcidadao.dto.CidadaoDTO;
import br.gov.sp.centralcidadao.repository.CidadaoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CidadaoService {

    private final CidadaoRepository cidadaoRepository;

    public List<CidadaoDTO> listarTodos() {
        return cidadaoRepository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public CidadaoDTO buscarPorId(Long id) {
        Cidadao cidadao = cidadaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cidadão não encontrado: " + id));
        return toDTO(cidadao);
    }

    public CidadaoDTO buscarPorCpf(String cpf) {
        Cidadao cidadao = cidadaoRepository.findByCpf(cpf)
                .orElseThrow(() -> new RuntimeException("Cidadão não encontrado com CPF: " + cpf));
        return toDTO(cidadao);
    }

    @Transactional
    public CidadaoDTO criar(CidadaoDTO dto) {
        if (cidadaoRepository.existsByCpf(dto.getCpf())) {
            throw new RuntimeException("CPF já cadastrado: " + dto.getCpf());
        }
        if (cidadaoRepository.existsByEmail(dto.getEmail())) {
            throw new RuntimeException("Email já cadastrado: " + dto.getEmail());
        }

        Cidadao cidadao = toEntity(dto);
        cidadao = cidadaoRepository.save(cidadao);
        return toDTO(cidadao);
    }

    @Transactional
    public CidadaoDTO atualizar(Long id, CidadaoDTO dto) {
        Cidadao cidadao = cidadaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cidadão não encontrado: " + id));

        cidadao.setNome(dto.getNome());
        cidadao.setTelefone(dto.getTelefone());
        cidadao.setCep(dto.getCep());
        cidadao.setEndereco(dto.getEndereco());
        cidadao.setNumero(dto.getNumero());
        cidadao.setComplemento(dto.getComplemento());
        cidadao.setBairro(dto.getBairro());
        cidadao.setCidade(dto.getCidade());
        cidadao.setEstado(dto.getEstado());

        cidadao = cidadaoRepository.save(cidadao);
        return toDTO(cidadao);
    }

    @Transactional
    public void deletar(Long id) {
        if (!cidadaoRepository.existsById(id)) {
            throw new RuntimeException("Cidadão não encontrado: " + id);
        }
        cidadaoRepository.deleteById(id);
    }

    private CidadaoDTO toDTO(Cidadao cidadao) {
        CidadaoDTO dto = new CidadaoDTO();
        dto.setId(cidadao.getId());
        dto.setNome(cidadao.getNome());
        dto.setCpf(cidadao.getCpf());
        dto.setEmail(cidadao.getEmail());
        dto.setTelefone(cidadao.getTelefone());
        dto.setCep(cidadao.getCep());
        dto.setEndereco(cidadao.getEndereco());
        dto.setNumero(cidadao.getNumero());
        dto.setComplemento(cidadao.getComplemento());
        dto.setBairro(cidadao.getBairro());
        dto.setCidade(cidadao.getCidade());
        dto.setEstado(cidadao.getEstado());
        return dto;
    }

    private Cidadao toEntity(CidadaoDTO dto) {
        Cidadao cidadao = new Cidadao();
        cidadao.setNome(dto.getNome());
        cidadao.setCpf(dto.getCpf());
        cidadao.setEmail(dto.getEmail());
        cidadao.setTelefone(dto.getTelefone());
        cidadao.setCep(dto.getCep());
        cidadao.setEndereco(dto.getEndereco());
        cidadao.setNumero(dto.getNumero());
        cidadao.setComplemento(dto.getComplemento());
        cidadao.setBairro(dto.getBairro());
        cidadao.setCidade(dto.getCidade());
        cidadao.setEstado(dto.getEstado());
        return cidadao;
    }
}
