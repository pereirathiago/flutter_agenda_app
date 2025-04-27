import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScheduleViewPage extends StatefulWidget {
  const CalendarScheduleViewPage({super.key});

  @override
  State<CalendarScheduleViewPage> createState() =>
      _CalendarScheduleViewPageState();
}

class _CalendarScheduleViewPageState extends State<CalendarScheduleViewPage> {
  CalendarView _calendarView = CalendarView.month;
  void _onCalendarViewChanged(CalendarView view) {
    setState(() {
      _calendarView = view;
    });
  }

  final Map<CalendarView, String> _labels = {
    CalendarView.day: 'Dia',
    CalendarView.week: 'Semana',
    CalendarView.month: 'Mês',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownMenu<CalendarView>(
            initialSelection: _calendarView,
            width: 200,
            onSelected: (CalendarView? newValue) {
              if (newValue != null) {
                _onCalendarViewChanged(newValue);
              }
            },
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            menuStyle: MenuStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
            ),
            dropdownMenuEntries:
                _labels.entries.map((entry) {
                  return DropdownMenuEntry<CalendarView>(
                    value: entry.key,
                    label: entry.value,
                  );
                }).toList(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SfCalendar(
              key: ValueKey(_calendarView),
              view: _calendarView,
              onTap: (CalendarTapDetails details) {
                final DateTime? tappedDate = details.date;

                if (details.targetElement == CalendarElement.calendarCell &&
                    tappedDate != null) {
                  final DateTime now = DateTime.now();
                  final DateTime today = DateTime(now.year, now.month, now.day);

                  final DateTime selected = DateTime(
                    tappedDate.year,
                    tappedDate.month,
                    tappedDate.day,
                  );

                  if (selected.isBefore(today)) {
                    // dia anterior ao hoje ⛔️❌⏳
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Não é possível agendar em datas passadas! ⏳🚫',
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  // Tudo certo! Navega com a data! 🛫📅✨
                  Navigator.pushNamed(
                    context,
                    '/new-appointment',
                    arguments: {'startHourDate': tappedDate},
                  );
                }
              },
              headerStyle: CalendarHeaderStyle(
                textAlign: TextAlign.center,
                backgroundColor: Colors.transparent,
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              dataSource: MeetingDataSource(_getDataSource()),
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Appointment> _getDataSource() {
    return <Appointment>[];
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
