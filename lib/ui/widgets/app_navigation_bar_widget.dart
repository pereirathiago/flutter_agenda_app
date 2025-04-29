import 'package:flutter/material.dart';

class AppNavigationBarWidget extends StatelessWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPageNotifier;

  const AppNavigationBarWidget({
    super.key,
    required this.pageController,
    required this.currentPageNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentPageNotifier,
      builder: (context, currentIndex, _) {
        return NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            currentPageNotifier.value = index;
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Calendário',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt),
              label: 'Lista',
            ),
            NavigationDestination(
              icon: Icon(Icons.mail_outline),
              selectedIcon: Icon(Icons.mail),
              label: 'Convites',
            ),
          ],
        );
      },
    );
  }
}
