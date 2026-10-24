part of 'add_service_cubit.dart';

final class AddServiceState extends Equatable {
  const AddServiceState({
    this.templates = const [],
    this.templateId,
    this.name = '',
    this.isHourly = true,
    this.rateMinor = 0,
    this.hours = 0,
    this.isTaxable = true,
    this.showErrors = false,
  });

  final List<ServiceTemplate> templates;
  final String? templateId;
  final String name;
  final bool isHourly;
  final int rateMinor;
  final double hours;
  final bool isTaxable;
  final bool showErrors;

  int get chargeMinor => isHourly ? (rateMinor * hours).round() : rateMinor;

  bool get showNameError => showErrors && name.trim().isEmpty;

  bool get showHoursError => showErrors && isHourly && hours <= 0;

  bool get isValid => name.trim().isNotEmpty && (!isHourly || hours > 0);

  AddServiceState copyWith({
    List<ServiceTemplate>? templates,
    String? templateId,
    String? name,
    bool? isHourly,
    int? rateMinor,
    double? hours,
    bool? isTaxable,
    bool? showErrors,
  }) {
    return AddServiceState(
      templates: templates ?? this.templates,
      templateId: templateId ?? this.templateId,
      name: name ?? this.name,
      isHourly: isHourly ?? this.isHourly,
      rateMinor: rateMinor ?? this.rateMinor,
      hours: hours ?? this.hours,
      isTaxable: isTaxable ?? this.isTaxable,
      showErrors: showErrors ?? this.showErrors,
    );
  }

  @override
  List<Object?> get props => [templates, templateId, name, isHourly, rateMinor, hours, isTaxable, showErrors];
}
