/// Modelo de Solicitação de Serviço Urbano
class ServiceRequest {
  final String id;
  final String protocolNumber;
  final String serviceType;
  final String description;
  final String address;
  final String? neighborhood;
  final String? photoPath; // Caminho da foto (simulado)
  final ServiceRequestStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<StatusUpdate> statusHistory;

  ServiceRequest({
    required this.id,
    required this.protocolNumber,
    required this.serviceType,
    required this.description,
    required this.address,
    this.neighborhood,
    this.photoPath,
    this.status = ServiceRequestStatus.received,
    required this.createdAt,
    this.updatedAt,
    this.statusHistory = const [],
  });

  ServiceRequest copyWith({
    String? id,
    String? protocolNumber,
    String? serviceType,
    String? description,
    String? address,
    String? neighborhood,
    String? photoPath,
    ServiceRequestStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<StatusUpdate>? statusHistory,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      protocolNumber: protocolNumber ?? this.protocolNumber,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      address: address ?? this.address,
      neighborhood: neighborhood ?? this.neighborhood,
      photoPath: photoPath ?? this.photoPath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      statusHistory: statusHistory ?? this.statusHistory,
    );
  }

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] as String,
      protocolNumber: json['protocolNumber'] as String,
      serviceType: json['serviceType'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      neighborhood: json['neighborhood'] as String?,
      photoPath: json['photoPath'] as String?,
      status: ServiceRequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ServiceRequestStatus.received,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      statusHistory: (json['statusHistory'] as List<dynamic>?)
              ?.map((e) => StatusUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'protocolNumber': protocolNumber,
      'serviceType': serviceType,
      'description': description,
      'address': address,
      'neighborhood': neighborhood,
      'photoPath': photoPath,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'statusHistory': statusHistory.map((e) => e.toJson()).toList(),
    };
  }
}

/// Status da solicitação de serviço
enum ServiceRequestStatus {
  received,     // Recebida
  analyzing,    // Em análise
  scheduled,    // Agendada
  inProgress,   // Em execução
  completed,    // Concluída
  canceled,     // Cancelada
}

extension ServiceRequestStatusExtension on ServiceRequestStatus {
  String get label {
    switch (this) {
      case ServiceRequestStatus.received:
        return 'Recebida';
      case ServiceRequestStatus.analyzing:
        return 'Em análise';
      case ServiceRequestStatus.scheduled:
        return 'Agendada';
      case ServiceRequestStatus.inProgress:
        return 'Em execução';
      case ServiceRequestStatus.completed:
        return 'Concluída';
      case ServiceRequestStatus.canceled:
        return 'Cancelada';
    }
  }

  String get description {
    switch (this) {
      case ServiceRequestStatus.received:
        return 'Sua solicitação foi recebida e será analisada em breve.';
      case ServiceRequestStatus.analyzing:
        return 'Estamos analisando sua solicitação.';
      case ServiceRequestStatus.scheduled:
        return 'Sua solicitação foi agendada para execução.';
      case ServiceRequestStatus.inProgress:
        return 'Equipe em campo realizando o serviço.';
      case ServiceRequestStatus.completed:
        return 'Serviço concluído com sucesso!';
      case ServiceRequestStatus.canceled:
        return 'Solicitação cancelada.';
    }
  }
}

/// Atualização de status (para timeline)
class StatusUpdate {
  final ServiceRequestStatus status;
  final DateTime date;
  final String? observation;

  StatusUpdate({
    required this.status,
    required this.date,
    this.observation,
  });

  factory StatusUpdate.fromJson(Map<String, dynamic> json) {
    return StatusUpdate(
      status: ServiceRequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ServiceRequestStatus.received,
      ),
      date: DateTime.parse(json['date'] as String),
      observation: json['observation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'date': date.toIso8601String(),
      'observation': observation,
    };
  }
}

/// Tipos de serviço urbano disponíveis
class ServiceType {
  final String id;
  final String name;
  final String description;
  final String iconName;

  const ServiceType({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
  });

  /// Lista de tipos de serviço disponíveis (mock)
  static const List<ServiceType> availableTypes = [
    ServiceType(
      id: 'poda',
      name: 'Poda de Árvore',
      description: 'Solicitar poda ou remoção de árvores em vias públicas',
      iconName: 'park',
    ),
    ServiceType(
      id: 'iluminacao',
      name: 'Iluminação Pública',
      description: 'Reportar problemas com postes ou lâmpadas',
      iconName: 'lightbulb',
    ),
    ServiceType(
      id: 'obras',
      name: 'Obras e Buracos',
      description: 'Informar sobre buracos, calçadas danificadas ou obras',
      iconName: 'construction',
    ),
    ServiceType(
      id: 'limpeza',
      name: 'Limpeza Urbana',
      description: 'Solicitar limpeza de vias, praças ou terrenos',
      iconName: 'cleaning_services',
    ),
  ];
}
