import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_input_widget.dart';

class NewAppointmentView extends StatelessWidget {
  NewAppointmentView({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startHourController = TextEditingController();
  final TextEditingController endHourController = TextEditingController();
  final TextEditingController localController = TextEditingController();

  void pickTime(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        final time = value.format(context);
        startHourController.text = time;
      }
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputWidget(
                  label: 'Título',
                  hintText: 'Digite o nome do evento',
                  controller: titleController,
                ),
                const SizedBox(height: 16),
                AppInputWidget(
                  label: 'Descrição',
                  hintText: 'Digite a descrição do evento',
                  controller: descriptionController,
                ),
                const SizedBox(height: 16),
                Text('Data e hora de início'),
                const SizedBox(height: 8),
                TextField(
                  controller: startHourController,
                  readOnly: true,
                  onTap: () async {
                  final dateStart = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (dateStart != null) {
                    final timeStart = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    );
                    if (timeStart != null) {
                    final dateTimeStart = DateTime(
                      dateStart.year,
                      dateStart.month,
                      dateStart.day,
                      timeStart.hour,
                      timeStart.minute,
                    );
                    startHourController.text =
                      '${dateTimeStart.day}/${dateTimeStart.month}/${dateTimeStart.year} ${timeStart.format(context)}';
                    }
                  }
                  },
                  decoration: InputDecoration(
                  hintText: 'Digite a data e hora de início',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Data e hora de término'),
                const SizedBox(height: 8),
                TextField(
                  controller: endHourController,
                  readOnly: true,
                  onTap: () async {
                  final dateEnd = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (dateEnd != null) {
                    final timeEnd = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    );
                    if (timeEnd != null) {
                    final dateTimeEnd = DateTime(
                      dateEnd.year,
                      dateEnd.month,
                      dateEnd.day,
                      timeEnd.hour,
                      timeEnd.minute,
                    );
                    endHourController.text =
                      '${dateTimeEnd.day}/${dateTimeEnd.month}/${dateTimeEnd.year} ${timeEnd.format(context)}';
                    }
                  }
                  },
                  decoration: InputDecoration(
                  hintText: 'Digite a data e hora de término',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                AppInputWidget(
                  label: 'Local',
                  hintText: 'Digite o local do evento',
                  controller: localController,
                ),
                const SizedBox(height: 16),
                AppButtonWidget(text: 'Salvar compromisso', onPressed: (){}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
