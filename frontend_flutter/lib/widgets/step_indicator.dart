import 'package:flutter/material.dart';

/// Indicador de passos para fluxos multi-etapas
/// Exibe visualmente o progresso do usuário
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          // Índice par = círculo do passo
          // Índice ímpar = linha conectora
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            return _buildStep(
              context,
              stepIndex: stepIndex,
              label: steps[stepIndex],
              isCompleted: stepIndex < currentStep,
              isCurrent: stepIndex == currentStep,
            );
          } else {
            final stepIndex = index ~/ 2;
            return _buildConnector(
              context,
              isCompleted: stepIndex < currentStep,
            );
          }
        }),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required int stepIndex,
    required String label,
    required bool isCompleted,
    required bool isCurrent,
  }) {
    final theme = Theme.of(context);
    
    Color backgroundColor;
    Color textColor;
    Widget child;

    if (isCompleted) {
      backgroundColor = theme.colorScheme.primary;
      textColor = Colors.white;
      child = const Icon(Icons.check, size: 16, color: Colors.white);
    } else if (isCurrent) {
      backgroundColor = theme.colorScheme.primary;
      textColor = Colors.white;
      child = Text(
        '${stepIndex + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    } else {
      backgroundColor = Colors.grey.shade300;
      textColor = Colors.grey.shade600;
      child = Text(
        '${stepIndex + 1}',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(child: child),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent ? theme.colorScheme.primary : textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(BuildContext context, {required bool isCompleted}) {
    return Container(
      height: 2,
      width: 20,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted
          ? Theme.of(context).colorScheme.primary
          : Colors.grey.shade300,
    );
  }
}
