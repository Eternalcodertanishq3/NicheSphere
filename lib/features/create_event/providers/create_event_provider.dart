// NicheSphere — Create Event Provider (Phase 2)
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../../data/models/event_model.dart';

/// Multi-step form state
class CreateEventFormState {
  final int currentStep;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final DateTime? startAt;
  final DateTime? endAt;
  final String locationName;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final File? imageFile;
  final String? imageUrl;
  final int maxAttendees;
  final bool isFree;
  final double? price;
  final bool isSubmitting;
  final String? error;

  const CreateEventFormState({
    this.currentStep = 0,
    this.title = '',
    this.description = '',
    this.category = '',
    this.tags = const [],
    this.startAt,
    this.endAt,
    this.locationName = '',
    this.locationAddress = '',
    this.latitude = 0,
    this.longitude = 0,
    this.imageFile,
    this.imageUrl,
    this.maxAttendees = 0,
    this.isFree = true,
    this.price,
    this.isSubmitting = false,
    this.error,
  });

  CreateEventFormState copyWith({
    int? currentStep,
    String? title,
    String? description,
    String? category,
    List<String>? tags,
    DateTime? startAt,
    DateTime? endAt,
    String? locationName,
    String? locationAddress,
    double? latitude,
    double? longitude,
    File? imageFile,
    String? imageUrl,
    int? maxAttendees,
    bool? isFree,
    double? price,
    bool? isSubmitting,
    String? error,
  }) {
    return CreateEventFormState(
      currentStep: currentStep ?? this.currentStep,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      locationName: locationName ?? this.locationName,
      locationAddress: locationAddress ?? this.locationAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      isFree: isFree ?? this.isFree,
      price: price ?? this.price,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

class CreateEventNotifier extends Notifier<CreateEventFormState> {
  @override
  CreateEventFormState build() => const CreateEventFormState();

  void nextStep() => state = state.copyWith(currentStep: state.currentStep + 1);
  void prevStep() => state = state.copyWith(currentStep: state.currentStep - 1);

  void updateField({
    String? title,
    String? description,
    String? category,
    List<String>? tags,
    DateTime? startAt,
    DateTime? endAt,
    String? locationName,
    String? locationAddress,
    double? latitude,
    double? longitude,
    File? imageFile,
    int? maxAttendees,
    bool? isFree,
    double? price,
  }) {
    state = state.copyWith(
      title: title,
      description: description,
      category: category,
      tags: tags,
      startAt: startAt,
      endAt: endAt,
      locationName: locationName,
      locationAddress: locationAddress,
      latitude: latitude,
      longitude: longitude,
      imageFile: imageFile,
      maxAttendees: maxAttendees,
      isFree: isFree,
      price: price,
    );
  }

  Future<String?> submit() async {
    state = state.copyWith(isSubmitting: true, error: null);

    // Upload image first if provided
    String imageUrl = '';
    if (state.imageFile != null) {
      final uploadResult = await ref
          .read(storageServiceProvider)
          .uploadEventImage(state.imageFile!);
      final url = uploadResult.fold((_) => null, (url) => url);
      if (url == null) {
        state = state.copyWith(
            isSubmitting: false, error: 'Failed to upload image');
        return 'Failed to upload image';
      }
      imageUrl = url;
    }

    final event = EventModel(
      id: '',
      title: state.title,
      description: state.description,
      category: state.category,
      tags: state.tags,
      startAt: state.startAt ?? DateTime.now().add(const Duration(days: 1)),
      endAt:
          state.endAt ?? DateTime.now().add(const Duration(days: 1, hours: 2)),
      locationName: state.locationName,
      locationAddress: state.locationAddress,
      latitude: state.latitude,
      longitude: state.longitude,
      imageUrl: imageUrl,
      maxAttendees: state.maxAttendees,
      isFree: state.isFree,
      price: state.price,
      organizerId: '',
      organizerName: '',
      createdAt: DateTime.now(),
      isFeatured: false,
    );

    final result = await ref.read(eventRepositoryProvider).createEvent(event);
    return result.fold(
      (f) {
        state = state.copyWith(isSubmitting: false, error: f.message);
        return f.message;
      },
      (id) {
        state = const CreateEventFormState(); // Reset form
        return null;
      },
    );
  }
}

final createEventNotifierProvider =
    NotifierProvider<CreateEventNotifier, CreateEventFormState>(() => CreateEventNotifier());
