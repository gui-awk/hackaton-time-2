import '../models/school.dart';

/// Serviço de Escolas - Mock para MVP
/// TODO: Substituir por chamadas reais à API Java quando disponível
class SchoolService {
  /// Retorna lista de escolas disponíveis (dados simulados)
  static Future<List<School>> getSchools() async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockSchools;
  }

  /// Retorna escolas filtradas por nível de ensino
  static Future<List<School>> getSchoolsByLevel(String educationLevel) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _mockSchools
        .where((school) => school.educationLevels.contains(educationLevel))
        .toList();
  }

  /// Retorna escola por ID
  static Future<School?> getSchoolById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _mockSchools.firstWhere((school) => school.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Dados mock de escolas
  static final List<School> _mockSchools = [
    School(
      id: '1',
      name: 'EMEI Monteiro Lobato',
      address: 'Rua das Flores, 123',
      neighborhood: 'Centro',
      educationLevels: ['Educação Infantil'],
      totalVacancies: 120,
      availableVacancies: 15,
      vacancyStatus: VacancyStatus.limited,
    ),
    School(
      id: '2',
      name: 'EMEF Paulo Freire',
      address: 'Av. Brasil, 456',
      neighborhood: 'Jardim América',
      educationLevels: ['Ensino Fundamental I', 'Ensino Fundamental II'],
      totalVacancies: 300,
      availableVacancies: 45,
      vacancyStatus: VacancyStatus.available,
    ),
    School(
      id: '3',
      name: 'EMEI Cecília Meireles',
      address: 'Rua das Palmeiras, 789',
      neighborhood: 'Vila Nova',
      educationLevels: ['Educação Infantil'],
      totalVacancies: 80,
      availableVacancies: 0,
      vacancyStatus: VacancyStatus.waitingList,
    ),
    School(
      id: '4',
      name: 'EMEF Anísio Teixeira',
      address: 'Rua do Comércio, 321',
      neighborhood: 'Centro',
      educationLevels: ['Ensino Fundamental I', 'Ensino Fundamental II'],
      totalVacancies: 250,
      availableVacancies: 78,
      vacancyStatus: VacancyStatus.available,
    ),
    School(
      id: '5',
      name: 'EMEI Ruth Rocha',
      address: 'Av. das Nações, 555',
      neighborhood: 'Parque Industrial',
      educationLevels: ['Educação Infantil'],
      totalVacancies: 100,
      availableVacancies: 5,
      vacancyStatus: VacancyStatus.limited,
    ),
    School(
      id: '6',
      name: 'EMEF Darcy Ribeiro',
      address: 'Rua São Paulo, 100',
      neighborhood: 'Boa Vista',
      educationLevels: ['Ensino Fundamental I', 'Ensino Fundamental II'],
      totalVacancies: 400,
      availableVacancies: 0,
      vacancyStatus: VacancyStatus.full,
    ),
  ];

  /// Níveis de ensino disponíveis
  static const List<String> educationLevels = [
    'Educação Infantil',
    'Ensino Fundamental I',
    'Ensino Fundamental II',
  ];
}
