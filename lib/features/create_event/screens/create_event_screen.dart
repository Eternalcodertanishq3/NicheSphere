import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../../../shared/widgets/glass_text_field.dart';

/// NicheSphere — Create Event Screen (Screen 10)
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  int _step = 0;
  int _selectedCat = 0;
  XFile? _image;
  DateTime? _selectedDateTime;
  final _picker = ImagePicker();

  // Controllers for fields
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _sphereCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _durationCtrl.dispose();
    _locationCtrl.dispose();
    _capacityCtrl.dispose();
    _priceCtrl.dispose();
    _sphereCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.neonPink,
            onPrimary: Colors.white,
            surface: AppColors.gradEnd,
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (date != null) {
      if (!mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        if (!mounted) return;
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _image = image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              child: Row(children: [
                AppBackButton(
                  onTap: () {
                    if (_step > 0) {
                      setState(() => _step--);
                    } else {
                      context.go(RouteNames.home);
                    }
                  },
                ),
                const SizedBox(width: AppSpacing.sm12),
                Text('Create Event', style: AppTextStyles.titleXL),
                const Spacer(),
                Text('${_step + 1}/3', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
              ]),
            ),
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
              child: Row(children: List.generate(3, (i) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4, margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= _step ? AppColors.neonPink : AppColors.bubblePink,
                    borderRadius: AppBorderRadius.pill),
                )))),
            ),
            const SizedBox(height: AppSpacing.lg24),
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
              child: [_stepBasics(), _stepDetails(), _stepCommunity()][_step],
            )),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg24),
              child: AppButton(
                label: _step < 2 ? 'Next' : 'Publish Event',
                icon: _step < 2 ? Icons.arrow_forward_rounded : Icons.celebration_rounded,
                onTap: () {
                  if (_step < 2) { setState(() => _step++); }
                  else { context.go(RouteNames.home); }
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _stepBasics() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Event Basics', style: AppTextStyles.titleL).animate().fadeIn(),
      const SizedBox(height: AppSpacing.md20),
      GlassTextField(
        label: 'Event Name',
        hintText: 'Give it a catchy name',
        controller: _nameCtrl,
        prefixIcon: Icons.event_rounded,
      ),
      const SizedBox(height: AppSpacing.md16),
      GlassTextField(
        label: 'Description',
        hintText: 'What\'s happening?',
        controller: _descCtrl,
        prefixIcon: Icons.description_outlined,
        maxLines: 4,
      ),
      const SizedBox(height: AppSpacing.md20),
      Text('Category', style: AppTextStyles.titleM),
      const SizedBox(height: AppSpacing.sm12),
      SizedBox(height: 44, child: ListView.separated(
        scrollDirection: Axis.horizontal, itemCount: AppConstants.categories.length - 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = AppConstants.categories[i + 1];
          final isActive = _selectedCat == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCat = i),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.neonPink.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.5),
                borderRadius: AppBorderRadius.pill,
                border: Border.all(color: isActive ? AppColors.neonPink : Colors.white.withValues(alpha: 0.4))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(cat['emoji']!, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(cat['name']!, style: AppTextStyles.label.copyWith(color: isActive ? AppColors.neonPink : AppColors.textSecondary)),
              ])));
        },
      )),
    ]);
  }

  Widget _stepDetails() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Event Details', style: AppTextStyles.titleL).animate().fadeIn(),
      const SizedBox(height: AppSpacing.md20),
      // Image picker
      GestureDetector(
        onTap: _pickImage,
        child: GlassCard(
          blur: 10,
          opacity: 0.15,
          borderRadius: AppBorderRadius.xl,
          padding: _image == null ? const EdgeInsets.all(AppSpacing.xl40) : EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: _image == null ? null : 200,
            decoration: _image == null ? null : BoxDecoration(
              borderRadius: AppBorderRadius.xl,
              image: DecorationImage(image: FileImage(File(_image!.path)), fit: BoxFit.cover),
            ),
            child: _image == null ? Column(
              children: [
                const Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppColors.textHint),
                const SizedBox(height: 8),
                Text('Add Cover Image', style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary)),
              ],
            ) : const SizedBox.shrink(),
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md20),
      GlassTextField(
        label: 'Date & Time',
        hintText: _selectedDateTime == null ? 'When?' : DateFormat('MMM dd, h:mm a').format(_selectedDateTime!),
        prefixIcon: Icons.calendar_today_outlined,
        readOnly: true,
        onTap: _pickDateTime,
      ),
      const SizedBox(height: AppSpacing.md16),
      GlassTextField(
        label: 'Duration',
        hintText: 'e.g. 2 hours',
        controller: _durationCtrl,
        prefixIcon: Icons.timer_outlined,
      ),
      const SizedBox(height: AppSpacing.md16),
      GlassTextField(
        label: 'Location',
        hintText: 'Where?',
        controller: _locationCtrl,
        prefixIcon: Icons.location_on_outlined,
      ),
      const SizedBox(height: AppSpacing.md16),
      Row(children: [
        Expanded(
          child: GlassTextField(
            label: 'Capacity',
            hintText: 'Max attendees',
            controller: _capacityCtrl,
            prefixIcon: Icons.people_outline_rounded,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlassTextField(
            label: 'Price',
            hintText: 'Free or amount',
            controller: _priceCtrl,
            prefixIcon: Icons.attach_money_rounded,
          ),
        ),
      ]),
    ]);
  }

  Widget _stepCommunity() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Community & Tags', style: AppTextStyles.titleL).animate().fadeIn(),
      const SizedBox(height: AppSpacing.md20),
      GlassTextField(
        label: 'Sphere Link',
        hintText: 'Connect to a community',
        controller: _sphereCtrl,
        prefixIcon: Icons.hub_outlined,
      ),
      const SizedBox(height: AppSpacing.md16),
      GlassTextField(
        label: 'Tags',
        hintText: 'comma separated',
        controller: _tagsCtrl,
        prefixIcon: Icons.tag_rounded,
      ),
      const SizedBox(height: AppSpacing.md20),
      Text('Visibility', style: AppTextStyles.titleM),
      const SizedBox(height: AppSpacing.sm12),
      Row(children: ['Public', 'Friends Only', 'Private'].map((v) => Expanded(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GlassCard(blur: 10, opacity: v == 'Public' ? 0.3 : 0.15, borderRadius: AppBorderRadius.sm,
            glowColor: v == 'Public' ? AppColors.neonPink : null,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(child: Text(v, style: AppTextStyles.label.copyWith(
              color: v == 'Public' ? AppColors.neonPink : AppColors.textSecondary))))))).toList()),
    ]);
  }
}
