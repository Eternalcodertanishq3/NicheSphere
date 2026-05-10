import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../shared/widgets/pastel_bubble.dart';

final selectedInterestsProvider = StateProvider<Set<String>>((ref) => {});

class InterestSelectorScreen extends ConsumerWidget {
  const InterestSelectorScreen({super.key});

  final List<Map<String, dynamic>> interests = const [
    {'label': 'Anime', 'color': AppColors.bubblePink},
    {'label': 'Gaming', 'color': AppColors.bubbleBlue},
    {'label': 'Tech', 'color': AppColors.bubbleGreen},
    {'label': 'Music', 'color': AppColors.bubbleYellow},
    {'label': 'Art', 'color': AppColors.bubblePurple},
    {'label': 'Sports', 'color': AppColors.bubblePink},
    {'label': 'Food', 'color': AppColors.bubbleBlue},
    {'label': 'Travel', 'color': AppColors.bubbleGreen},
    {'label': 'Movies', 'color': AppColors.bubbleYellow},
    {'label': 'Books', 'color': AppColors.bubblePurple},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedInterests = ref.watch(selectedInterestsProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundPastel,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'What are you into?',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'Select at least 3 interests to personalize your feed.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 16,
                      children: interests.map((interest) {
                        final label = interest['label'] as String;
                        final color = interest['color'] as Color;
                        final isSelected = selectedInterests.contains(label);

                        return PastelBubble(
                          label: label,
                          color: color,
                          isSelected: isSelected,
                          onTap: () {
                            final current = ref.read(selectedInterestsProvider);
                            if (current.contains(label)) {
                              ref.read(selectedInterestsProvider.notifier).state =
                                  Set.from(current)..remove(label);
                            } else {
                              ref.read(selectedInterestsProvider.notifier).state =
                                  Set.from(current)..add(label);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: selectedInterests.length >= 3
                        ? () => context.go('/home')
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryPastel,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      disabledBackgroundColor: AppColors.surfacePastel,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
