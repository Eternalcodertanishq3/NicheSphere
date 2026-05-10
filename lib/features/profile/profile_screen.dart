import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../shared/widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPastel,
      body: Stack(
        children: [
          // Background circles for aesthetic
          Positioned(
            top: -20,
            right: -20,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/logo.png',
                width: 250,
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Avatar & Name
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=nichesphere'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Alex Rivera',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const Text(
                    '@alex_communities',
                    style: TextStyle(color: Colors.black45),
                  ),
                  
                  const SizedBox(height: 32),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('Events', '12'),
                      _buildStat('Badges', '5'),
                      _buildStat('Following', '48'),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  // Interests
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('My Interests', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildTag('Gaming', AppColors.bubbleBlue),
                      _buildTag('Anime', AppColors.bubblePink),
                      _buildTag('Tech', AppColors.bubbleGreen),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  // Menu Items
                  _buildMenuItem(Icons.bookmark_rounded, 'Saved Events'),
                  _buildMenuItem(Icons.history_rounded, 'Past Events'),
                  _buildMenuItem(Icons.settings_rounded, 'Settings'),
                  _buildMenuItem(Icons.help_outline_rounded, 'Help & Support'),
                  
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        opacity: 0.3,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
