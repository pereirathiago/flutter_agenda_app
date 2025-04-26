import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/invitation/list_invitation_view.dart';
import 'package:flutter_agenda_app/ui/schedule/calendar_schedule_view.dart';
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
      floatingActionButton: 
     ValueListenableBuilder<int>(
      valueListenable: currentPageNotifier,
      builder: (context, currentPage, child) {
        return (currentPage == 0) 
            ?
      FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/new-appointment');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.primaryDegrade),
      ): Container();
      },
      ),
      body: PageView(
        controller: pc,
        onPageChanged: (index) {
          currentPageNotifier.value = index;
        },
        children: [CalendarScheduleViewPage(), CalendarScheduleViewPage(), InvitationsScreenView()],
      ),
      bottomNavigationBar: AppNavigationBarWidget(
        pageController: pc,
        currentPageNotifier: currentPageNotifier,
      ),
    );
  }
}
