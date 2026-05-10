import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../shared/models/event.dart';
import '../../shared/widgets/glass_card.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    // Mocking finding the event. In a real app, this would come from a provider or Firestore.
    final event = Event(
      id: eventId,
      title: 'Sunset Yoga Session',
      description: 'Join us for a relaxing yoga session at the beach as the sun sets. All levels welcome! We will start with a gentle flow and end with a guided meditation. Bring your own mat and some water.',
      category: 'Wellness',
      startAt: DateTime.now().add(const Duration(days: 1)),
      locationName: 'Santa Monica Beach',
      lat: 34.0195,
      lng: -118.4912,
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&q=80&w=800',
      attendeeCount: 15,
      organizerName: 'YogaWithSarah',
    );

    return Scaffold(
      body: Stack(
        children: [
          // Hero Image
          Hero(
            tag: 'event-image-$eventId',
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(event.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 48,
            left: 20,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: const GlassCard(
                blur: 10,
                opacity: 0.3,
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.5),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPastel,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              event.category.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.people, size: 20, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${event.attendeeCount} attending',
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 24),
                      
                      // Info Panel
                      GlassCard(
                        color: AppColors.secondaryPastel,
                        opacity: 0.2,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.calendar_month_rounded, 'Date & Time', 
                                DateFormat('EEEE, MMM dd • hh:mm a').format(event.startAt)),
                            const Divider(height: 32, color: Colors.black12),
                            _buildInfoRow(Icons.location_on_rounded, 'Location', event.locationName),
                            const Divider(height: 32, color: Colors.black12),
                            _buildInfoRow(Icons.person_rounded, 'Organizer', event.organizerName),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      Text(
                        'About this event',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryPastel,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Attend Event', 
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfacePastel,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.share_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.black87),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
