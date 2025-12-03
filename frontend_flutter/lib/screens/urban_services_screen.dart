import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/service_request.dart';
import '../state/app_state.dart';
import '../widgets/step_indicator.dart';

/// Tela de Serviços Urbanos
/// Permite ao cidadão abrir solicitações de serviços públicos
/// Fluxo: Tipo de Serviço → Localização → Detalhes → Confirmação
class UrbanServicesScreen extends StatefulWidget {
  const UrbanServicesScreen({super.key});

  @override
  State<UrbanServicesScreen> createState() => _UrbanServicesScreenState();
}

class _UrbanServicesScreenState extends State<UrbanServicesScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Dados da solicitação
  ServiceType? _selectedServiceType;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _addressController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _referenceController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Solicitação criada
  ServiceRequest? _createdRequest;

  @override
  void dispose() {
    _addressController.dispose();
    _neighborhoodController.dispose();
    _referenceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviços Urbanos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Indicador de passos
          StepIndicator(
            currentStep: _currentStep,
            steps: const [
              'Serviço',
              'Local',
              'Detalhes',
              'Confirmação',
            ],
          ),
          
          // Conteúdo do passo atual
          Expanded(
            child: _buildCurrentStep(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildServiceTypeStep();
      case 1:
        return _buildLocationStep();
      case 2:
        return _buildDetailsStep();
      case 3:
        return _buildConfirmationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Passo 1: Seleção do tipo de serviço
  Widget _buildServiceTypeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O que você precisa?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Selecione o tipo de serviço que deseja solicitar.',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          const SizedBox(height: 24),
          
          // Cards de serviços
          ...ServiceType.availableTypes.map((serviceType) {
            final isSelected = _selectedServiceType?.id == serviceType.id;
            return _ServiceTypeCard(
              serviceType: serviceType,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedServiceType = serviceType;
                });
              },
            );
          }),
          
          const SizedBox(height: 24),
          
          // Botão continuar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedServiceType != null 
                  ? () => setState(() => _currentStep = 1)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Continuar', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  /// Passo 2: Informar localização
  Widget _buildLocationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicação do serviço selecionado
            _buildSelectedServiceBanner(),
            
            const SizedBox(height: 24),
            
            Text(
              'Onde está o problema?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Informe o endereço para que a equipe possa encontrar o local.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 24),
            
            // Campo de endereço
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Endereço',
                hintText: 'Ex: Rua das Flores, 123',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.location_on),
                helperText: 'Informe a rua e número (se houver)',
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o endereço';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Campo de bairro
            TextFormField(
              controller: _neighborhoodController,
              decoration: InputDecoration(
                labelText: 'Bairro',
                hintText: 'Ex: Centro',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.map),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o bairro';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Campo de ponto de referência
            TextFormField(
              controller: _referenceController,
              decoration: InputDecoration(
                labelText: 'Ponto de referência (opcional)',
                hintText: 'Ex: Próximo à padaria do João',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.pin_drop),
                helperText: 'Ajuda a equipe a encontrar o local mais rápido',
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botões de navegação
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentStep = 0),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Voltar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _goToDetailsStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Continuar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Passo 3: Detalhes da solicitação
  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicação do serviço selecionado
          _buildSelectedServiceBanner(),
          
          const SizedBox(height: 24),
          
          Text(
            'Conte mais sobre o problema',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Descreva o que está acontecendo para ajudar a equipe a resolver mais rápido.',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          const SizedBox(height: 24),
          
          // Campo de descrição
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Descrição do problema',
              hintText: _getDescriptionHint(),
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Dica de preenchimento
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Dica: Quanto mais detalhes você fornecer, mais rápido conseguiremos resolver!',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Opção de anexar foto (simulado)
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade de foto em desenvolvimento'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Anexar foto (opcional)'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Resumo antes de enviar
          Card(
            color: Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumo da solicitação',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider(),
                  _buildSummaryRow('Serviço', _selectedServiceType?.name ?? ''),
                  _buildSummaryRow('Endereço', _addressController.text),
                  _buildSummaryRow('Bairro', _neighborhoodController.text),
                  if (_referenceController.text.isNotEmpty)
                    _buildSummaryRow('Referência', _referenceController.text),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botões de navegação
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep = 1),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Voltar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _submitRequest,
                  icon: _isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isLoading ? 'Enviando...' : 'Enviar Solicitação'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Passo 4: Confirmação
  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 32),
          
          // Ícone de sucesso
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green.shade600,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Solicitação Enviada!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          
          const SizedBox(height: 12),
          
          const Text(
            'Sua solicitação foi registrada e será analisada pela equipe responsável.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          
          const SizedBox(height: 32),
          
          // Card com protocolo
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.receipt_long, size: 40, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'Número do Protocolo',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _createdRequest?.protocolNumber ?? '',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Detalhes da solicitação
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalhes da Solicitação',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider(),
                  _buildDetailRow(Icons.build, 'Serviço', _createdRequest?.serviceType ?? ''),
                  _buildDetailRow(Icons.location_on, 'Endereço', _createdRequest?.address ?? ''),
                  _buildDetailRow(Icons.map, 'Bairro', _createdRequest?.neighborhood ?? ''),
                  _buildDetailRow(Icons.info, 'Status', _createdRequest?.status.label ?? ''),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Próximos passos
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Próximos passos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildNextStep('1', 'Sua solicitação será analisada pela equipe'),
                _buildNextStep('2', 'Você receberá atualizações sobre o andamento'),
                _buildNextStep('3', 'Acompanhe pelo número do protocolo'),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Botões finais
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Reiniciar para nova solicitação
                    setState(() {
                      _currentStep = 0;
                      _selectedServiceType = null;
                      _addressController.clear();
                      _neighborhoodController.clear();
                      _referenceController.clear();
                      _descriptionController.clear();
                      _createdRequest = null;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nova Solicitação'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home),
                  label: const Text('Voltar ao Início'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedServiceBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getServiceColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getServiceColor().withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(_getServiceIcon(), color: _getServiceColor()),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Serviço selecionado:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  _selectedServiceType?.name ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getServiceColor(),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _currentStep = 0),
            child: const Text('Alterar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blue.shade800),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon() {
    switch (_selectedServiceType?.id) {
      case 'poda':
        return Icons.park;
      case 'iluminacao':
        return Icons.lightbulb;
      case 'obras':
        return Icons.construction;
      case 'limpeza':
        return Icons.cleaning_services;
      default:
        return Icons.build;
    }
  }

  Color _getServiceColor() {
    switch (_selectedServiceType?.id) {
      case 'poda':
        return Colors.green;
      case 'iluminacao':
        return Colors.amber.shade700;
      case 'obras':
        return Colors.orange;
      case 'limpeza':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  String _getDescriptionHint() {
    switch (_selectedServiceType?.id) {
      case 'poda':
        return 'Ex: Árvore com galhos secos que estão caindo na calçada...';
      case 'iluminacao':
        return 'Ex: Poste com lâmpada queimada há 3 dias, deixando a rua escura...';
      case 'obras':
        return 'Ex: Buraco grande no asfalto que está causando acidentes...';
      case 'limpeza':
        return 'Ex: Lixo acumulado na praça que não está sendo recolhido...';
      default:
        return 'Descreva o problema com detalhes...';
    }
  }

  void _goToDetailsStep() {
    if (_formKey.currentState!.validate()) {
      setState(() => _currentStep = 2);
    }
  }

  Future<void> _submitRequest() async {
    setState(() => _isLoading = true);

    // Simula delay de envio
    await Future.delayed(const Duration(milliseconds: 1200));

    // Gera número de protocolo
    final protocolNumber = 'SRV${DateTime.now().year}${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final request = ServiceRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      protocolNumber: protocolNumber,
      serviceType: _selectedServiceType!.name,
      description: _descriptionController.text.isNotEmpty 
          ? _descriptionController.text 
          : 'Solicitação de ${_selectedServiceType!.name}',
      address: _addressController.text,
      neighborhood: _neighborhoodController.text,
      status: ServiceRequestStatus.received,
      createdAt: DateTime.now(),
      statusHistory: [
        StatusUpdate(
          status: ServiceRequestStatus.received,
          date: DateTime.now(),
          observation: 'Solicitação registrada pelo cidadão',
        ),
      ],
    );

    // Adiciona ao estado global
    if (mounted) {
      context.read<AppState>().addServiceRequest(request);
    }

    setState(() {
      _createdRequest = request;
      _currentStep = 3;
      _isLoading = false;
    });
  }
}

/// Card de tipo de serviço
class _ServiceTypeCard extends StatelessWidget {
  final ServiceType serviceType;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceTypeCard({
    required this.serviceType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ícone do serviço
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIcon(),
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                // Informações do serviço
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceType.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected ? color : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        serviceType.description,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Indicador de seleção
                if (isSelected)
                  Icon(Icons.check_circle, color: color, size: 28)
                else
                  Icon(Icons.circle_outlined, color: Colors.grey.shade300, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (serviceType.id) {
      case 'poda':
        return Icons.park;
      case 'iluminacao':
        return Icons.lightbulb;
      case 'obras':
        return Icons.construction;
      case 'limpeza':
        return Icons.cleaning_services;
      default:
        return Icons.build;
    }
  }

  Color _getColor() {
    switch (serviceType.id) {
      case 'poda':
        return Colors.green;
      case 'iluminacao':
        return Colors.amber.shade700;
      case 'obras':
        return Colors.orange;
      case 'limpeza':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }
}
