import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Cupertino-style icons available as self-hosted SVG assets.
enum CupertinoIconName {
  sunMax('sun_max'),
  moon('moon'),
  bars('bars'),
  xmark('xmark'),
  devicePhonePortrait('device_phone_portrait'),
  cloudFill('cloud_fill'),
  sparkles('sparkles'),
  gear('gear'),
  globe('globe'),
  waveform('waveform'),
  bolt('bolt'),
  textformatAbc('textformat_abc'),
  chevronLeftSlashChevronRight('chevron_left_slash_chevron_right'),
  paintbrushFill('paintbrush_fill'),
  archivebox('archivebox'),
  micFill('mic_fill'),
  lockShieldFill('lock_shield_fill'),
  bookFill('book_fill'),
  eyeFill('eye_fill'),
  photoFill('photo_fill'),
  arrowRight('arrow_right'),
  linkCircleFill('link_circle_fill'),
  personCropRectangleFill('person_crop_rectangle_fill'),
  envelopeFill('envelope_fill'),
  chatBubble2Fill('chat_bubble_2_fill');

  const CupertinoIconName(this.filename);

  /// The asset file name under `/icons/`.
  final String filename;

  String get slug => filename.replaceAll('_', '-');

  String get path => '/icons/$filename.svg';

  String get className => 'cupertino-icon--$slug';
}

/// Standard icon sizes, in pixels.
enum CupertinoIconSize {
  sm(16),
  md(20),
  lg(28),
  xl(64);

  const CupertinoIconSize(this.size);

  final double size;

  String get className => 'cupertino-icon--$name';
}

/// Semantic palette slots used to tint masked icons while staying theme-aware.
enum CupertinoIconColor {
  current(null),
  primary('--primary'),
  blue('--accent-blue'),
  green('--accent-green'),
  red('--accent-red'),
  purple('--accent-purple'),
  teal('--link-teal'),
  onPrimary('--on-primary');

  const CupertinoIconColor(this.variableName);

  /// The CSS variable backing this palette slot, or null for inherited color.
  final String? variableName;

  String get className => 'cupertino-icon-color--$name';
}

/// Renders a masked, theme-aware Cupertino SVG icon.
class CupertinoIcon extends StatelessComponent {
  const CupertinoIcon({
    required this.icon,
    this.color = CupertinoIconColor.current,
    this.size = CupertinoIconSize.md,
    this.label,
    this.classes,
    super.key,
  });

  final CupertinoIconName icon;
  final CupertinoIconColor color;
  final CupertinoIconSize size;

  /// When set, the icon is announced as an image; otherwise it is decorative.
  final String? label;
  final String? classes;

  @override
  Component build(BuildContext context) {
    final resolvedClasses = [
      'cupertino-icon',
      icon.className,
      if (color != CupertinoIconColor.current) color.className,
      size.className,
      if (classes case final extraClasses? when extraClasses.isNotEmpty) extraClasses,
    ];
    final resolvedAttributes = switch (label) {
      final accessibleLabel? => {
        'role': 'img',
        'aria-label': accessibleLabel,
      },
      null => const {'aria-hidden': 'true'},
    };

    return span(
      classes: resolvedClasses.join(' '),
      attributes: resolvedAttributes,
      const [],
    );
  }
}
