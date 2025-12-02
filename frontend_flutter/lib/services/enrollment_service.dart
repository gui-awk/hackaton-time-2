import '../models/enrollment.dart';

/// Serviço de Matrículas - Mock para MVP
/// TODO: Substituir por chamadas reais à API Java quando disponível
class EnrollmentService {
  static int _protocolCounter = 2024001;

  /// Cria uma nova solicitação de matrícula
  static Future<Enrollment> createEnrollment({
    required String studentName,
    required String responsibleName,
    required String responsibleCpf,
    required String responsiblePhone,
    required String schoolId,
    required String schoolName,
    required String educationLevel,
  }) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    final protocolNumber = 'MAT${_protocolCounter++}';

    return Enrollment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      protocolNumber: protocolNumber,
      studentName: studentName,
      responsibleName: responsibleName,
      responsibleCpf: responsibleCpf,
      responsiblePhone: responsiblePhone,
      schoolName: schoolName,
      educationLevel: educationLevel,
      status: EnrollmentStatus.received,
      createdAt: now,
    );
  }

  /// Consulta status de uma matrícula pelo protocolo
  static Future<Enrollment?> getEnrollmentByProtocol(String protocol) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: Implementar busca real na API
    return null;
  }

  /// Lista matrículas do cidadão
  static Future<List<Enrollment>> getCitizenEnrollments(String citizenId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implementar busca real na API
    return [];
  }
}
