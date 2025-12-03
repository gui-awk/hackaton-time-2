import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

/// Tela de Perfil do Cidadão
/// Exibe e permite editar os dados pessoais do usuário
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  // Controllers para edição
  late TextEditingController _nameController;
  late TextEditingController _cpfController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _numberController;
  late TextEditingController _complementController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _cepController;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    final profile = appState.citizenProfile;

    _nameController = TextEditingController(text: profile.name);
    _cpfController = TextEditingController(text: profile.cpf);
    _phoneController = TextEditingController(text: profile.phone);
    _emailController = TextEditingController(text: profile.email);
    _addressController = TextEditingController(text: profile.address);
    _numberController = TextEditingController(text: profile.number);
    _complementController = TextEditingController(text: profile.complement);
    _neighborhoodController = TextEditingController(text: profile.neighborhood);
    _cityController = TextEditingController(text: profile.city);
    _stateController = TextEditingController(text: profile.state);
    _cepController = TextEditingController(text: profile.cep);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final profile = appState.citizenProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar perfil',
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabeçalho com avatar
            _buildProfileHeader(profile),

            const SizedBox(height: 24),

            // Dados pessoais
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Dados Pessoais', Icons.person),
                  const SizedBox(height: 12),
                  _buildPersonalDataCard(),

                  const SizedBox(height: 24),

                  _buildSectionTitle('Endereço', Icons.location_on),
                  const SizedBox(height: 12),
                  _buildAddressCard(),

                  const SizedBox(height: 24),

                  // Botões de ação quando editando
                  if (_isEditing) _buildEditingButtons(),

                  const SizedBox(height: 16),

                  // Outras opções
                  if (!_isEditing) _buildOptionsSection(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(CitizenProfile profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getInitials(profile.name),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'Cidadão Verificado',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalDataCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField(
              label: 'Nome completo',
              controller: _nameController,
              icon: Icons.person_outline,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'CPF',
              controller: _cpfController,
              icon: Icons.badge_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              hint: '000.000.000-00',
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'Telefone',
              controller: _phoneController,
              icon: Icons.phone_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
              hint: '(00) 00000-0000',
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'E-mail',
              controller: _emailController,
              icon: Icons.email_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField(
              label: 'CEP',
              controller: _cepController,
              icon: Icons.markunread_mailbox_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              hint: '00000-000',
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'Endereço',
              controller: _addressController,
              icon: Icons.location_on_outlined,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildField(
                    label: 'Número',
                    controller: _numberController,
                    icon: Icons.pin_outlined,
                    enabled: _isEditing,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: _buildField(
                    label: 'Complemento',
                    controller: _complementController,
                    icon: Icons.apartment_outlined,
                    enabled: _isEditing,
                    hint: 'Apto, Bloco, etc.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'Bairro',
              controller: _neighborhoodController,
              icon: Icons.map_outlined,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildField(
                    label: 'Cidade',
                    controller: _cityController,
                    icon: Icons.location_city_outlined,
                    enabled: _isEditing,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: _buildField(
                    label: 'UF',
                    controller: _stateController,
                    icon: Icons.flag_outlined,
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
    String? hint,
  }) {
    if (!enabled) {
      // Modo visualização
      return Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.text.isEmpty ? '-' : controller.text,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Modo edição
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildEditingButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Restaurar valores originais
              final profile = context.read<AppState>().citizenProfile;
              _nameController.text = profile.name;
              _cpfController.text = profile.cpf;
              _phoneController.text = profile.phone;
              _emailController.text = profile.email;
              _addressController.text = profile.address;
              _numberController.text = profile.number;
              _complementController.text = profile.complement;
              _neighborhoodController.text = profile.neighborhood;
              _cityController.text = profile.city;
              _stateController.text = profile.state;
              _cepController.text = profile.cep;

              setState(() {
                _isEditing = false;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.save),
            label: const Text('Salvar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Opções', Icons.settings),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _buildOptionTile(
                icon: Icons.notifications_outlined,
                title: 'Notificações',
                subtitle: 'Configurar alertas e avisos',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configurações de notificação em breve!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildOptionTile(
                icon: Icons.security_outlined,
                title: 'Segurança',
                subtitle: 'Alterar senha e configurações de acesso',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configurações de segurança em breve!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildOptionTile(
                icon: Icons.help_outline,
                title: 'Ajuda',
                subtitle: 'Dúvidas frequentes e suporte',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Central de ajuda em breve!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildOptionTile(
                icon: Icons.info_outline,
                title: 'Sobre o aplicativo',
                subtitle: 'Versão 1.0.0 - Central do Cidadão',
                onTap: () {
                  _showAboutDialog();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Botão de sair
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              _showLogoutConfirmation();
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Sair da conta', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  void _saveProfile() {
    final appState = context.read<AppState>();

    appState.updateProfile(
      CitizenProfile(
        name: _nameController.text,
        cpf: _cpfController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressController.text,
        number: _numberController.text,
        complement: _complementController.text,
        neighborhood: _neighborhoodController.text,
        city: _cityController.text,
        state: _stateController.text,
        cep: _cepController.text,
      ),
    );

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Perfil atualizado com sucesso!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_city, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            const Text('Central do Cidadão'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Versão 1.0.0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Portal Integrado de Serviços Urbanos',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              'Desenvolvido para facilitar o acesso do cidadão aos serviços públicos municipais.',
            ),
            SizedBox(height: 16),
            Text(
              '© 2025 Prefeitura Municipal',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 12),
            Text('Sair da conta'),
          ],
        ),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
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
                  content: Text('Funcionalidade de logout em desenvolvimento'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
