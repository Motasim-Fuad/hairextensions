/// Line icons exported from the Figma file (Lucide geometry). Each SVG is a
/// single stroke color, so it is recolored at render time.
enum AppIcon {
  alert,
  briefcase,
  calendar,
  check,
  chevronDown('chevron_down'),
  chevronLeft('chevron_left'),
  chevronRight('chevron_right'),
  chevronUp('chevron_up'),
  clock,
  close,
  copy,
  crown,
  download,
  eye,
  eyeOff('eye_off'),
  file,
  filter,
  hash,
  help,
  home,
  link,
  lock,
  mail,
  message,
  more,
  package,
  palette,
  pen,
  percent,
  plus,
  refresh,
  scissors,
  search,
  share,
  shield,
  sliders,
  star,
  trash,
  trend,
  truck,
  upload,
  user,
  wallet;

  const AppIcon([this._file]);

  final String? _file;

  String get assetPath => 'assets/icons/${_file ?? name}.svg';
}
