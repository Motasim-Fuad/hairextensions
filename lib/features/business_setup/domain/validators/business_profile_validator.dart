import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/features/business_setup/domain/constants/business_profile_limits.dart';
import 'package:hairextensions/features/business_setup/domain/entities/business_profile_draft.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field_error.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_step.dart';

/// Pure validation per step, so the same rules back the wizard, the edit
/// screens and, later, any server-side mirror.
abstract final class BusinessProfileValidator {
  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final RegExp _url = RegExp(r'^(https?:\/\/)?([\w-]+\.)+[\w-]{2,}(\/\S*)?$', caseSensitive: false);
  static final RegExp _phoneAllowed = RegExp(r'^\+?[\d\s\-().]+$');
  static final RegExp _nonDigit = RegExp(r'\D');

  static Map<SetupField, SetupFieldError> validate(SetupStep step, BusinessProfileDraft draft) {
    final errors = <SetupField, SetupFieldError>{};
    void check(SetupField field, SetupFieldError? error) {
      if (error != null) {
        errors[field] = error;
      }
    }

    switch (step) {
      case SetupStep.identity:
        check(SetupField.businessName, _required(draft, SetupField.businessName, BusinessProfileLimits.nameMaxLength));
        check(SetupField.ownerName, _maxLength(draft, SetupField.ownerName, BusinessProfileLimits.nameMaxLength));
        check(SetupField.tagline, _maxLength(draft, SetupField.tagline, BusinessProfileLimits.taglineMaxLength));
      case SetupStep.contact:
        check(SetupField.phone, _phone(draft.optionalValueOf(SetupField.phone)));
        check(
          SetupField.email,
          _pattern(draft.optionalValueOf(SetupField.email), _email, SetupFieldError.invalidEmail),
        );
        check(SetupField.instagram, _maxLength(draft, SetupField.instagram, BusinessProfileLimits.contactMaxLength));
        check(
          SetupField.website,
          _pattern(draft.optionalValueOf(SetupField.website), _url, SetupFieldError.invalidUrl),
        );
        check(SetupField.address, _maxLength(draft, SetupField.address, BusinessProfileLimits.addressMaxLength));
      case SetupStep.quoteDefaults:
        check(SetupField.taxRate, _percent(draft.optionalValueOf(SetupField.taxRate)));
        check(
          SetupField.depositValue,
          draft.depositType == DepositType.percent
              ? _percent(draft.optionalValueOf(SetupField.depositValue))
              : _amount(draft.optionalValueOf(SetupField.depositValue)),
        );
        check(
          SetupField.paymentLink,
          _pattern(draft.optionalValueOf(SetupField.paymentLink), _url, SetupFieldError.invalidUrl),
        );
        check(SetupField.defaultNote, _maxLength(draft, SetupField.defaultNote, BusinessProfileLimits.noteMaxLength));
        check(SetupField.validityDays, _days(draft.optionalValueOf(SetupField.validityDays)));
    }
    return errors;
  }

  static SetupFieldError? _required(BusinessProfileDraft draft, SetupField field, int maxLength) {
    if (draft.optionalValueOf(field) == null) {
      return SetupFieldError.required;
    }
    return _maxLength(draft, field, maxLength);
  }

  static SetupFieldError? _maxLength(BusinessProfileDraft draft, SetupField field, int maxLength) {
    return draft.valueOf(field).trim().length > maxLength ? SetupFieldError.tooLong : null;
  }

  static SetupFieldError? _pattern(String? value, RegExp pattern, SetupFieldError error) {
    if (value == null) {
      return null;
    }
    return pattern.hasMatch(value) ? null : error;
  }

  static SetupFieldError? _phone(String? value) {
    if (value == null) {
      return null;
    }
    final digits = value.replaceAll(_nonDigit, '').length;
    final valid =
        _phoneAllowed.hasMatch(value) &&
        digits >= BusinessProfileLimits.phoneMinDigits &&
        digits <= BusinessProfileLimits.phoneMaxDigits;
    return valid ? null : SetupFieldError.invalidPhone;
  }

  static SetupFieldError? _percent(String? value) {
    if (value == null) {
      return SetupFieldError.required;
    }
    final parsed = double.tryParse(value);
    if (parsed == null || parsed < 0 || parsed > BusinessProfileLimits.maxPercent) {
      return SetupFieldError.invalidPercent;
    }
    return null;
  }

  static SetupFieldError? _amount(String? value) {
    if (value == null) {
      return SetupFieldError.required;
    }
    final parsed = double.tryParse(value);
    return parsed == null || parsed < 0 ? SetupFieldError.invalidAmount : null;
  }

  static SetupFieldError? _days(String? value) {
    if (value == null) {
      return SetupFieldError.required;
    }
    final parsed = int.tryParse(value);
    if (parsed == null ||
        parsed < BusinessProfileLimits.minValidityDays ||
        parsed > BusinessProfileLimits.maxValidityDays) {
      return SetupFieldError.invalidDays;
    }
    return null;
  }
}
