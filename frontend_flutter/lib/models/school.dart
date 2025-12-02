/// Modelo de Escola
class School {
  final String id;
  final String name;
  final String address;
  final String neighborhood;
  final List<String> educationLevels;
  final int totalVacancies;
  final int availableVacancies;
  final VacancyStatus vacancyStatus;

  School({
    required this.id,
    required this.name,
    required this.address,
    required this.neighborhood,
    required this.educationLevels,
    required this.totalVacancies,
    required this.availableVacancies,
    required this.vacancyStatus,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      neighborhood: json['neighborhood'] as String,
      educationLevels: List<String>.from(json['educationLevels'] as List),
      totalVacancies: json['totalVacancies'] as int,
      availableVacancies: json['availableVacancies'] as int,
      vacancyStatus: VacancyStatus.values.firstWhere(
        (e) => e.name == json['vacancyStatus'],
        orElse: () => VacancyStatus.available,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'neighborhood': neighborhood,
      'educationLevels': educationLevels,
      'totalVacancies': totalVacancies,
      'availableVacancies': availableVacancies,
      'vacancyStatus': vacancyStatus.name,
    };
  }
}

/// Status de disponibilidade de vagas
enum VacancyStatus {
  available,    // Vagas disponíveis
  limited,      // Poucas vagas
  waitingList,  // Lista de espera
  full,         // Sem vagas
}

extension VacancyStatusExtension on VacancyStatus {
  String get label {
    switch (this) {
      case VacancyStatus.available:
        return 'Vagas disponíveis';
      case VacancyStatus.limited:
        return 'Poucas vagas';
      case VacancyStatus.waitingList:
        return 'Lista de espera';
      case VacancyStatus.full:
        return 'Sem vagas';
    }
  }
}
