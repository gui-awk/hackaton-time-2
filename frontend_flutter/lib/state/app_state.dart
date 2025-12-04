import 'package:flutter/foundation.dart';
import '../models/enrollment.dart';
import '../models/service_request.dart';
import '../models/notification_item.dart';

/// Modelo de perfil do cidadão
class CitizenProfile {
  final String name;
  final String cpf;
  final String cep;
  final String address;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;
  final String phone;
  final String email;

  const CitizenProfile({
    required this.name,
    required this.cpf,
    required this.cep,
    required this.address,
    required this.number,
    this.complement = '',
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.phone,
    required this.email,
  });

  CitizenProfile copyWith({
    String? name,
    String? cpf,
    String? cep,
    String? address,
    String? number,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
    String? phone,
    String? email,
  }) {
    return CitizenProfile(
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      cep: cep ?? this.cep,
      address: address ?? this.address,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}

/// Estado global da aplicação Central do Cidadão.
/// Gerencia dados do cidadão, matrículas, solicitações e notificações.
class AppState extends ChangeNotifier {
  // Perfil do cidadão logado (simulado para MVP)
  CitizenProfile _citizenProfile = const CitizenProfile(
    name: 'Maria da Silva',
    cpf: '123.456.789-00',
    cep: '12345-678',
    address: 'Rua das Flores',
    number: '123',
    complement: 'Apto 45',
    neighborhood: 'Centro',
    city: 'São Paulo',
    state: 'SP',
    phone: '(11) 99999-8888',
    email: 'maria.silva@email.com',
  );
  
  CitizenProfile get citizenProfile => _citizenProfile;
  String get citizenName => _citizenProfile.name;

  // Lista de matrículas do cidadão
  final List<Enrollment> _enrollments = [];
  List<Enrollment> get enrollments => List.unmodifiable(_enrollments);

  // Lista de solicitações de serviços urbanos
  final List<ServiceRequest> _serviceRequests = [];
  List<ServiceRequest> get serviceRequests => List.unmodifiable(_serviceRequests);

  // Lista de notificações
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Bem-vindo à Central do Cidadão!',
      message: 'Acesse todos os serviços públicos em um único lugar.',
      date: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Período de Matrículas Aberto',
      message: 'As matrículas para 2025 estão abertas. Não perca o prazo!',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  /// Adiciona uma nova matrícula
  void addEnrollment(Enrollment enrollment) {
    _enrollments.add(enrollment);
    _addNotification(
      'Matrícula Registrada',
      'Sua solicitação de matrícula foi registrada com protocolo ${enrollment.protocolNumber}.',
    );
    notifyListeners();
  }

  /// Adiciona uma nova solicitação de serviço
  void addServiceRequest(ServiceRequest request) {
    _serviceRequests.add(request);
    _addNotification(
      'Solicitação Registrada',
      'Sua solicitação de ${request.serviceType} foi registrada com protocolo ${request.protocolNumber}.',
    );
    notifyListeners();
  }

  /// Marca uma notificação como lida
  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  /// Marca todas as notificações como lidas
  void markAllNotificationsAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  /// Atualiza o perfil do cidadão
  void updateProfile(CitizenProfile newProfile) {
    _citizenProfile = newProfile;
    _addNotification(
      'Perfil Atualizado',
      'Seus dados cadastrais foram atualizados com sucesso.',
    );
    notifyListeners();
  }

  void _addNotification(String title, String message) {
    _notifications.insert(
      0,
      NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: message,
        date: DateTime.now(),
        isRead: false,
      ),
    );
  }
}
