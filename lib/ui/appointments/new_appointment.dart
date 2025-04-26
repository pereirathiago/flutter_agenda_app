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
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      value,
    ) {
      if (value != null) {
        final time = value.format(context);
        startHourController.text = time;
      }
    });
  }

  void verifyDate(BuildContext context) {
    final now = DateTime.now();

    DateTime? startDateTime;
    DateTime? endDateTime;

    try {
      final partsStart = startHourController.text.split(' ');
      final datePartsStart = partsStart[0].split('/');
      final timePartsStart = partsStart[1].split(':');

      startDateTime = DateTime(
        int.parse(datePartsStart[2]),
        int.parse(datePartsStart[1]),
        int.parse(datePartsStart[0]),
        int.parse(timePartsStart[0]),
        int.parse(timePartsStart[1]),
      );

      final partsEnd = endHourController.text.split(' ');
      final datePartsEnd = partsEnd[0].split('/');
      final timePartsEnd = partsEnd[1].split(':');

      endDateTime = DateTime(
        int.parse(datePartsEnd[2]),
        int.parse(datePartsEnd[1]),
        int.parse(datePartsEnd[0]),
        int.parse(timePartsEnd[0]),
        int.parse(timePartsEnd[1]),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preencha corretamente as datas e horas! 🧨📅'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (startDateTime.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data de início não pode ser no passado! ⏳❌'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (endDateTime.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data de término não pode ser no passado! ⏳🚫'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Data de término não pode ser antes da data de início! 🪞⛔️',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅✅ Tudo certo!! Aqui você pode salvar de verdade o compromisso 🎉📅✅
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compromisso salvo com sucesso! 🎯📝✨'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 Pegando a data passada pelo Navigator.pushNamed 🌟
    final DateTime? dataSelecionada =
        ModalRoute.of(context)!.settings.arguments as DateTime?;

    // ✨ Se a data veio, formata e já joga no campo! ✨
    if (dataSelecionada != null && startHourController.text.isEmpty) {
      final horaFixa = const TimeOfDay(hour: 8, minute: 0); // padrão 08:00 🕗
      final dataHora = DateTime(
        dataSelecionada.year,
        dataSelecionada.month,
        dataSelecionada.day,
        horaFixa.hour,
        horaFixa.minute,
      );
      startHourController.text =
          '${dataHora.day}/${dataHora.month}/${dataHora.year} ${horaFixa.format(context)}';
    }
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
                AppButtonWidget(
                  text: 'Salvar compromisso',
                  onPressed: () => verifyDate(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
