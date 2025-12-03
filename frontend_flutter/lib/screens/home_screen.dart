import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/service_card.dart';
import '../widgets/notification_badge.dart';
import 'enrollment_screen.dart';
import 'urban_services_screen.dart';

/// Tela Home - Painel Principal do Cidadão
/// Ponto de entrada com acesso rápido aos principais serviços
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Central do Cidadão'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          NotificationBadge(
            count: appState.unreadNotificationsCount,
            onPressed: () {
              _showNotifications(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de boas-vindas
            _buildWelcomeHeader(context, appState.citizenName),
            
            const SizedBox(height: 16),
            
            // Banner de avisos importantes
            _buildAnnouncementBanner(context),
            
            const SizedBox(height: 24),
            
            // Seção de serviços principais
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Serviços Disponíveis',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Grid de serviços
            _buildServicesGrid(context),
            
            const SizedBox(height: 24),
            
            // Acesso rápido
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Acesso Rápido',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Lista de ações rápidas
            _buildQuickActions(context),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, String citizenName) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, $citizenName!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'O que você precisa fazer hoje?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.campaign, color: Colors.amber.shade700, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Matrículas 2025 Abertas!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Período de inscrições: 01/12 a 20/12/2024',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          ServiceCard(
            icon: Icons.school,
            title: 'Matrícula Escolar',
            subtitle: 'Solicitar vaga',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EnrollmentScreen(),
                ),
              );
            },
          ),
          ServiceCard(
            icon: Icons.event_seat,
            title: 'Consultar Vagas',
            subtitle: 'Ver disponibilidade',
            color: Colors.green,
            onTap: () {
              _showComingSoon(context, 'Consulta de Vagas');
            },
          ),
          ServiceCard(
            icon: Icons.build,
            title: 'Serviços Urbanos',
            subtitle: 'Abrir solicitação',
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UrbanServicesScreen(),
                ),
              );
            },
          ),
          ServiceCard(
            icon: Icons.history,
            title: 'Minhas Solicitações',
            subtitle: 'Acompanhar status',
            color: Colors.purple,
            onTap: () {
              _showComingSoon(context, 'Minhas Solicitações');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _QuickActionTile(
            icon: Icons.search,
            title: 'Consultar protocolo',
            subtitle: 'Busque pelo número do protocolo',
            onTap: () {
              _showProtocolSearch(context);
            },
          ),
          const SizedBox(height: 8),
          _QuickActionTile(
            icon: Icons.help_outline,
            title: 'Dúvidas frequentes',
            subtitle: 'Tire suas dúvidas sobre os serviços',
            onTap: () {
              _showComingSoon(context, 'Dúvidas Frequentes');
            },
          ),
          const SizedBox(height: 8),
          _QuickActionTile(
            icon: Icons.phone,
            title: 'Fale Conosco',
            subtitle: 'Entre em contato com a prefeitura',
            onTap: () {
              _showContactInfo(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Solicitações',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Avisos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      onTap: (index) {
        if (index != 0) {
          _showComingSoon(context, 'Esta seção');
        }
      },
    );
  }

  void _showNotifications(BuildContext context) {
    final appState = context.read<AppState>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notificações',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          appState.markAllNotificationsAsRead();
                        },
                        child: const Text('Marcar todas como lidas'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: appState.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = appState.notifications[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: notification.isRead
                              ? Colors.grey.shade200
                              : Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            Icons.notifications,
                            color: notification.isRead
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(notification.message),
                        onTap: () {
                          appState.markNotificationAsRead(notification.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showProtocolSearch(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Consultar Protocolo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Número do protocolo',
            hintText: 'Ex: MAT2024001',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade em desenvolvimento'),
                ),
              );
            },
            child: const Text('Buscar'),
          ),
        ],
      ),
    );
  }

  void _showContactInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fale Conosco'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Central de Atendimento'),
              subtitle: Text('156'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('E-mail'),
              subtitle: Text('atendimento@prefeitura.gov.br'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Horário'),
              subtitle: Text('Segunda a Sexta, 8h às 17h'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Em breve!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Widget para ações rápidas
class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
