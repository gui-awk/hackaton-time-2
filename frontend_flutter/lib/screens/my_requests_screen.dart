import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../models/enrollment.dart';
import '../models/service_request.dart';

/// Tela de Minhas Solicitações
/// Permite ao cidadão acompanhar o status de todas as suas demandas
/// Inclui matrículas e serviços urbanos com timeline de status
class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterStatus = 'all'; // all, pending, completed

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Solicitações'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: const Icon(Icons.school, size: 20),
              text: 'Matrículas (${appState.enrollments.length})',
            ),
            Tab(
              icon: const Icon(Icons.build, size: 20),
              text: 'Serviços (${appState.serviceRequests.length})',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filtros de status
          _buildStatusFilter(),

          // Conteúdo das abas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEnrollmentsList(appState),
                _buildServiceRequestsList(appState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          const Text('Filtrar: ', style: TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          _buildFilterChip('Todas', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Em andamento', 'pending'),
          const SizedBox(width: 8),
          _buildFilterChip('Concluídas', 'completed'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : Colors.grey.shade700,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildEnrollmentsList(AppState appState) {
    final enrollments = _filterEnrollments(appState.enrollments);

    if (enrollments.isEmpty) {
      return _buildEmptyState(
        icon: Icons.school_outlined,
        title: 'Nenhuma matrícula encontrada',
        subtitle: _filterStatus == 'all'
            ? 'Você ainda não solicitou nenhuma matrícula.'
            : 'Nenhuma matrícula com este status.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: enrollments.length,
      itemBuilder: (context, index) {
        final enrollment = enrollments[index];
        return _EnrollmentCard(
          enrollment: enrollment,
          onTap: () => _showEnrollmentDetails(enrollment),
        );
      },
    );
  }

  Widget _buildServiceRequestsList(AppState appState) {
    final requests = _filterServiceRequests(appState.serviceRequests);

    if (requests.isEmpty) {
      return _buildEmptyState(
        icon: Icons.build_outlined,
        title: 'Nenhuma solicitação encontrada',
        subtitle: _filterStatus == 'all'
            ? 'Você ainda não abriu nenhuma solicitação de serviço.'
            : 'Nenhuma solicitação com este status.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _ServiceRequestCard(
          request: request,
          onTap: () => _showServiceRequestDetails(request),
        );
      },
    );
  }

  List<Enrollment> _filterEnrollments(List<Enrollment> enrollments) {
    switch (_filterStatus) {
      case 'pending':
        return enrollments
            .where((e) =>
                e.status != EnrollmentStatus.enrolled &&
                e.status != EnrollmentStatus.rejected)
            .toList();
      case 'completed':
        return enrollments
            .where((e) =>
                e.status == EnrollmentStatus.enrolled ||
                e.status == EnrollmentStatus.rejected)
            .toList();
      default:
        return enrollments;
    }
  }

  List<ServiceRequest> _filterServiceRequests(List<ServiceRequest> requests) {
    switch (_filterStatus) {
      case 'pending':
        return requests
            .where((r) =>
                r.status != ServiceRequestStatus.completed &&
                r.status != ServiceRequestStatus.canceled)
            .toList();
      case 'completed':
        return requests
            .where((r) =>
                r.status == ServiceRequestStatus.completed ||
                r.status == ServiceRequestStatus.canceled)
            .toList();
      default:
        return requests;
    }
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showEnrollmentDetails(Enrollment enrollment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _EnrollmentDetailsSheet(enrollment: enrollment),
    );
  }

  void _showServiceRequestDetails(ServiceRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ServiceRequestDetailsSheet(request: request),
    );
  }
}

/// Card de matrícula
class _EnrollmentCard extends StatelessWidget {
  final Enrollment enrollment;
  final VoidCallback onTap;

  const _EnrollmentCard({
    required this.enrollment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com protocolo e status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long,
                          size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        enrollment.protocolNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  _EnrollmentStatusBadge(status: enrollment.status),
                ],
              ),

              const Divider(height: 24),

              // Informações
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.school, color: Colors.blue.shade700),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          enrollment.studentName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          enrollment.schoolName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          enrollment.educationLevel,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),

              const SizedBox(height: 12),

              // Data
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(
                    'Solicitado em ${_formatDate(enrollment.createdAt)}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}

/// Card de solicitação de serviço
class _ServiceRequestCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback onTap;

  const _ServiceRequestCard({
    required this.request,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com protocolo e status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long,
                          size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        request.protocolNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  _ServiceStatusBadge(status: request.status),
                ],
              ),

              const Divider(height: 24),

              // Informações
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getServiceColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_getServiceIcon(), color: _getServiceColor()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.serviceType,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          request.address,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        if (request.neighborhood != null)
                          Text(
                            request.neighborhood!,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),

              const SizedBox(height: 12),

              // Data
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(
                    'Solicitado em ${_formatDate(request.createdAt)}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getServiceIcon() {
    if (request.serviceType.toLowerCase().contains('poda')) {
      return Icons.park;
    } else if (request.serviceType.toLowerCase().contains('iluminação')) {
      return Icons.lightbulb;
    } else if (request.serviceType.toLowerCase().contains('obra') ||
        request.serviceType.toLowerCase().contains('buraco')) {
      return Icons.construction;
    } else if (request.serviceType.toLowerCase().contains('limpeza')) {
      return Icons.cleaning_services;
    }
    return Icons.build;
  }

  Color _getServiceColor() {
    if (request.serviceType.toLowerCase().contains('poda')) {
      return Colors.green;
    } else if (request.serviceType.toLowerCase().contains('iluminação')) {
      return Colors.amber.shade700;
    } else if (request.serviceType.toLowerCase().contains('obra') ||
        request.serviceType.toLowerCase().contains('buraco')) {
      return Colors.orange;
    } else if (request.serviceType.toLowerCase().contains('limpeza')) {
      return Colors.teal;
    }
    return Colors.blue;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}

/// Badge de status de matrícula
class _EnrollmentStatusBadge extends StatelessWidget {
  final EnrollmentStatus status;

  const _EnrollmentStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getColor().withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: 14, color: _getColor()),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: _getColor(),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case EnrollmentStatus.received:
        return Colors.blue;
      case EnrollmentStatus.analyzing:
        return Colors.orange;
      case EnrollmentStatus.approved:
        return Colors.green;
      case EnrollmentStatus.rejected:
        return Colors.red;
      case EnrollmentStatus.enrolled:
        return Colors.green.shade700;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case EnrollmentStatus.received:
        return Icons.inbox;
      case EnrollmentStatus.analyzing:
        return Icons.hourglass_empty;
      case EnrollmentStatus.approved:
        return Icons.thumb_up;
      case EnrollmentStatus.rejected:
        return Icons.thumb_down;
      case EnrollmentStatus.enrolled:
        return Icons.check_circle;
    }
  }
}

/// Badge de status de serviço
class _ServiceStatusBadge extends StatelessWidget {
  final ServiceRequestStatus status;

  const _ServiceStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getColor().withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: 14, color: _getColor()),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: _getColor(),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case ServiceRequestStatus.received:
        return Colors.blue;
      case ServiceRequestStatus.analyzing:
        return Colors.orange;
      case ServiceRequestStatus.scheduled:
        return Colors.purple;
      case ServiceRequestStatus.inProgress:
        return Colors.amber.shade700;
      case ServiceRequestStatus.completed:
        return Colors.green;
      case ServiceRequestStatus.canceled:
        return Colors.red;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case ServiceRequestStatus.received:
        return Icons.inbox;
      case ServiceRequestStatus.analyzing:
        return Icons.hourglass_empty;
      case ServiceRequestStatus.scheduled:
        return Icons.event;
      case ServiceRequestStatus.inProgress:
        return Icons.engineering;
      case ServiceRequestStatus.completed:
        return Icons.check_circle;
      case ServiceRequestStatus.canceled:
        return Icons.cancel;
    }
  }
}

/// Sheet de detalhes da matrícula
class _EnrollmentDetailsSheet extends StatelessWidget {
  final Enrollment enrollment;

  const _EnrollmentDetailsSheet({required this.enrollment});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Cabeçalho
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.school, size: 32, color: Colors.blue.shade700),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Matrícula Escolar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            enrollment.protocolNumber,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Status atual em destaque
                _buildStatusHighlight(),

                const SizedBox(height: 24),

                // Timeline de status
                const Text(
                  'Acompanhamento',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildEnrollmentTimeline(),

                const SizedBox(height: 24),

                // Informações da solicitação
                const Text(
                  'Dados da Solicitação',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),

                _buildInfoCard([
                  _InfoRow(Icons.person, 'Aluno', enrollment.studentName),
                  _InfoRow(Icons.school, 'Escola', enrollment.schoolName),
                  _InfoRow(Icons.class_, 'Nível', enrollment.educationLevel),
                  _InfoRow(Icons.person_outline, 'Responsável', enrollment.responsibleName),
                  _InfoRow(Icons.phone, 'Telefone', enrollment.responsiblePhone),
                  _InfoRow(
                    Icons.calendar_today,
                    'Data da solicitação',
                    DateFormat('dd/MM/yyyy HH:mm').format(enrollment.createdAt),
                  ),
                ]),

                const SizedBox(height: 24),

                // Botão fechar
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusHighlight() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor().withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(_getStatusIcon(), color: _getStatusColor()),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status atual: ${enrollment.status.label}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  enrollment.status.description,
                  style: TextStyle(
                    color: _getStatusColor().withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentTimeline() {
    final steps = [
      _TimelineStep(
        title: 'Recebida',
        description: 'Solicitação registrada no sistema',
        date: enrollment.createdAt,
        isCompleted: true,
        isCurrent: enrollment.status == EnrollmentStatus.received,
      ),
      _TimelineStep(
        title: 'Em análise',
        description: 'Documentação sendo verificada',
        isCompleted: enrollment.status.index >= EnrollmentStatus.analyzing.index,
        isCurrent: enrollment.status == EnrollmentStatus.analyzing,
      ),
      _TimelineStep(
        title: 'Aprovada',
        description: 'Matrícula aprovada pela secretaria',
        isCompleted: enrollment.status.index >= EnrollmentStatus.approved.index,
        isCurrent: enrollment.status == EnrollmentStatus.approved,
      ),
      _TimelineStep(
        title: 'Matriculado',
        description: 'Aluno oficialmente matriculado',
        isCompleted: enrollment.status == EnrollmentStatus.enrolled,
        isCurrent: enrollment.status == EnrollmentStatus.enrolled,
      ),
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;

        return _TimelineItem(step: step, isLast: isLast);
      }).toList(),
    );
  }

  Widget _buildInfoCard(List<_InfoRow> rows) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: rows.map((row) => _buildInfoRowWidget(row)).toList(),
        ),
      ),
    );
  }

  Widget _buildInfoRowWidget(_InfoRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(row.icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(row.value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (enrollment.status) {
      case EnrollmentStatus.received:
        return Colors.blue;
      case EnrollmentStatus.analyzing:
        return Colors.orange;
      case EnrollmentStatus.approved:
        return Colors.green;
      case EnrollmentStatus.rejected:
        return Colors.red;
      case EnrollmentStatus.enrolled:
        return Colors.green.shade700;
    }
  }

  IconData _getStatusIcon() {
    switch (enrollment.status) {
      case EnrollmentStatus.received:
        return Icons.inbox;
      case EnrollmentStatus.analyzing:
        return Icons.hourglass_empty;
      case EnrollmentStatus.approved:
        return Icons.thumb_up;
      case EnrollmentStatus.rejected:
        return Icons.thumb_down;
      case EnrollmentStatus.enrolled:
        return Icons.check_circle;
    }
  }
}

/// Sheet de detalhes da solicitação de serviço
class _ServiceRequestDetailsSheet extends StatelessWidget {
  final ServiceRequest request;

  const _ServiceRequestDetailsSheet({required this.request});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Cabeçalho
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getServiceColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_getServiceIcon(), size: 32, color: _getServiceColor()),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.serviceType,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            request.protocolNumber,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Status atual em destaque
                _buildStatusHighlight(),

                const SizedBox(height: 24),

                // Timeline de status
                const Text(
                  'Acompanhamento',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildServiceTimeline(),

                const SizedBox(height: 24),

                // Informações da solicitação
                const Text(
                  'Dados da Solicitação',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),

                _buildInfoCard([
                  _InfoRow(Icons.build, 'Tipo de serviço', request.serviceType),
                  _InfoRow(Icons.location_on, 'Endereço', request.address),
                  if (request.neighborhood != null)
                    _InfoRow(Icons.map, 'Bairro', request.neighborhood!),
                  _InfoRow(Icons.description, 'Descrição', request.description),
                  _InfoRow(
                    Icons.calendar_today,
                    'Data da solicitação',
                    DateFormat('dd/MM/yyyy HH:mm').format(request.createdAt),
                  ),
                ]),

                const SizedBox(height: 24),

                // Botão fechar
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusHighlight() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor().withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(_getStatusIconByStatus(), color: _getStatusColor()),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status atual: ${request.status.label}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request.status.description,
                  style: TextStyle(
                    color: _getStatusColor().withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTimeline() {
    final steps = [
      _TimelineStep(
        title: 'Recebida',
        description: 'Solicitação registrada',
        date: request.createdAt,
        isCompleted: true,
        isCurrent: request.status == ServiceRequestStatus.received,
      ),
      _TimelineStep(
        title: 'Em análise',
        description: 'Equipe avaliando a solicitação',
        isCompleted: request.status.index >= ServiceRequestStatus.analyzing.index,
        isCurrent: request.status == ServiceRequestStatus.analyzing,
      ),
      _TimelineStep(
        title: 'Agendada',
        description: 'Serviço programado para execução',
        isCompleted: request.status.index >= ServiceRequestStatus.scheduled.index,
        isCurrent: request.status == ServiceRequestStatus.scheduled,
      ),
      _TimelineStep(
        title: 'Em execução',
        description: 'Equipe em campo realizando o serviço',
        isCompleted: request.status.index >= ServiceRequestStatus.inProgress.index,
        isCurrent: request.status == ServiceRequestStatus.inProgress,
      ),
      _TimelineStep(
        title: 'Concluída',
        description: 'Serviço finalizado',
        isCompleted: request.status == ServiceRequestStatus.completed,
        isCurrent: request.status == ServiceRequestStatus.completed,
      ),
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;

        return _TimelineItem(step: step, isLast: isLast);
      }).toList(),
    );
  }

  Widget _buildInfoCard(List<_InfoRow> rows) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: rows.map((row) => _buildInfoRowWidget(row)).toList(),
        ),
      ),
    );
  }

  Widget _buildInfoRowWidget(_InfoRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(row.icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(row.value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon() {
    if (request.serviceType.toLowerCase().contains('poda')) {
      return Icons.park;
    } else if (request.serviceType.toLowerCase().contains('iluminação')) {
      return Icons.lightbulb;
    } else if (request.serviceType.toLowerCase().contains('obra')) {
      return Icons.construction;
    } else if (request.serviceType.toLowerCase().contains('limpeza')) {
      return Icons.cleaning_services;
    }
    return Icons.build;
  }

  Color _getServiceColor() {
    if (request.serviceType.toLowerCase().contains('poda')) {
      return Colors.green;
    } else if (request.serviceType.toLowerCase().contains('iluminação')) {
      return Colors.amber.shade700;
    } else if (request.serviceType.toLowerCase().contains('obra')) {
      return Colors.orange;
    } else if (request.serviceType.toLowerCase().contains('limpeza')) {
      return Colors.teal;
    }
    return Colors.blue;
  }

  Color _getStatusColor() {
    switch (request.status) {
      case ServiceRequestStatus.received:
        return Colors.blue;
      case ServiceRequestStatus.analyzing:
        return Colors.orange;
      case ServiceRequestStatus.scheduled:
        return Colors.purple;
      case ServiceRequestStatus.inProgress:
        return Colors.amber.shade700;
      case ServiceRequestStatus.completed:
        return Colors.green;
      case ServiceRequestStatus.canceled:
        return Colors.red;
    }
  }

  IconData _getStatusIconByStatus() {
    switch (request.status) {
      case ServiceRequestStatus.received:
        return Icons.inbox;
      case ServiceRequestStatus.analyzing:
        return Icons.hourglass_empty;
      case ServiceRequestStatus.scheduled:
        return Icons.event;
      case ServiceRequestStatus.inProgress:
        return Icons.engineering;
      case ServiceRequestStatus.completed:
        return Icons.check_circle;
      case ServiceRequestStatus.canceled:
        return Icons.cancel;
    }
  }
}

/// Modelo auxiliar para timeline
class _TimelineStep {
  final String title;
  final String description;
  final DateTime? date;
  final bool isCompleted;
  final bool isCurrent;

  _TimelineStep({
    required this.title,
    required this.description,
    this.date,
    required this.isCompleted,
    required this.isCurrent,
  });
}

/// Widget de item da timeline
class _TimelineItem extends StatelessWidget {
  final _TimelineStep step;
  final bool isLast;

  const _TimelineItem({
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = step.isCompleted
        ? Colors.green
        : step.isCurrent
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade300;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Linha e círculo
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: step.isCompleted || step.isCurrent
                    ? color
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: step.isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : step.isCurrent
                      ? Container(
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: step.isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        // Conteúdo
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: step.isCompleted || step.isCurrent
                        ? Colors.black87
                        : Colors.grey,
                  ),
                ),
                Text(
                  step.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (step.date != null && step.isCompleted)
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(step.date!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Modelo auxiliar para linha de informação
class _InfoRow {
  final IconData icon;
  final String label;
  final String value;

  _InfoRow(this.icon, this.label, this.value);
}