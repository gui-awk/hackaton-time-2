import 'package:flutter/foundation.dart';
import '../models/enrollment.dart';
import '../models/service_request.dart';
import '../models/notification_item.dart';

/// Estado global da aplicação Central do Cidadão.
/// Gerencia dados do cidadão, matrículas, solicitações e notificações.
class AppState extends ChangeNotifier {
  // Nome do cidadão logado (simulado para MVP)
  final String _citizenName = 'Maria da Silva';
  String get citizenName => _citizenName;

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
