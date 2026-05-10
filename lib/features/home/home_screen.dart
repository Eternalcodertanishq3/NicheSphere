import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../shared/models/event.dart';
import '../../shared/widgets/event_card.dart';
import '../../shared/widgets/glass_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Event> mockEvents = [
    Event(
      id: '1',
      title: 'Sunset Yoga Session',
      description: 'Join us for a relaxing yoga session at the beach as the sun sets. All levels welcome!',
      category: 'Wellness',
      startAt: DateTime.now().add(const Duration(days: 1)),
      locationName: 'Santa Monica Beach',
      lat: 34.0195,
      lng: -118.4912,
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&q=80&w=800',
      attendeeCount: 15,
      organizerName: 'YogaWithSarah',
    ),
    Event(
      id: '2',
      title: 'Indie Game Playtest',
      description: 'Be the first to try out our new local multiplayer game! Free snacks and good vibes.',
      category: 'Gaming',
      startAt: DateTime.now().add(const Duration(days: 2)),
      locationName: 'Cyber Cafe, Downtown',
      lat: 34.0522,
      lng: -118.2437,
      imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&q=80&w=800',
      attendeeCount: 8,
      organizerName: 'PixelStudio',
    ),
    Event(
      id: '3',
      title: 'Pastel Painting Workshop',
      description: 'Learn the basics of pastel painting in this guided workshop. Materials provided.',
      category: 'Art',
      startAt: DateTime.now().add(const Duration(days: 3)),
      locationName: 'The Art House',
      lat: 34.0407,
      lng: -118.2673,
      imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&q=80&w=800',
      attendeeCount: 12,
      organizerName: 'ArtLoop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPastel,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.backgroundPastel,
                  Colors.white,
                  AppColors.secondaryPastel,
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 60,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Discover',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                            ),
                            Text(
                              'Nearby Events',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=nichesphere'),
                        ),
                      ],
                    ),
                  ),

                  // Category Row
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildCategoryChip('All', true),
                        _buildCategoryChip('Gaming', false),
                        _buildCategoryChip('Wellness', false),
                        _buildCategoryChip('Art', false),
                        _buildCategoryChip('Music', false),
                      ],
                    ),
                  ),

                  // Carousel
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 420,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: mockEvents.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                          event: mockEvents[index],
                          onTap: () => context.go('/home/details/${mockEvents[index].id}'),
                        ).animate().fadeIn(delay: (200 * index).ms).slideX(begin: 0.2, end: 0);
                      },
                    ),
                  ),

                  // Upcoming Near You
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Upcoming Near You',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: mockEvents.length,
                    itemBuilder: (context, index) {
                      final event = mockEvents[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: GlassCard(
                          opacity: 0.3,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  event.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${DateFormat('MMM dd, hh:mm a').format(event.startAt)}',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.people, size: 14, color: AppColors.bubbleBlue),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${event.attendeeCount} attending',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100), // BottomNav padding
                ],
              ),
            ),
          ),

          // Bottom Navigation
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: GlassCard(
              blur: 20,
              opacity: 0.6,
              padding: const EdgeInsets.symmetric(vertical: 8),
              borderRadius: BorderRadius.circular(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_rounded, 'Feed', 0),
                  _buildNavItem(Icons.map_rounded, 'Map', 1),
                  _buildNavItem(Icons.add_circle_rounded, 'Create', 2, isLarge: true),
                  _buildNavItem(Icons.notifications_rounded, 'Inbox', 3),
                  _buildNavItem(Icons.person_rounded, 'Profile', 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? AppColors.secondaryPastel : Colors.white.withOpacity(0.5),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {bool isLarge = false}) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        if (index == 1) context.go('/map');
        if (index == 2) context.go('/create-event');
        if (index == 4) context.go('/profile');
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isLarge ? 32 : 24,
              color: isSelected ? Colors.black87 : Colors.black38,
            ),
            if (!isLarge)
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.black87 : Colors.black38,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
