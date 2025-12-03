import 'package:flutter/material.dart';
import '../models/school.dart';
import '../services/school_service.dart';

/// Tela de Consulta de Vagas
/// Permite ao cidadão consultar disponibilidade de vagas nas escolas
/// Filtros: Nível de ensino, Bairro
class VacanciesScreen extends StatefulWidget {
  const VacanciesScreen({super.key});

  @override
  State<VacanciesScreen> createState() => _VacanciesScreenState();
}

class _VacanciesScreenState extends State<VacanciesScreen> {
  bool _isLoading = true;
  List<School> _allSchools = [];
  List<School> _filteredSchools = [];
  
  // Filtros
  String? _selectedLevel;
  String? _selectedNeighborhood;
  String _searchQuery = '';
  
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSchools() async {
    setState(() => _isLoading = true);
    
    final schools = await SchoolService.getSchools();
    
    setState(() {
      _allSchools = schools;
      _filteredSchools = schools;
      _isLoading = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredSchools = _allSchools.where((school) {
        // Filtro por nível de ensino
        if (_selectedLevel != null && 
            !school.educationLevels.contains(_selectedLevel)) {
          return false;
        }
        
        // Filtro por bairro
        if (_selectedNeighborhood != null && 
            school.neighborhood != _selectedNeighborhood) {
          return false;
        }
        
        // Filtro por busca textual
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          return school.name.toLowerCase().contains(query) ||
                 school.address.toLowerCase().contains(query) ||
                 school.neighborhood.toLowerCase().contains(query);
        }
        
        return true;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedLevel = null;
      _selectedNeighborhood = null;
      _searchQuery = '';
      _searchController.clear();
      _filteredSchools = _allSchools;
    });
  }

  List<String> get _availableNeighborhoods {
    return _allSchools
        .map((s) => s.neighborhood)
        .toSet()
        .toList()
      ..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Vagas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Cabeçalho com resumo
          _buildHeader(),
          
          // Barra de busca e filtros
          _buildSearchAndFilters(),
          
          // Lista de escolas
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSchools.isEmpty
                    ? _buildEmptyState()
                    : _buildSchoolsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Conta vagas por status
    int totalAvailable = 0;
    int schoolsWithVacancies = 0;
    int schoolsWaitingList = 0;

    for (final school in _filteredSchools) {
      totalAvailable += school.availableVacancies;
      if (school.vacancyStatus == VacancyStatus.available ||
          school.vacancyStatus == VacancyStatus.limited) {
        schoolsWithVacancies++;
      }
      if (school.vacancyStatus == VacancyStatus.waitingList) {
        schoolsWaitingList++;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Encontre a escola ideal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Consulte a disponibilidade de vagas nas escolas municipais',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Cards de resumo
          Row(
            children: [
              _buildSummaryCard(
                icon: Icons.school,
                value: '${_filteredSchools.length}',
                label: 'Escolas',
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              _buildSummaryCard(
                icon: Icons.event_seat,
                value: '$totalAvailable',
                label: 'Vagas',
                color: Colors.greenAccent,
              ),
              const SizedBox(width: 12),
              _buildSummaryCard(
                icon: Icons.check_circle,
                value: '$schoolsWithVacancies',
                label: 'Com vagas',
                color: Colors.lightGreenAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    final hasFilters = _selectedLevel != null || 
                       _selectedNeighborhood != null || 
                       _searchQuery.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          // Barra de busca
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar escola por nome ou endereço...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchQuery = '';
                        _applyFilters();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
          ),
          
          const SizedBox(height: 12),
          
          // Filtros em linha
          Row(
            children: [
              // Filtro de nível
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Nível de ensino',
                  value: _selectedLevel,
                  items: SchoolService.educationLevels,
                  onChanged: (value) {
                    _selectedLevel = value;
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Filtro de bairro
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Bairro',
                  value: _selectedNeighborhood,
                  items: _availableNeighborhoods,
                  onChanged: (value) {
                    _selectedNeighborhood = value;
                    _applyFilters();
                  },
                ),
              ),
            ],
          ),
          
          // Botão limpar filtros
          if (hasFilters)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.filter_alt_off, size: 18),
                label: const Text('Limpar filtros'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Todos', style: TextStyle(color: Colors.grey.shade600)),
        ),
        ...items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        )),
      ],
      onChanged: onChanged,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma escola encontrada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tente ajustar os filtros ou buscar por outro termo.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.refresh),
              label: const Text('Limpar filtros'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredSchools.length,
      itemBuilder: (context, index) {
        final school = _filteredSchools[index];
        return _SchoolVacancyCard(
          school: school,
          onTap: () => _showSchoolDetails(school),
        );
      },
    );
  }

  void _showSchoolDetails(School school) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SchoolDetailsSheet(school: school),
    );
  }
}

/// Card de escola com informações de vagas
class _SchoolVacancyCard extends StatelessWidget {
  final School school;
  final VoidCallback onTap;

  const _SchoolVacancyCard({
    required this.school,
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
              // Nome e badge de status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(width: 8),
                  _VacancyBadge(status: school.vacancyStatus),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Endereço
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${school.address} - ${school.neighborhood}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Níveis de ensino
              Row(
                children: [
                  Icon(Icons.school, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      school.educationLevels.join(' • '),
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              
              // Informações de vagas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _VacancyInfo(
                    label: 'Total de vagas',
                    value: '${school.totalVacancies}',
                    icon: Icons.event_seat,
                  ),
                  _VacancyInfo(
                    label: 'Disponíveis',
                    value: '${school.availableVacancies}',
                    icon: Icons.check_circle_outline,
                    valueColor: school.availableVacancies > 0 
                        ? Colors.green 
                        : Colors.red,
                  ),
                  _VacancyInfo(
                    label: 'Ocupação',
                    value: '${_getOccupancyPercentage()}%',
                    icon: Icons.pie_chart_outline,
                    valueColor: _getOccupancyColor(),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Barra de ocupação visual
              _OccupancyBar(
                total: school.totalVacancies,
                occupied: school.totalVacancies - school.availableVacancies,
              ),
              
              const SizedBox(height: 12),
              
              // Botão ver detalhes
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onTap,
                  child: const Text('Ver detalhes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getOccupancyPercentage() {
    if (school.totalVacancies == 0) return 100;
    return (((school.totalVacancies - school.availableVacancies) / 
             school.totalVacancies) * 100).round();
  }

  Color _getOccupancyColor() {
    final percentage = _getOccupancyPercentage();
    if (percentage < 70) return Colors.green;
    if (percentage < 90) return Colors.orange;
    return Colors.red;
  }
}

/// Badge de status de vagas
class _VacancyBadge extends StatelessWidget {
  final VacancyStatus status;

  const _VacancyBadge({required this.status});

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
      case VacancyStatus.available:
        return Colors.green;
      case VacancyStatus.limited:
        return Colors.orange;
      case VacancyStatus.waitingList:
        return Colors.blue;
      case VacancyStatus.full:
        return Colors.red;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case VacancyStatus.available:
        return Icons.check_circle;
      case VacancyStatus.limited:
        return Icons.warning;
      case VacancyStatus.waitingList:
        return Icons.hourglass_empty;
      case VacancyStatus.full:
        return Icons.block;
    }
  }
}

/// Informação de vagas
class _VacancyInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _VacancyInfo({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: valueColor ?? Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

/// Barra visual de ocupação
class _OccupancyBar extends StatelessWidget {
  final int total;
  final int occupied;

  const _OccupancyBar({
    required this.total,
    required this.occupied,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? occupied / total : 1.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ocupação',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              '$occupied de $total vagas preenchidas',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(_getColor(percentage)),
          ),
        ),
      ],
    );
  }

  Color _getColor(double percentage) {
    if (percentage < 0.7) return Colors.green;
    if (percentage < 0.9) return Colors.orange;
    return Colors.red;
  }
}

/// Sheet de detalhes da escola
class _SchoolDetailsSheet extends StatelessWidget {
  final School school;

  const _SchoolDetailsSheet({required this.school});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.school,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            school.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _VacancyBadge(status: school.vacancyStatus),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Informações de vagas em destaque
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatusColor().withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn(
                            'Total',
                            '${school.totalVacancies}',
                            Icons.event_seat,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey.shade300,
                          ),
                          _buildStatColumn(
                            'Disponíveis',
                            '${school.availableVacancies}',
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey.shade300,
                          ),
                          _buildStatColumn(
                            'Ocupadas',
                            '${school.totalVacancies - school.availableVacancies}',
                            Icons.person,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _OccupancyBar(
                        total: school.totalVacancies,
                        occupied: school.totalVacancies - school.availableVacancies,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Informações da escola
                const Text(
                  'Informações da Escola',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                
                _buildInfoTile(Icons.location_on, 'Endereço', school.address),
                _buildInfoTile(Icons.map, 'Bairro', school.neighborhood),
                _buildInfoTile(
                  Icons.school, 
                  'Níveis de ensino', 
                  school.educationLevels.join('\n'),
                ),
                
                const SizedBox(height: 24),
                
                // Status explicativo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getStatusExplanation(),
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Botão de ação
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: school.vacancyStatus != VacancyStatus.full
                        ? () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Para solicitar matrícula, acesse o menu "Matrícula Escolar"',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.assignment),
                    label: Text(
                      school.vacancyStatus == VacancyStatus.full
                          ? 'Sem vagas disponíveis'
                          : 'Quero solicitar matrícula',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
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

  Widget _buildStatColumn(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.grey, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: color ?? Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (school.vacancyStatus) {
      case VacancyStatus.available:
        return Colors.green;
      case VacancyStatus.limited:
        return Colors.orange;
      case VacancyStatus.waitingList:
        return Colors.blue;
      case VacancyStatus.full:
        return Colors.red;
    }
  }

  String _getStatusExplanation() {
    switch (school.vacancyStatus) {
      case VacancyStatus.available:
        return 'Esta escola possui vagas disponíveis. Você pode solicitar matrícula agora!';
      case VacancyStatus.limited:
        return 'Restam poucas vagas nesta escola. Recomendamos solicitar matrícula o quanto antes.';
      case VacancyStatus.waitingList:
        return 'As vagas estão esgotadas, mas você pode entrar na lista de espera.';
      case VacancyStatus.full:
        return 'Esta escola não possui vagas disponíveis no momento. Considere outras opções.';
    }
  }
}
