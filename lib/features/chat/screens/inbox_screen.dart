import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/app_bottom_nav.dart';

/// NicheSphere — Inbox Screen (Screen 14)
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name': 'Indie Game Meetup', 'msg': 'Alex: See you there! 🎮', 'time': '2m', 'unread': 3, 'img': 'https://i.pravatar.cc/100?img=1'},
      {'name': 'Yoga Group', 'msg': 'Mats are provided for everyone', 'time': '1h', 'unread': 0, 'img': 'https://i.pravatar.cc/100?img=2'},
      {'name': 'Art Collective', 'msg': 'New watercolor workshop!', 'time': '3h', 'unread': 1, 'img': 'https://i.pravatar.cc/100?img=3'},
      {'name': 'TechSphere', 'msg': 'Panel discussion lineup is ready', 'time': '1d', 'unread': 0, 'img': 'https://i.pravatar.cc/100?img=4'},
    ];

    return Scaffold(
      body: Stack(children: [
        GradientBackground(
          child: SafeArea(
            bottom: false,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg24),
                child: Text('Inbox', style: AppTextStyles.displayL),
              ).animate().fadeIn(),
              // Tab bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg24),
                child: Row(children: ['Chats', 'Event Updates', 'Notifications'].map((t) =>
                  Padding(padding: const EdgeInsets.only(right: 16),
                    child: Text(t, style: AppTextStyles.titleM.copyWith(
                      color: t == 'Chats' ? AppColors.neonPink : AppColors.textHint)))).toList()),
              ),
              const SizedBox(height: AppSpacing.md16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final c = chats[i];
                    return GlassCard(blur: 12, opacity: 0.2, borderRadius: AppBorderRadius.lg,
                      padding: const EdgeInsets.all(AppSpacing.sm12),
                      child: Row(children: [
                        AvatarWidget(imageUrl: c['img'] as String, size: 48),
                        const SizedBox(width: AppSpacing.sm12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text(c['name'] as String, style: AppTextStyles.titleM, overflow: TextOverflow.ellipsis)),
                            Text(c['time'] as String, style: AppTextStyles.micro),
                          ]),
                          const SizedBox(height: 4),
                          Row(children: [
                            Expanded(child: Text(c['msg'] as String, style: AppTextStyles.bodyS, overflow: TextOverflow.ellipsis, maxLines: 1)),
                            if ((c['unread'] as int) > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.neonPink, borderRadius: AppBorderRadius.pill),
                                child: Text('${c['unread']}', style: AppTextStyles.micro.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                              ),
                          ]),
                        ])),
                      ]),
                    ).animate().fadeIn(delay: Duration(milliseconds: 100 * i), duration: 300.ms).slideX(begin: 0.05, end: 0);
                  },
                ),
              ),
            ]),
          ),
        ),
        AppBottomNav(currentIndex: 3, onTap: (i) {
          switch (i) {
            case 0: context.go(RouteNames.home); break;
            case 1: context.go(RouteNames.explore); break;
            case 2: context.go(RouteNames.createEvent); break;
            case 4: context.go(RouteNames.profile); break;
          }
        }),
      ]),
    );
  }
}
