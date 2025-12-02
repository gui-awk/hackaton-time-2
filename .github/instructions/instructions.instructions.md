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

## 7. Resumo para o Copilot

- Este projeto é um **MVP de Central do Cidadão** para uma hackaton.
- É **obrigatório** utilizar:
  - Java (backend principal),
  - Flutter (front-end do cidadão),
  - C# (serviços complementares/integrações).
- Priorize:
  - **Experiência do cidadão** acima de detalhes técnicos supérfluos;
  - **Centralização de fluxos** (matrícula, vagas, serviços urbanos, histórico);
  - **Código limpo e modular**, separado por tecnologia.

- Use **dados simulados/mocks** quando não houver integração real.
- Documente sempre que algo for “simulado” para facilitar a substituição futura.

- Siga boas práticas de cada tecnologia, respeitando a organização sugerida.