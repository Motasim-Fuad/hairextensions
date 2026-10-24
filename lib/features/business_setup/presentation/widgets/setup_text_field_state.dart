part of 'setup_text_field.dart';

class _SetupTextFieldState extends State<SetupTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: context.read<BusinessSetupBloc>().state.draft.valueOf(widget.field));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    context.read<BusinessSetupBloc>().add(BusinessSetupFieldChanged(widget.field, value));
  }

  @override
  Widget build(BuildContext context) {
    final decimals = widget.decimals;
    return BlocSelector<BusinessSetupBloc, BusinessSetupState, SetupFieldError?>(
      selector: (state) => state.errorFor(widget.field),
      builder: (context, error) {
        return AppTextField(
          controller: _controller,
          label: widget.label,
          hintText: widget.hintText,
          helperText: widget.helperText,
          isRequired: widget.isRequired,
          errorText: error?.message(context.l10n),
          keyboardType: decimals == null ? widget.keyboardType : TextInputType.numberWithOptions(decimal: decimals > 0),
          inputFormatters: decimals == null ? null : [DecimalTextInputFormatter(decimals: decimals)],
          textInputAction: widget.maxLines > 1 ? TextInputAction.newline : widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          autofillHints: widget.autofillHints,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          prefixText: widget.prefixText == null ? null : '${widget.prefixText} ',
          suffixText: widget.suffixText,
          suffixIcon: widget.suffixIcon,
          onChanged: _onChanged,
        );
      },
    );
  }
}
