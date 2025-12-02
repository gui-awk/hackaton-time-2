import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/enrollment.dart';
import '../models/school.dart';
import '../services/school_service.dart';
import '../services/enrollment_service.dart';
import '../state/app_state.dart';
import '../widgets/step_indicator.dart';

/// Tela de Matrícula Escolar
/// Fluxo completo: Nível → Escola → Dados → Confirmação
class EnrollmentScreen extends StatefulWidget {
  const EnrollmentScreen({super.key});

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Dados do formulário
  String? _selectedLevel;
  School? _selectedSchool;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para os campos de texto
  final _studentNameController = TextEditingController();
  final _responsibleNameController = TextEditingController();
  final _responsibleCpfController = TextEditingController();
  final _responsiblePhoneController = TextEditingController();

  // Dados da matrícula criada
  Enrollment? _createdEnrollment;

  List<School> _availableSchools = [];

  @override
  void dispose() {
    _studentNameController.dispose();
    _responsibleNameController.dispose();
    _responsibleCpfController.dispose();
    _responsiblePhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrícula Escolar'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Indicador de passos
          StepIndicator(
            currentStep: _currentStep,
            steps: const [
              'Nível',
              'Escola',
              'Dados',
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
        return _buildLevelStep();
      case 1:
        return _buildSchoolStep();
      case 2:
        return _buildDataStep();
      case 3:
        return _buildConfirmationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Passo 1: Seleção do nível de ensino
  Widget _buildLevelStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecione o nível de ensino',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Escolha o nível de ensino para o qual deseja solicitar a matrícula.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          ...SchoolService.educationLevels.map((level) {
            final isSelected = _selectedLevel == level;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: isSelected ? 4 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade200,
                    child: Icon(
                      _getLevelIcon(level),
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                  title: Text(
                    level,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(_getLevelDescription(level)),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedLevel = level;
                    });
                  },
                ),
              ),
            );
          }),
          
          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedLevel != null ? _goToSchoolStep : null,
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
    );
  }

  /// Passo 2: Seleção da escola
  Widget _buildSchoolStep() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escolha a escola',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escolas disponíveis para $_selectedLevel',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              itemCount: _availableSchools.length,
              itemBuilder: (context, index) {
                final school = _availableSchools[index];
                final isSelected = _selectedSchool?.id == school.id;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    elevation: isSelected ? 4 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  school.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              _buildVacancyBadge(school.vacancyStatus),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${school.address} - ${school.neighborhood}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.people, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${school.availableVacancies} vagas disponíveis',
                                style: TextStyle(
                                  color: school.availableVacancies > 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: school.vacancyStatus != VacancyStatus.full
                                  ? () {
                                      setState(() {
                                        _selectedSchool = school;
                                      });
                                    }
                                  : null,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : null,
                              ),
                              child: Text(
                                isSelected ? 'Selecionada' : 'Selecionar',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 0;
                      _selectedSchool = null;
                    });
                  },
                  child: const Text('Voltar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedSchool != null ? _goToDataStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Continuar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Passo 3: Preenchimento dos dados
  Widget _buildDataStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados do Aluno e Responsável',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Preencha os dados para continuar com a solicitação.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Dados do aluno
            const Text(
              'Dados do Aluno',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _studentNameController,
              decoration: const InputDecoration(
                labelText: 'Nome completo do aluno',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o nome do aluno';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Dados do responsável
            const Text(
              'Dados do Responsável',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _responsibleNameController,
              decoration: const InputDecoration(
                labelText: 'Nome completo do responsável',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o nome do responsável';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _responsibleCpfController,
              decoration: const InputDecoration(
                labelText: 'CPF do responsável',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
                hintText: '000.000.000-00',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o CPF';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _responsiblePhoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone para contato',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
                hintText: '(00) 00000-0000',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, informe o telefone';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Resumo da seleção
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumo da Seleção',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Nível: $_selectedLevel'),
                    Text('Escola: ${_selectedSchool?.name ?? ""}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentStep = 1;
                      });
                    },
                    child: const Text('Voltar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitEnrollment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Passo 4: Confirmação final
  Widget _buildConfirmationStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Spacer(),
          
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
          
          const SizedBox(height: 16),
          
          const Text(
            'Sua solicitação de matrícula foi registrada com sucesso.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          
          const SizedBox(height: 24),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Número do Protocolo',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _createdEnrollment?.protocolNumber ?? '',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildDetailRow('Aluno', _createdEnrollment?.studentName ?? ''),
                  _buildDetailRow('Escola', _createdEnrollment?.schoolName ?? ''),
                  _buildDetailRow('Nível', _createdEnrollment?.educationLevel ?? ''),
                  _buildDetailRow('Status', _createdEnrollment?.status.label ?? ''),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Guarde o número do protocolo para acompanhar sua solicitação.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          
          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Voltar ao Início'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildVacancyBadge(VacancyStatus status) {
    Color color;
    switch (status) {
      case VacancyStatus.available:
        color = Colors.green;
        break;
      case VacancyStatus.limited:
        color = Colors.orange;
        break;
      case VacancyStatus.waitingList:
        color = Colors.blue;
        break;
      case VacancyStatus.full:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getLevelIcon(String level) {
    switch (level) {
      case 'Educação Infantil':
        return Icons.child_care;
      case 'Ensino Fundamental I':
        return Icons.menu_book;
      case 'Ensino Fundamental II':
        return Icons.school;
      default:
        return Icons.school;
    }
  }

  String _getLevelDescription(String level) {
    switch (level) {
      case 'Educação Infantil':
        return 'Para crianças de 0 a 5 anos';
      case 'Ensino Fundamental I':
        return 'Do 1º ao 5º ano';
      case 'Ensino Fundamental II':
        return 'Do 6º ao 9º ano';
      default:
        return '';
    }
  }

  Future<void> _goToSchoolStep() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _availableSchools = await SchoolService.getSchoolsByLevel(_selectedLevel!);
      setState(() {
        _currentStep = 1;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar escolas')),
        );
      }
    }
  }

  void _goToDataStep() {
    setState(() {
      _currentStep = 2;
    });
  }

  Future<void> _submitEnrollment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final enrollment = await EnrollmentService.createEnrollment(
        studentName: _studentNameController.text,
        responsibleName: _responsibleNameController.text,
        responsibleCpf: _responsibleCpfController.text,
        responsiblePhone: _responsiblePhoneController.text,
        schoolId: _selectedSchool!.id,
        schoolName: _selectedSchool!.name,
        educationLevel: _selectedLevel!,
      );

      // Adiciona ao estado global
      if (mounted) {
        context.read<AppState>().addEnrollment(enrollment);
      }

      setState(() {
        _createdEnrollment = enrollment;
        _currentStep = 3;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao registrar matrícula')),
        );
      }
    }
  }
}
