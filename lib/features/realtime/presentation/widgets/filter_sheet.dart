import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../data/event_models.dart';
import 'event_tile.dart';

Future<EventFilters?> showFilterSheet(
  BuildContext context, {
  required EventFilters current,
  required List<String> eventNames,
  required List<String> countries,
}) {
  return showModalBottomSheet<EventFilters>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _FilterSheet(
      current: current,
      eventNames: eventNames,
      countries: countries,
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.current,
    required this.eventNames,
    required this.countries,
  });

  final EventFilters current;
  final List<String> eventNames;
  final List<String> countries;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late EventFilters _f = widget.current;

  static const _devices = ['desktop', 'mobile', 'tablet'];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final names = {
      ...widget.eventNames,
      if (_f.eventName != null) _f.eventName!,
    }.toList()..sort();
    final countries = {
      ...widget.countries,
      if (_f.country != null) _f.country!,
    }.toList()..sort();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text('Filters', style: t.titleMedium),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => _f = const EventFilters()),
                    child: const Text('Reset'),
                  ),
                ],
              ),
              // These are client-side predicates over the loaded page, and a
              // filtered "no events" reads as "your site had no traffic" unless
              // the scope is stated.
              Text(
                'Applied to the events already on the feed (the latest 100), not '
                'the whole date range.',
                style: t.bodySmall?.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _f.eventName,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Event name',
                  prefixIcon: Icon(Icons.bolt_rounded, size: 20),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All events'),
                  ),
                  for (final n in names)
                    DropdownMenuItem(
                      value: n,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: eventColor(n),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(n, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                ],
                onChanged: (v) =>
                    setState(() => _f = _f.copyWith(eventName: () => v)),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String?>(
                initialValue: _f.country,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  prefixIcon: Icon(Icons.public_rounded, size: 20),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All countries'),
                  ),
                  for (final c in countries)
                    DropdownMenuItem(
                      value: c,
                      child: Row(
                        children: [
                          CountryFlagIcon(c),
                          const SizedBox(width: 10),
                          Text(c),
                        ],
                      ),
                    ),
                ],
                onChanged: (v) =>
                    setState(() => _f = _f.copyWith(country: () => v)),
              ),
              const SizedBox(height: 16),
              Text(
                'Device',
                style: t.labelLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _f.device == null,
                    onSelected: (_) =>
                        setState(() => _f = _f.copyWith(device: () => null)),
                  ),
                  for (final d in _devices)
                    ChoiceChip(
                      avatar: Icon(
                        deviceIcon(EventDevice(device: d)),
                        size: 16,
                      ),
                      label: Text(d[0].toUpperCase() + d.substring(1)),
                      selected: _f.device == d,
                      onSelected: (_) =>
                          setState(() => _f = _f.copyWith(device: () => d)),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(_f),
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
