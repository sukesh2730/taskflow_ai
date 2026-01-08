import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/log.dart';
import '../providers/app_providers.dart';

class LogStateSheet extends ConsumerStatefulWidget {
  const LogStateSheet({super.key});

  @override
  ConsumerState<LogStateSheet> createState() => _LogStateSheetState();
}

class _LogStateSheetState extends ConsumerState<LogStateSheet> {
  int energy = 5;
  String mood = "Neutral";
  final List<String> moods = ["Neutral", "Focused", "Stressed", "Creative", "Tired"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("How are you feeling?", style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Text("Energy Level: $energy/10"),
          Slider(
            value: energy.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: energy.toString(),
            onChanged: (v) => setState(() => energy = v.toInt()),
          ),
          const SizedBox(height: 10),
          Text("Current Mood"),
          Wrap(
            spacing: 8,
            children: moods.map((m) {
              return ChoiceChip(
                label: Text(m),
                selected: mood == m,
                onSelected: (s) => setState(() => mood = m),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                final log = UserLog(energyLevel: energy, mood: mood);
                await ref.read(apiServiceProvider).logState(log);
                if (mounted) Navigator.pop(context);
              },
              child: const Text("Update AI Model"),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
