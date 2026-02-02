import 'package:flutter/material.dart';

/// Custom button with color #fbbf24.
/// [enabled] false → grey, masky disabled look. [isLoading] → spinner.
/// [trailingAtEnd] true → text centered, trailing at right (e.g. login arrow).
class AppButton extends StatelessWidget {
  static const Color _primaryColor = Color(0xFFFBBF24);
  static const Color _disabledColor = Color(0xFFD9D9D9);

  final String text;
  final VoidCallback? onPressed;
  final  bool enabled;
  final bool isLoading;
  final double? height;
  final double? minWidth;
  final double borderRadius;
  final TextStyle? textStyle;
  final Widget? leading;
  final Widget? trailing;
  final bool trailingAtEnd;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = false,
    this.isLoading = false,
    this.height,
    this.minWidth,
    this.borderRadius = 12,
    this.textStyle,
    this.leading,
    this.trailing,
    this.trailingAtEnd = false,
  });

  // bool get _canTap => enabled && !isLoading && onPressed != null;

  Color _textColor(TextStyle style) =>
      enabled ? (style.color ?? Colors.black87) : Colors.white;

  Widget _buildContent(TextStyle style) {
    final textWidget = Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: style.copyWith(color: _textColor(style)),
    );
    if (trailingAtEnd && trailing != null) {
      return Row(
        children: [
          Expanded(child: Center(child: textWidget)),
          trailing!,
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 10)],
        Flexible(child: textWidget),
        if (trailing != null && !trailingAtEnd) ...[
          const SizedBox(width: 10),
          trailing!,
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? 48;
    final style = textStyle ??
        const TextStyle(
          fontFamily: 'Source Sans 3',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        );

    return SizedBox(
      height: effectiveHeight,
      width: minWidth ?? double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed! : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            decoration: BoxDecoration(
              color: enabled ? _primaryColor : _disabledColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: _primaryColor.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                      ),
                    )
                  : _buildContent(style),
            ),
          ),
        ),
      ),
    );
  }
}
