import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/schedule/calendar_schedule_view.dart';
import 'package:flutter_agenda_app/ui/schedule/list_schedule_view.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_navigation_bar_widget.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late PageController pc;
  final ValueNotifier<int> currentPageNotifier = ValueNotifier(0);

  @override
  void initState() {
    pc = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/new-appointment');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.primaryDegrade),
      ),
      body: PageView(
        controller: pc,
        onPageChanged: (index) {
          currentPageNotifier.value = index;
        },
        children: [CalendarScheduleViewPage(), ListScheduleView()],
      ),
      bottomNavigationBar: AppNavigationBarWidget(
        pageController: pc,
        currentPageNotifier: currentPageNotifier,
      ),
    );
  }
}
