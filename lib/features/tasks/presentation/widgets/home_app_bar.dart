import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/core/providers/theme_provider.dart';
import 'package:tyman/core/providers/user_provider.dart';
import 'package:tyman/core/widgets/cached_user_avatar.dart';
import 'package:tyman/data/models/app_user.dart';
import 'package:flutter/cupertino.dart';

enum HomeMenuAction { theme, notifications, language, privacy, help, about }

class HomeAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.user});

  final AppUser? user;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  ConsumerState<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends ConsumerState<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: PopupMenuButton<HomeMenuAction>(
            icon: Icon(Icons.settings_outlined,
                color: theme.iconTheme.color, size: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: settingsBackground,
            elevation: 8,
            offset: const Offset(0, 50),
            onSelected: (HomeMenuAction action) {
              switch (action) {
                case HomeMenuAction.theme:
                  break;
                case HomeMenuAction.notifications:
                  notificationBottomSheet(context);
                  break;
                case HomeMenuAction.language:
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: HomeMenuAction.theme,
                  enabled: true,
                  padding: EdgeInsets.zero,
                  child: const ThemeSwitch()),
              PopupMenuItem(
                value: HomeMenuAction.notifications,
                child: Row(
                  children: [
                    Icon(Icons.notifications_outlined,
                        color: Colors.grey[800], size: 22),
                    const SizedBox(width: 12),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: HomeMenuAction.language,
                child: Row(
                  children: [
                    Icon(Icons.language_outlined,
                        color: Colors.grey[800], size: 22),
                    const SizedBox(width: 12),
                    const Text(
                      'Language',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: HomeMenuAction.privacy,
                child: Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined,
                        color: Colors.grey[800], size: 22),
                    const SizedBox(width: 12),
                    const Text(
                      'Privacy & Security',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: HomeMenuAction.help,
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.grey[800], size: 22),
                    const SizedBox(width: 12),
                    const Text(
                      'Help & Support',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: HomeMenuAction.about,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[800], size: 22),
                    const SizedBox(width: 12),
                    const Text(
                      'About',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if (widget.user != null)
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedUserAvatar(photoUrl: widget.user!.photo, size: 40),
              ),
            ),
          const SizedBox(width: 10),
          Text(
            "Hello, ${widget.user?.name ?? 'Earthling'}!",
            style: TextStyle(
              color: theme.textTheme.bodyLarge!.color,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isDark = themeMode == ThemeMode.dark;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();

        final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
        ref.read(themeNotifierProvider.notifier).setTheme(newMode);
      },
      child: Container(
        width: double.infinity,
        height: kMinInteractiveDimension - 4,
        padding: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.light
              ? theme.colorScheme.primary.withAlpha(30)
              : theme.colorScheme.surface.withAlpha(60),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 750),
              curve: Curves.easeInOutBack,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(170),
                        blurRadius: 4,
                        offset: const Offset(-1, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      size: 22,
                      color: !isDark
                          ? Colors.yellowAccent.shade700
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.nightlight_round,
                      size: 22,
                      color: isDark ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void notificationBottomSheet(BuildContext context) {
  showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return const NotificationSheet();
      });
}

class NotificationSheet extends ConsumerWidget {
  const NotificationSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(userProfileProvider);

    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Text('Notifications',
                    style: TextStyle(
                        color: theme.textTheme.bodyMedium!.color,
                        fontWeight: theme.textTheme.bodyMedium!.fontWeight,
                        fontSize: 20)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.notifications_outlined,
                        color: theme.iconTheme.color, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daily Reminder',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium!.color,
                              fontSize: theme.textTheme.bodyMedium!.fontSize,
                            )),
                        SizedBox(height: 2),
                        Text(
                          'Receive daily task summaries at 09:00',
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium!.color,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )),
                    user.when(
                      data: (user) {
                        if (user == null) return const SizedBox();
                        final bool isEnabled = user.isNotificationsEnabled;
                        return CupertinoSwitch(
                          value: isEnabled,
                          onChanged: (value) async {
                            HapticFeedback.selectionClick();

                            await ref
                                .read(userServiceProvider)
                                .updateNotificationSettings(user.uid, value);
                          },
                        );
                      },
                      loading: () => const CupertinoActivityIndicator(),
                      error: (_, __) => const Icon(Icons.error_outline),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
