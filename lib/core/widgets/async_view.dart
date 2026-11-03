import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buildstock/app/theme/app_theme.dart';

/// Standard loading / error / empty wrapper for Riverpod async values.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.builder,
    this.loading,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final Widget? loading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: builder,
      loading: () =>
          loading ??
          const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.danger,
                size: 28,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Could not load this data',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.color,
    this.background,
    this.icon,
  });

  factory StatusPill.sync(String status) {
    return switch (status) {
      'synced' => const StatusPill(
        label: 'Synced',
        color: AppColors.success,
        background: AppColors.successSoft,
        icon: Icons.cloud_done_outlined,
      ),
      'failed' => const StatusPill(
        label: 'Sync failed',
        color: AppColors.danger,
        background: AppColors.dangerSoft,
        icon: Icons.cloud_off_outlined,
      ),
      'conflict' => const StatusPill(
        label: 'Needs review',
        color: AppColors.warning,
        background: AppColors.warningSoft,
        icon: Icons.compare_arrows,
      ),
      _ => const StatusPill(
        label: 'Pending',
        color: AppColors.info,
        background: AppColors.infoSoft,
        icon: Icons.cloud_upload_outlined,
      ),
    };
  }

  factory StatusPill.document(String status) {
    return switch (status) {
      'finalized' => const StatusPill(
        label: 'Finalized',
        color: AppColors.success,
        background: AppColors.successSoft,
      ),
      'cancelled' => const StatusPill(
        label: 'Cancelled',
        color: AppColors.danger,
        background: AppColors.dangerSoft,
      ),
      'draft' => const StatusPill(
        label: 'Draft',
        color: AppColors.warning,
        background: AppColors.warningSoft,
      ),
      _ => StatusPill(
        label: status,
        color: AppColors.info,
        background: AppColors.infoSoft,
      ),
    };
  }

  final String label;
  final Color? color;
  final Color? background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background ?? AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color ?? AppColors.lightSecondary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: color ?? AppColors.lightSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Search',
    this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                  onClear?.call();
                },
              ),
        isDense: true,
      ),
    );
  }
}

class LabeledValue extends StatelessWidget {
  const LabeledValue({
    super.key,
    required this.label,
    required this.value,
    this.emphasize = false,
    this.color,
    this.align = CrossAxisAlignment.start,
  });

  final String label;
  final String value;
  final bool emphasize;
  final Color? color;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(fontSize: 9.5),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: align == CrossAxisAlignment.end
              ? TextAlign.right
              : TextAlign.left,
          style: emphasize
              ? theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                )
              : theme.textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}

class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: (color ?? AppColors.accent).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: color ?? AppColors.accent,
        ),
      ),
    );
  }
}
