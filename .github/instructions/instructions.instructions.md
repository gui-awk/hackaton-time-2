# Copilot Instructions — Portal Integrado de Serviços Urbanos (Central do Cidadão)

Este documento orienta o GitHub Copilot (e outras IAs) ao gerar código, testes e documentação para este repositório.  
Projeto desenvolvido em contexto de **hackaton**.

---

## 1. Visão Geral do Projeto

**Tema:** Portal Integrado de Serviços Urbanos — *Central do Cidadão*  

### Contexto

Hoje, os serviços públicos da cidade estão espalhados em diferentes plataformas e canais.  
Para o cidadão isso gera:

- Dificuldade de acesso e consulta;
- Dúvida sobre “onde fazer o quê” (matrículas, vagas, protocolos, serviços urbanos);
- Dificuldade de entender processos e acompanhar solicitações;
- Dependência de canais presenciais, ligações, e-mails e contatos específicos.

O município busca **centralizar essas funcionalidades** em um **único ambiente simples e intuitivo**.

### Problema

O cidadão precisa navegar por **diversos sistemas diferentes** para resolver questões básicas, como:

- Matrícula escolar;
- Solicitações urbanas (poda, iluminação, obras, limpeza);
- Consultas de vagas;
- Acompanhamento de demandas.

Isso gera **confusão, atrasos e informações desencontradas**.

### Desafio do MVP

Desenvolver um **MVP de Central do Cidadão** que permita ao usuário:

- Realizar **matrícula escolar**;
- **Consultar disponibilidade de vagas**;
- **Abrir solicitações de serviços urbanos** (poda, iluminação, obras, limpeza etc.);
- **Acompanhar o status** das solicitações em tempo real (ou *quase* em tempo real, via simulação);
- **Receber informações** sobre atualizações importantes;
- **Consultar histórico de atendimentos**.

> **Foco:** entregar uma experiência **centralizada, clara e acessível**, mostrando como um único ponto de acesso simplifica a rotina do cidadão.

### Resultado Esperado

Um **protótipo funcional** que:

- Simule a **centralização dos serviços**;
- Demonstre o **fluxo de usuário** (da entrada à conclusão);
- Apresente **telas, navegação, lógica e funcionamento geral**;
- Não precisa ser totalmente integrado com sistemas reais (pode usar mocks / dados de exemplo), mas deve ser **coerente e extensível**.

---

## 2. Orientações Gerais para o Copilot

Quando for gerar código, documentação ou testes, Copilot deve:

1. **Preservar a visão de Central do Cidadão**  
   - Sempre pensar em fluxos unificados: o cidadão deve sentir que está em um **portal único**, não pulando entre sistemas diferentes.
   - Evitar termos muito técnicos na interface; preferir linguagem simples e direta.

2. **Priorizar experiência do cidadão (UX)**  
   - Criar telas claras, com passos simples (ex.: “1. Escolher escola” → “2. Dados do aluno” → “3. Confirmar inscrição”).
   - Usar textos e labels em **português**, pensados para cidadão comum (não para equipe técnica).

3. **Organizar o código para facilitar evolução pós-hackaton**  
   - Componentizar bem a UI (ex.: componentes para “Lista de Solicitações”, “Card de Protocolo”, “Linha do Tempo de Status”).
   - Separar lógica de domínio (matrículas, solicitações, histórico) da camada de apresentação.
   - Deixar pontos claros onde integrações reais poderão ser plugadas depois (ex.: camadas de `services/api`).

4. **Simular integrações externas de forma limpa**  
   - Ao precisar de dados (escolas, vagas, protocolos, status), usar:
     - Mocks,
     - JSON estáticos,
     - ou funções que retornam dados fictícios.
   - Documentar esses mocks para que possam ser substituídos por chamadas reais futuramente.

---

## 3. Funcionalidades-Chave que o Copilot deve Priorizar

Copilot deve ajudar a construir, documentar e testar principalmente:

### 3.1 Matrícula escolar

- Fluxo para o cidadão:
  - Selecionar nível/modalidade (ex.: Educação Infantil, Fundamental).
  - Escolher escola (ou listar escolas disponíveis).
  - Informar dados do aluno e responsável.
  - Confirmar solicitação de matrícula.
- Resultado esperado:
  - Um “protocolo de matrícula” com número identificador.
  - Tela de confirmação e opção de acompanhar posteriormente.

### 3.2 Consulta de vagas

- Tela/fluxo onde o usuário possa:
  - Escolher escola / região / nível;
  - Ver disponibilidade de vagas (simulada);
  - Ver status geral (ex.: “Alta procura”, “Vagas disponíveis”, “Lista de espera”).

### 3.3 Solicitações de serviços urbanos

- Tipos sugeridos:
  - Poda de árvore;
  - Iluminação pública;
  - Obras;
  - Limpeza urbana.
- Fluxo:
  - Selecionar tipo de serviço;
  - Informar localização/descrição;
  - (Opcional) anexar foto (pode ser apenas simulado);
  - Gerar protocolo da solicitação.

### 3.4 Acompanhamento de status em tempo real

- Tela de **“Minhas Solicitações”**:
  - Listar solicitações abertas, em andamento e concluídas;
  - Mostrar status com timeline (ex.: “Recebida”, “Em análise”, “Em execução”, “Concluída”).
- Atualização pode ser **simulada** (mock), mas arquitetura deve permitir futura integração com dados reais.

### 3.5 Notificações e atualizações importantes

- Exemplo:
  - Banner de aviso;
  - Lista de notificações recentes (“Sua solicitação X foi atualizada para ‘Em execução’”).
- Não precisa implementar push real, mas estruturar de forma extensível.

### 3.6 Histórico de atendimentos

- Tela com:
  - Lista cronológica de solicitações e matrículas;
  - Filtro por data, tipo de serviço ou status;
  - Exibição resumida (tipo, data, status) e detalhe ao clicar.

---

## 4. Padrões de Código e Organização (Guidelines)

Copilot deve seguir as diretrizes abaixo sempre que possível:

### 4.1 Estrutura sugerida (genérica)

> **Obs.:** O stack final pode variar; Copilot deve se adaptar aos arquivos existentes (Java, Flutter, C#). Caso o projeto ainda esteja vazio, sugerir uma estrutura limpa e modular com pastas separadas por tecnologia.

Possível organização em monorepo:

- `backend-java/`
- `backend-csharp/`
- `frontend-flutter/`
- `docs/`
  - `flows/` (descrição de fluxos de usuário)
  - `api/` (definição de contratos de dados, mesmo que mock)

### 4.2 Boas práticas esperadas

- Criar **funções pequenas e coesas**;
- Evitar duplicar lógica (ex.: formatação de status, datas, cores de status);
- Usar nomes descritivos em inglês no código (`CitizenRequest`, `EnrollmentService`), mas textos de interface em **português**;
- Comentar pontos importantes, principalmente:
  - Onde há simulação de dados;
  - Onde haverá futura integração com sistemas reais da prefeitura.

### 4.3 Testes e documentação

- Sempre que gerar trechos de lógica relevantes (ex.: cálculo de status, filtros, ordenação), sugerir **testes unitários**.
- Manter no repositório:
  - Exemplos de payloads (JSON) usados para matrícula, solicitação, histórico;
  - Pequena documentação de endpoints simulados (mesmo que internos).

---

## 5. Como o Copilot deve se comportar no dia a dia

Quando o desenvolvedor:

- Criar um novo arquivo:
  - Copilot deve sugerir **estrutura inicial** com base nas seções acima.
- Estiver codando um fluxo (ex.: abrir solicitação):
  - Copilot deve **lembrar o contexto do cidadão**: linguagem simples, campos essenciais, steps claros.
- Estiver refatorando:
  - Copilot deve propor extração de componentes reutilizáveis, especialmente para:
    - Listas de solicitações;
    - Cards de protocolo;
    - Timelines de status.

> Se houver dúvida entre uma solução “complexa, perfeita” e uma solução “simples, clara e demonstrável” **para o MVP**, Copilot deve priorizar a solução **simples e clara**, bem estruturada para evoluir depois.

---

## 6. Tecnologias Obrigatórias: Java, Flutter e C#

Este projeto **deve utilizar** as três tecnologias abaixo. Copilot deve respeitar esse direcionamento sempre que sugerir código ou estrutura.

### 6.1 Java — Backend Principal (serviços centrais)

- Usar Java para o **backend principal**, que expõe APIs REST/JSON para:
  - Matrícula escolar;
  - Consulta de vagas;
  - Gerenciamento de solicitações de serviços urbanos;
  - Consulta de histórico.

- Quando o repositório já tiver um framework definido (ex.: **Spring Boot**, Quarkus, Jakarta EE):
  - Copilot deve seguir o framework já existente.
- Se ainda não houver framework definido:
  - Sugerir **Spring Boot** como padrão para criação rápida de APIs REST.

- Organização sugerida de pacotes:
  - `controller` — endpoints REST;
  - `service` — regras de negócio;
  - `repository` — acesso a dados (mesmo que seja mock/in-memory);
  - `domain` ou `model` — entidades de domínio;
  - `dto` — objetos de entrada/saída de API.

- Boas práticas:
  - Endpoints REST devem ser claros, por exemplo:  
    - `POST /api/matriculas`  
    - `GET /api/vagas`  
    - `POST /api/solicitacoes`  
    - `GET /api/solicitacoes/{id}`  
    - `GET /api/solicitacoes?cidadaoId=...`
  - Usar **JSON** como formato padrão de resposta.
  - Mensagens e textos expostos ao usuário (logs funcionais, erros de validação) em português; nomes de classes/métodos em inglês.

### 6.2 Flutter — Front-end do Cidadão (aplicativo/portal)

- Usar **Flutter** como camada de **interface do cidadão**, podendo ser:
  - Aplicativo mobile (Android/iOS),
  - ou Flutter Web (portal web responsivo).

- O Flutter deve:
  - Consumir as APIs Java e/ou C# via HTTP/JSON.
  - Exibir fluxos principais:
    - Home / Painel do Cidadão;
    - Matrícula escolar;
    - Consulta de vagas;
    - Abertura de solicitações;
    - Acompanhamento de status;
    - Histórico de atendimentos;
    - Notificações.

- Organização sugerida em `lib/`:
  - `screens/` — telas (ex.: `home_screen.dart`, `enrollment_screen.dart`);
  - `widgets/` — componentes reutilizáveis (cards, listas, botões padronizados);
  - `models/` — modelos de dados (espelhando os DTOs do backend);
  - `services/` — clientes HTTP para APIs (`api_client.dart`, `citizen_service.dart`);
  - `state/` (opcional) — gerenciamento de estado (Provider, Riverpod, Bloc, etc., respeitando o padrão já adotado).

- Boas práticas:
  - Usar **Material Design** e priorizar **acessibilidade** (tamanho de fonte, contraste, botões claros).
  - Textos exibidos sempre em **português**.
  - Manter navegação simples (ex.: `BottomNavigationBar` ou `Drawer` para acesso rápido aos módulos principais).

### 6.3 C# — Serviços Complementares / Integrações

- Usar **C#** para:
  - Serviços complementares;
  - Integrações específicas com outros sistemas (se necessário);
  - Funcionalidades que se beneficiem do ecossistema .NET (ex.: serviços de fila, jobs, APIs auxiliares).

- Framework sugerido:
  - **ASP.NET Core** (ou `.NET Minimal APIs`, se o projeto já estiver estruturado assim).

- Organização sugerida:
  - `Controllers/` — APIs REST;
  - `Services/` — lógica de negócio complementar;
  - `Repositories/` — persistência de dados (mesmo que mock);
  - `Models/` — modelos de domínio.

- Boas práticas:
  - Manter o mesmo padrão de contrato de dados usado no backend Java (nomes de campos, tipos), para facilitar consumo pelo Flutter.
  - Documentar endpoints, principalmente se forem chamados pelo backend Java ou pelo Flutter.

### 6.4 Integração entre Java, Flutter e C#

- **Flutter** é a camada de apresentação principal para o cidadão.
- **Java** é o backend core, concentrando a maior parte da regra de negócio da Central do Cidadão.
- **C#** pode:
  - Expôr APIs específicas consumidas pelo Java ou diretamente pelo Flutter; ou
  - Atuar como serviços internos (ex.: processamento, relatórios, integrações legadas).
- Todos os serviços devem:
  - Falar via **HTTP/JSON**;
  - Utilizar respostas consistentes (ex.: `{ "id": 1, "status": "EM_ANDAMENTO", "mensagem": "..." }`).

---

## 8. Integração com Banco de Dados MySQL

O projeto utilizará **MySQL** como banco de dados relacional para persistência de dados. Esta seção orienta a integração em cada uma das tecnologias do projeto.

### 8.1 Estrutura do Banco de Dados

#### Tabelas Principais

```sql
-- Tabela de Cidadãos (usuários do sistema)
CREATE TABLE cidadaos (
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

-- Tabela de Escolas
CREATE TABLE escolas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    telefone VARCHAR(20),
    nivel_ensino ENUM('INFANTIL', 'FUNDAMENTAL_I', 'FUNDAMENTAL_II', 'MEDIO') NOT NULL,
    vagas_totais INT DEFAULT 0,
    vagas_ocupadas INT DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de Matrículas
CREATE TABLE matriculas (
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
    FOREIGN KEY (cidadao_id) REFERENCES cidadaos(id),
    FOREIGN KEY (escola_id) REFERENCES escolas(id)
);

-- Tabela de Solicitações de Serviços Urbanos
CREATE TABLE solicitacoes_servicos (
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
    FOREIGN KEY (cidadao_id) REFERENCES cidadaos(id)
);

-- Tabela de Histórico de Status (Timeline)
CREATE TABLE historico_status (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tipo_registro ENUM('MATRICULA', 'SERVICO') NOT NULL,
    registro_id BIGINT NOT NULL,
    status_anterior VARCHAR(50),
    status_novo VARCHAR(50) NOT NULL,
    observacao TEXT,
    usuario_responsavel VARCHAR(255),
    data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Notificações
CREATE TABLE notificacoes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cidadao_id BIGINT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    mensagem TEXT NOT NULL,
    tipo ENUM('INFO', 'ALERTA', 'SUCESSO', 'ERRO') DEFAULT 'INFO',
    lida BOOLEAN DEFAULT FALSE,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cidadao_id) REFERENCES cidadaos(id)
);

-- Índices para otimização
CREATE INDEX idx_matriculas_cidadao ON matriculas(cidadao_id);
CREATE INDEX idx_matriculas_status ON matriculas(status);
CREATE INDEX idx_solicitacoes_cidadao ON solicitacoes_servicos(cidadao_id);
CREATE INDEX idx_solicitacoes_status ON solicitacoes_servicos(status);
CREATE INDEX idx_solicitacoes_tipo ON solicitacoes_servicos(tipo_servico);
CREATE INDEX idx_notificacoes_cidadao ON notificacoes(cidadao_id);
CREATE INDEX idx_historico_registro ON historico_status(tipo_registro, registro_id);
```

### 8.2 Configuração no Java (Spring Boot)

#### Dependências (pom.xml)

```xml
<dependencies>
    <!-- Spring Data JPA -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <!-- MySQL Connector -->
    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <scope>runtime</scope>
    </dependency>
    
    <!-- Flyway para migrations (opcional, recomendado) -->
    <dependency>
        <groupId>org.flywaydb</groupId>
        <artifactId>flyway-core</artifactId>
    </dependency>
    <dependency>
        <groupId>org.flywaydb</groupId>
        <artifactId>flyway-mysql</artifactId>
    </dependency>
</dependencies>
```

#### application.properties / application.yml

```yaml
spring:
  datasource:
    url: jdbc:mysql://${DB_HOST:localhost}:${DB_PORT:3306}/${DB_NAME:central_cidadao}?useSSL=false&serverTimezone=America/Sao_Paulo&allowPublicKeyRetrieval=true
    username: ${DB_USER:root}
    password: ${DB_PASSWORD:root}
    driver-class-name: com.mysql.cj.jdbc.Driver
  
  jpa:
    hibernate:
      ddl-auto: validate  # Use 'create' apenas em dev inicial, depois 'validate'
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect
        format_sql: true
  
  flyway:
    enabled: true
    locations: classpath:db/migration
```

#### Exemplo de Entity

```java
@Entity
@Table(name = "cidadaos")
public class Cidadao {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String nome;
    
    @Column(unique = true, nullable = false, length = 14)
    private String cpf;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    private String telefone;
    private String cep;
    private String endereco;
    private String numero;
    private String complemento;
    private String bairro;
    private String cidade;
    private String estado;
    
    @Column(name = "data_cadastro")
    private LocalDateTime dataCadastro;
    
    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao;
    
    // Getters, Setters, Constructors
}
```

#### Exemplo de Repository

```java
@Repository
public interface CidadaoRepository extends JpaRepository<Cidadao, Long> {
    Optional<Cidadao> findByCpf(String cpf);
    Optional<Cidadao> findByEmail(String email);
}

@Repository
public interface MatriculaRepository extends JpaRepository<Matricula, Long> {
    List<Matricula> findByCidadaoId(Long cidadaoId);
    Optional<Matricula> findByProtocolo(String protocolo);
    List<Matricula> findByCidadaoIdAndStatus(Long cidadaoId, StatusMatricula status);
}

@Repository
public interface SolicitacaoServicoRepository extends JpaRepository<SolicitacaoServico, Long> {
    List<SolicitacaoServico> findByCidadaoId(Long cidadaoId);
    Optional<SolicitacaoServico> findByProtocolo(String protocolo);
    List<SolicitacaoServico> findByTipoServico(TipoServico tipo);
    List<SolicitacaoServico> findByStatus(StatusSolicitacao status);
}
```

### 8.3 Configuração no C# (ASP.NET Core)

#### Dependências (NuGet)

```xml
<PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.0.0" />
<PackageReference Include="Pomelo.EntityFrameworkCore.MySql" Version="8.0.0" />
<PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="8.0.0" />
```

#### appsettings.json

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Port=3306;Database=central_cidadao;User=root;Password=root;"
  }
}
```

#### DbContext

```csharp
public class CentralCidadaoContext : DbContext
{
    public CentralCidadaoContext(DbContextOptions<CentralCidadaoContext> options) 
        : base(options) { }
    
    public DbSet<Cidadao> Cidadaos { get; set; }
    public DbSet<Escola> Escolas { get; set; }
    public DbSet<Matricula> Matriculas { get; set; }
    public DbSet<SolicitacaoServico> SolicitacoesServicos { get; set; }
    public DbSet<Notificacao> Notificacoes { get; set; }
    public DbSet<HistoricoStatus> HistoricoStatus { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Cidadao>().ToTable("cidadaos");
        modelBuilder.Entity<Escola>().ToTable("escolas");
        modelBuilder.Entity<Matricula>().ToTable("matriculas");
        modelBuilder.Entity<SolicitacaoServico>().ToTable("solicitacoes_servicos");
        modelBuilder.Entity<Notificacao>().ToTable("notificacoes");
        modelBuilder.Entity<HistoricoStatus>().ToTable("historico_status");
    }
}
```

#### Program.cs

```csharp
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<CentralCidadaoContext>(options =>
    options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString)));
```

### 8.4 Configuração no Flutter

O Flutter **não deve acessar o MySQL diretamente**. A comunicação deve ser feita via APIs REST (Java/C#).

#### Exemplo de Service para consumir API

```dart
class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Buscar perfil do cidadão
  Future<CitizenProfile> fetchProfile(String cidadaoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cidadaos/$cidadaoId'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      return CitizenProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar perfil');
    }
  }
  
  // Atualizar perfil
  Future<void> updateProfile(CitizenProfile profile) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cidadaos/${profile.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar perfil');
    }
  }
  
  // Listar matrículas do cidadão
  Future<List<Enrollment>> fetchEnrollments(String cidadaoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/matriculas?cidadaoId=$cidadaoId'),
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Enrollment.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar matrículas');
    }
  }
}
```

### 8.5 Docker Compose com MySQL

Adicionar o serviço MySQL ao `docker-compose.yml`:

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: central-cidadao-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: central_cidadao
      MYSQL_USER: app_user
      MYSQL_PASSWORD: app_password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./scripts/init.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - central-cidadao-network

  backend-java:
    build: ./backend-java
    container_name: central-cidadao-backend
    environment:
      DB_HOST: mysql
      DB_PORT: 3306
      DB_NAME: central_cidadao
      DB_USER: app_user
      DB_PASSWORD: app_password
    ports:
      - "8080:8080"
    depends_on:
      mysql:
        condition: service_healthy
    networks:
      - central-cidadao-network

  frontend:
    build: ./frontend_flutter
    container_name: central-cidadao-frontend
    ports:
      - "80:80"
    depends_on:
      - backend-java
    networks:
      - central-cidadao-network

volumes:
  mysql_data:

networks:
  central-cidadao-network:
    driver: bridge
```

### 8.6 Boas Práticas para Integração com MySQL

1. **Nunca commitar credenciais** - Use variáveis de ambiente ou arquivos `.env`
2. **Use migrations** - Flyway (Java) ou EF Migrations (C#) para versionamento do schema
3. **Índices** - Criar índices para colunas frequentemente filtradas (status, cidadao_id, protocolo)
4. **Connection Pooling** - Configurar pool de conexões adequado (HikariCP no Java)
5. **Tratamento de erros** - Capturar exceções de banco e retornar mensagens amigáveis ao usuário
6. **Validação** - Validar dados antes de persistir (CPF, email, campos obrigatórios)
7. **Soft Delete** - Considerar usar campo `ativo` em vez de deletar registros fisicamente
8. **Auditoria** - Manter campos `data_cadastro` e `data_atualizacao` em todas as tabelas

---

## 9. Resumo para o Copilot

- Este projeto é um **MVP de Central do Cidadão** para uma hackaton.
- É **obrigatório** utilizar:
  - Java (backend principal),
  - Flutter (front-end do cidadão),
  - C# (serviços complementares/integrações),
  - **MySQL** (banco de dados relacional).
- Priorize:
  - **Experiência do cidadão** acima de detalhes técnicos supérfluos;
  - **Centralização de fluxos** (matrícula, vagas, serviços urbanos, histórico);
  - **Código limpo e modular**, separado por tecnologia.

- Use **dados simulados/mocks** quando não houver integração real.
- Documente sempre que algo for "simulado" para facilitar a substituição futura.

- Siga boas práticas de cada tecnologia, respeitando a organização sugerida.
- Para integração com **MySQL**, siga as orientações da **Seção 8**.

- Siga boas práticas de cada tecnologia, respeitando a organização sugerida.