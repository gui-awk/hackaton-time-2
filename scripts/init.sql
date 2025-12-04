-- ============================================
-- Central do Cidadão - Script de Inicialização
-- Banco de Dados MySQL
-- ============================================

-- Usar o banco de dados
USE central_cidadao;

-- ============================================
-- TABELA: cidadaos
-- Armazena dados dos cidadãos/usuários
-- ============================================
CREATE TABLE IF NOT EXISTS cidadaos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cep VARCHAR(10),
    endereco VARCHAR(255),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: escolas
-- Cadastro de escolas municipais
-- ============================================
CREATE TABLE IF NOT EXISTS escolas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    telefone VARCHAR(20),
    nivel_ensino ENUM('INFANTIL', 'FUNDAMENTAL_I', 'FUNDAMENTAL_II', 'MEDIO') NOT NULL,
    vagas_totais INT DEFAULT 0,
    vagas_ocupadas INT DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: matriculas
-- Solicitações de matrícula escolar
-- ============================================
CREATE TABLE IF NOT EXISTS matriculas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    protocolo VARCHAR(20) UNIQUE NOT NULL,
    cidadao_id BIGINT NOT NULL,
    escola_id BIGINT NOT NULL,
    nome_aluno VARCHAR(255) NOT NULL,
    data_nascimento DATE,
    nivel_ensino ENUM('INFANTIL', 'FUNDAMENTAL_I', 'FUNDAMENTAL_II', 'MEDIO') NOT NULL,
    serie VARCHAR(50),
    status ENUM('PENDENTE', 'EM_ANALISE', 'APROVADA', 'REJEITADA', 'CANCELADA') DEFAULT 'PENDENTE',
    observacoes TEXT,
    data_solicitacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cidadao_id) REFERENCES cidadaos(id) ON DELETE CASCADE,
    FOREIGN KEY (escola_id) REFERENCES escolas(id) ON DELETE CASCADE
);

-- ============================================
-- TABELA: solicitacoes_servicos
-- Solicitações de serviços urbanos
-- ============================================
CREATE TABLE IF NOT EXISTS solicitacoes_servicos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    protocolo VARCHAR(20) UNIQUE NOT NULL,
    cidadao_id BIGINT NOT NULL,
    tipo_servico ENUM('PODA', 'ILUMINACAO', 'OBRAS', 'LIMPEZA') NOT NULL,
    descricao TEXT NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    bairro VARCHAR(100),
    ponto_referencia VARCHAR(255),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    foto_url VARCHAR(500),
    status ENUM('ABERTA', 'EM_ANALISE', 'EM_EXECUCAO', 'CONCLUIDA', 'CANCELADA') DEFAULT 'ABERTA',
    prioridade ENUM('BAIXA', 'MEDIA', 'ALTA', 'URGENTE') DEFAULT 'MEDIA',
    data_solicitacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_conclusao DATETIME,
    FOREIGN KEY (cidadao_id) REFERENCES cidadaos(id) ON DELETE CASCADE
);

-- ============================================
-- TABELA: historico_status
-- Histórico de alterações de status (Timeline)
-- ============================================
CREATE TABLE IF NOT EXISTS historico_status (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tipo_registro ENUM('MATRICULA', 'SERVICO') NOT NULL,
    registro_id BIGINT NOT NULL,
    status_anterior VARCHAR(50),
    status_novo VARCHAR(50) NOT NULL,
    observacao TEXT,
    usuario_responsavel VARCHAR(255),
    data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABELA: notificacoes
-- Notificações para os cidadãos
-- ============================================
CREATE TABLE IF NOT EXISTS notificacoes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cidadao_id BIGINT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    mensagem TEXT NOT NULL,
    tipo ENUM('INFO', 'ALERTA', 'SUCESSO', 'ERRO') DEFAULT 'INFO',
    lida BOOLEAN DEFAULT FALSE,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cidadao_id) REFERENCES cidadaos(id) ON DELETE CASCADE
);

-- ============================================
-- ÍNDICES PARA OTIMIZAÇÃO
-- ============================================
CREATE INDEX idx_matriculas_cidadao ON matriculas(cidadao_id);
CREATE INDEX idx_matriculas_status ON matriculas(status);
CREATE INDEX idx_matriculas_protocolo ON matriculas(protocolo);
CREATE INDEX idx_solicitacoes_cidadao ON solicitacoes_servicos(cidadao_id);
CREATE INDEX idx_solicitacoes_status ON solicitacoes_servicos(status);
CREATE INDEX idx_solicitacoes_tipo ON solicitacoes_servicos(tipo_servico);
CREATE INDEX idx_solicitacoes_protocolo ON solicitacoes_servicos(protocolo);
CREATE INDEX idx_notificacoes_cidadao ON notificacoes(cidadao_id);
CREATE INDEX idx_notificacoes_lida ON notificacoes(lida);
CREATE INDEX idx_historico_registro ON historico_status(tipo_registro, registro_id);

-- ============================================
-- DADOS INICIAIS (SEEDS)
-- ============================================

-- Inserir cidadão de exemplo
INSERT INTO cidadaos (nome, cpf, email, telefone, cep, endereco, numero, complemento, bairro, cidade, estado) VALUES
('Maria da Silva', '123.456.789-00', 'maria.silva@email.com', '(11) 99999-8888', '12345-678', 'Rua das Flores', '123', 'Apto 45', 'Centro', 'São Paulo', 'SP'),
('João Santos', '987.654.321-00', 'joao.santos@email.com', '(11) 98888-7777', '12345-679', 'Av. Principal', '456', NULL, 'Jardim América', 'São Paulo', 'SP'),
('Ana Oliveira', '111.222.333-44', 'ana.oliveira@email.com', '(11) 97777-6666', '12345-680', 'Rua das Palmeiras', '789', 'Casa 2', 'Vila Nova', 'São Paulo', 'SP');

-- Inserir escolas de exemplo
INSERT INTO escolas (nome, endereco, bairro, cidade, telefone, nivel_ensino, vagas_totais, vagas_ocupadas) VALUES
('EMEI Monteiro Lobato', 'Rua das Crianças, 100', 'Centro', 'São Paulo', '(11) 3333-1111', 'INFANTIL', 120, 95),
('EMEI Cecília Meireles', 'Av. da Educação, 200', 'Jardim América', 'São Paulo', '(11) 3333-2222', 'INFANTIL', 100, 100),
('EMEF Paulo Freire', 'Rua do Saber, 300', 'Vila Nova', 'São Paulo', '(11) 3333-3333', 'FUNDAMENTAL_I', 200, 150),
('EMEF Anísio Teixeira', 'Av. do Conhecimento, 400', 'Centro', 'São Paulo', '(11) 3333-4444', 'FUNDAMENTAL_I', 180, 120),
('EMEF Darcy Ribeiro', 'Rua da Ciência, 500', 'Jardim Europa', 'São Paulo', '(11) 3333-5555', 'FUNDAMENTAL_II', 250, 200),
('EE Machado de Assis', 'Av. das Letras, 600', 'Centro', 'São Paulo', '(11) 3333-6666', 'MEDIO', 300, 280);

-- Inserir notificações de boas-vindas
INSERT INTO notificacoes (cidadao_id, titulo, mensagem, tipo) VALUES
(1, 'Bem-vindo à Central do Cidadão!', 'Acesse todos os serviços públicos em um único lugar.', 'INFO'),
(1, 'Matrículas 2026 Abertas', 'O período de matrículas para 2026 está aberto. Não perca o prazo!', 'ALERTA'),
(2, 'Bem-vindo à Central do Cidadão!', 'Acesse todos os serviços públicos em um único lugar.', 'INFO'),
(3, 'Bem-vindo à Central do Cidadão!', 'Acesse todos os serviços públicos em um único lugar.', 'INFO');

-- ============================================
-- FIM DO SCRIPT
-- ============================================
