import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Reusable input field adhering to the NEXUS design system.
/// Features a dedicated top label, custom prefix/suffix icons,
/// and smooth validation state handling.
class CustomTextField extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.onFieldSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          enabled: enabled,
          onFieldSubmitted: onFieldSubmitted,
          cursorColor: AppColors.primaryPurple,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.placeholderText,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: enabled ? AppColors.inputBackground : Colors.grey.shade100,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.secondaryText,
                    size: 20,
                  )
                : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.inputFocusedBorder,
                width: 1.8,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.8,
              ),
            ),
            errorStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }
}

