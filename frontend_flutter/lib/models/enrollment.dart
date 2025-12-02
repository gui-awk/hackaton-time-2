/// Modelo de Matrícula Escolar
class Enrollment {
  final String id;
  final String protocolNumber;
  final String studentName;
  final String responsibleName;
  final String responsibleCpf;
  final String responsiblePhone;
  final String schoolName;
  final String educationLevel;
  final EnrollmentStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Enrollment({
    required this.id,
    required this.protocolNumber,
    required this.studentName,
    required this.responsibleName,
    required this.responsibleCpf,
    required this.responsiblePhone,
    required this.schoolName,
    required this.educationLevel,
    this.status = EnrollmentStatus.received,
    required this.createdAt,
    this.updatedAt,
  });

  Enrollment copyWith({
    String? id,
    String? protocolNumber,
    String? studentName,
    String? responsibleName,
    String? responsibleCpf,
    String? responsiblePhone,
    String? schoolName,
    String? educationLevel,
    EnrollmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Enrollment(
      id: id ?? this.id,
      protocolNumber: protocolNumber ?? this.protocolNumber,
      studentName: studentName ?? this.studentName,
      responsibleName: responsibleName ?? this.responsibleName,
      responsibleCpf: responsibleCpf ?? this.responsibleCpf,
      responsiblePhone: responsiblePhone ?? this.responsiblePhone,
      schoolName: schoolName ?? this.schoolName,
      educationLevel: educationLevel ?? this.educationLevel,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converte de JSON (para futura integração com API)
  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'] as String,
      protocolNumber: json['protocolNumber'] as String,
      studentName: json['studentName'] as String,
      responsibleName: json['responsibleName'] as String,
      responsibleCpf: json['responsibleCpf'] as String,
      responsiblePhone: json['responsiblePhone'] as String,
      schoolName: json['schoolName'] as String,
      educationLevel: json['educationLevel'] as String,
      status: EnrollmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EnrollmentStatus.received,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converte para JSON (para futura integração com API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'protocolNumber': protocolNumber,
      'studentName': studentName,
      'responsibleName': responsibleName,
      'responsibleCpf': responsibleCpf,
      'responsiblePhone': responsiblePhone,
      'schoolName': schoolName,
      'educationLevel': educationLevel,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

/// Status da matrícula
enum EnrollmentStatus {
  received,    // Recebida
  analyzing,   // Em análise
  approved,    // Aprovada
  rejected,    // Rejeitada
  enrolled,    // Matriculado
}

/// Extensão para obter labels em português
extension EnrollmentStatusExtension on EnrollmentStatus {
  String get label {
    switch (this) {
      case EnrollmentStatus.received:
        return 'Recebida';
      case EnrollmentStatus.analyzing:
        return 'Em análise';
      case EnrollmentStatus.approved:
        return 'Aprovada';
      case EnrollmentStatus.rejected:
        return 'Rejeitada';
      case EnrollmentStatus.enrolled:
        return 'Matriculado';
    }
  }

  String get description {
    switch (this) {
      case EnrollmentStatus.received:
        return 'Sua solicitação foi recebida e aguarda análise.';
      case EnrollmentStatus.analyzing:
        return 'Sua solicitação está sendo analisada pela secretaria.';
      case EnrollmentStatus.approved:
        return 'Sua solicitação foi aprovada! Aguarde confirmação da matrícula.';
      case EnrollmentStatus.rejected:
        return 'Sua solicitação não foi aprovada. Verifique os motivos.';
      case EnrollmentStatus.enrolled:
        return 'Matrícula confirmada! O aluno está matriculado.';
    }
  }
}
