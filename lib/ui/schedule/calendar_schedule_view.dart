import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_sqlite.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScheduleViewPage extends StatefulWidget {
  const CalendarScheduleViewPage({super.key});

  @override
  State<CalendarScheduleViewPage> createState() => _CalendarScheduleViewPageState();
}

class _CalendarScheduleViewPageState extends State<CalendarScheduleViewPage> {
  CalendarView _calendarView = CalendarView.month;
  late Future<List<dynamic>> _appointmentsFuture;

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
  void initState() {
    super.initState();
    _appointmentsFuture = _fetchAppointments();
  }

  Future<List<dynamic>> _fetchAppointments() async {
    final repo = Provider.of<AppointmentsRepositorySqlite>(context, listen: false);
    return await repo.getAll();
  }

  Future<void> _refresh() async {
    setState(() {
      _appointmentsFuture = _fetchAppointments();
    });
  }

  List<Appointment> _buildDataSource(List<dynamic> appointments) {
    return appointments.map((app) {
      return Appointment(
        startTime: app.startHourDate,
        endTime: app.endHourDate,
        subject: app.title,
        notes: app.description,
        location: app.local,
        color: AppColors.primary,
      );
    }).toList();
  }

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
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            menuStyle: const MenuStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
            ),
            dropdownMenuEntries: _labels.entries.map((entry) {
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
            child: FutureBuilder<List<dynamic>>(
              future: _appointmentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar compromissos 😖📛'));
                }

                final appointments = snapshot.data ?? [];
                return SfCalendar(
                  key: ValueKey(_calendarView),
                  view: _calendarView,
                  onTap: (CalendarTapDetails details) async {
                    final tappedDate = details.date;

                    if (details.targetElement == CalendarElement.calendarCell && tappedDate != null) {
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      final selected = DateTime(tappedDate.year, tappedDate.month, tappedDate.day);

                      final appointmentsOnDay = appointments.where((appointment) {
                        return appointment.startHourDate.year == selected.year &&
                            appointment.startHourDate.month == selected.month &&
                            appointment.startHourDate.day == selected.day;
                      }).toList();

                      if (appointmentsOnDay.isEmpty) {
                        if (selected.isBefore(today)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Não é possível agendar em datas passadas! ⏳🚫'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }
                        Navigator.pushNamed(
                          context,
                          '/new-appointment',
                          arguments: {'startHourDate': tappedDate},
                        );
                      } else {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Compromissos em ${selected.day}/${selected.month}/${selected.year}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Flexible(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: appointmentsOnDay.length,
                                      itemBuilder: (context, index) {
                                        final appointment = appointmentsOnDay[index];
                                        return Card(
                                          color: AppColors.primaryDegrade,
                                          margin: const EdgeInsets.symmetric(vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              appointment.title,
                                              style: const TextStyle(
                                                color: AppColors.cardTextColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              appointment.description,
                                              style: const TextStyle(
                                                color: AppColors.cardTextColor,
                                              ),
                                            ),
                                            trailing: Text(
                                              '${appointment.startHourDate.hour}:${appointment.startHourDate.minute} - ${appointment.endHourDate.hour}:${appointment.endHourDate.minute}',
                                              style: const TextStyle(
                                                color: AppColors.cardTextColor,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  !selected.isBefore(today)
                                      ? AppButtonWidget(
                                          text: 'Novo Compromisso',
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pushNamed(
                                              context,
                                              '/new-appointment',
                                              arguments: {'startHourDate': tappedDate},
                                            );
                                          },
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                  headerStyle: CalendarHeaderStyle(
                    textAlign: TextAlign.center,
                    backgroundColor: Colors.transparent,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  dataSource: MeetingDataSource(_buildDataSource(appointments)),
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
