# Central do Cidadão - Frontend Flutter

## Descrição

Aplicativo mobile/web para acesso centralizado aos serviços públicos municipais.

## Funcionalidades do MVP

### Tela 1: Home (Painel do Cidadão)
- ✅ Boas-vindas personalizada
- ✅ Banner de avisos importantes
- ✅ Grid de serviços disponíveis
- ✅ Ações rápidas (consultar protocolo, dúvidas, contato)
- ✅ Notificações com badge de contagem
- ✅ Navegação inferior

### Tela 2: Matrícula Escolar
- ✅ Fluxo em 4 passos com indicador visual
- ✅ Passo 1: Seleção do nível de ensino
- ✅ Passo 2: Escolha da escola (com status de vagas)
- ✅ Passo 3: Formulário de dados do aluno e responsável
- ✅ Passo 4: Confirmação com número de protocolo

## Estrutura do Projeto

```
lib/
├── main.dart              # Ponto de entrada da aplicação
├── models/                # Modelos de dados
│   ├── enrollment.dart    # Modelo de matrícula
│   ├── school.dart        # Modelo de escola
│   ├── service_request.dart # Modelo de solicitação de serviço
│   └── notification_item.dart # Modelo de notificação
├── screens/               # Telas da aplicação
│   ├── home_screen.dart   # Tela inicial
│   └── enrollment_screen.dart # Tela de matrícula
├── services/              # Serviços e APIs
│   ├── school_service.dart # Serviço de escolas (mock)
│   └── enrollment_service.dart # Serviço de matrículas (mock)
├── state/                 # Gerenciamento de estado
│   └── app_state.dart     # Estado global da aplicação
└── widgets/               # Componentes reutilizáveis
    ├── service_card.dart  # Card de serviço
    ├── notification_badge.dart # Badge de notificação
    └── step_indicator.dart # Indicador de passos
```

## Como Executar

1. Certifique-se de ter o Flutter instalado
2. Execute no diretório do projeto:
   ```bash
   flutter pub get
   flutter run
   ```

## Próximos Passos

- [ ] Tela de Consulta de Vagas
- [ ] Tela de Serviços Urbanos
- [ ] Tela de Minhas Solicitações
- [ ] Tela de Histórico
- [ ] Integração com backend Java
- [ ] Integração com serviços C#

## Tecnologias

- **Flutter** - Framework de UI
- **Provider** - Gerenciamento de estado
- **Material Design 3** - Design System
