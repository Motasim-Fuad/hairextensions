import 'package:equatable/equatable.dart';

class DocumentRow extends Equatable {
  const DocumentRow({required this.label, required this.value, this.isEmphasized = false});

  final String label;
  final String value;
  final bool isEmphasized;

  @override
  List<Object?> get props => [label, value, isEmphasized];
}
