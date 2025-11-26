import 'package:flutter/material.dart';
import 'package:tyman/core/constants/colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const AppBottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(color: boxShadowColor, spreadRadius: 5, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          type: BottomNavigationBarType.fixed,
          enableFeedback: true,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          currentIndex: currentIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home_rounded),
            ),
            BottomNavigationBarItem(
              label: 'My Page',
              icon: Icon(Icons.person_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
