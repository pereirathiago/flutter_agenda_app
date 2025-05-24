import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/user_repository_sqlite.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_input_widget.dart';
import 'package:provider/provider.dart';

class NewAppointmentView extends StatefulWidget {
  const NewAppointmentView({super.key});

  @override
  State<NewAppointmentView> createState() => _NewAppointmentViewState();
}

class _NewAppointmentViewState extends State<NewAppointmentView> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final startHourController = TextEditingController();
  final endHourController = TextEditingController();
  final localController = TextEditingController();

  bool _isReadOnly = false;
  Appointment? _appointment;
  List<Invitation> _invitations = [];

  bool verifyDate(BuildContext context) {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final local = localController.text.trim();
    final startText = startHourController.text.trim();
    final endText = endHourController.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        local.isEmpty ||
        startText.isEmpty ||
        endText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios! 🚫🛑📋'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  DateTime? parseDateTime(String dateTimeText) {
    try {
      final parts = dateTimeText.split(' ');
      final dateParts = parts[0].split('/');
      final timeParts = parts[1].split(':');

      return DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (e) {
      return null;
    }
  }

  String formatDateTime(DateTime dateTime) {
    String formatTwoDigits(String input) {
      final regex = RegExp(r'^\d$');

      if (regex.hasMatch(input)) {
        return '0$input';
      }
      return input;
    }

    String period = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour12 =
        dateTime.hour > 12
            ? dateTime.hour - 12
            : (dateTime.hour == 0 ? 12 : dateTime.hour);
    return '${dateTime.day}/${formatTwoDigits(dateTime.month.toString())}/${dateTime.year} ${formatTwoDigits(hour12.toString())}:${formatTwoDigits(dateTime.minute.toString())} $period';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map) {
      _appointment = arguments['appointment'] as Appointment?;
      _isReadOnly = arguments['readonly'] == true;

      if (_appointment != null) {
        titleController.text = _appointment?.title ?? '';
        descriptionController.text = _appointment?.description ?? '';
        startHourController.text =
            _appointment?.startHourDate != null
                ? formatDateTime(_appointment!.startHourDate)
                : '';
        endHourController.text =
            _appointment?.endHourDate != null
                ? formatDateTime(_appointment!.endHourDate)
                : '';
        localController.text = _appointment?.local ?? '';
        _loadInvitations();
      }
    } else {
      final loggedUser =
          Provider.of<UserRepositorySqlite>(context, listen: false).loggedUser!;
      _appointment = Appointment(
        id: null,
        title: '',
        description: '',
        status: true,
        startHourDate: DateTime.now(),
        endHourDate: DateTime.now().add(const Duration(hours: 1)),
        local: '',
        appointmentCreator: loggedUser,
        invitations: [],
      );
    }
  }

  void _loadInvitations() {
    final invitationRepository = Provider.of<InvitationRepositoryMemory>(
      context,
      listen: false,
    );

    final appointmentInvitations =
        invitationRepository.invitations
            .where(
              (inv) =>
                  inv.organizerUser ==
                      _appointment?.appointmentCreator.username &&
                  inv.appointmentId == _appointment?.id,
            )
            .toList();

    setState(() {
      _invitations = appointmentInvitations;
    });
  }

  void _addGuest() async {
    final userRepository = Provider.of<UserRepositorySqlite>(
      context,
      listen: false,
    );
    final invitationRepository = Provider.of<InvitationRepositoryMemory>(
      context,
      listen: false,
    );
    final loggedUser = userRepository.loggedUser!;

    final guestUsernameController = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Adicionar Convidado'),
            content: TextField(
              controller: guestUsernameController,
              decoration: const InputDecoration(
                hintText: 'Username do convidado',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  final guestUsername = guestUsernameController.text.trim();

                  if (guestUsername.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Informe o username do convidado!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (guestUsername == loggedUser.username) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Você não pode se convidar para o próprio compromisso! 🙅‍♂️',
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  final guestUser = userRepository.getUserByUsername(
                    guestUsername,
                  );

                  if (guestUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuário não encontrado!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  final alreadyInvited = _invitations.any(
                    (inv) => inv.idGuestUser == guestUsername,
                  );

                  if (alreadyInvited) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuário já convidado!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  final newInvitation = Invitation(
                    id: invitationRepository.invitations.length + 1,
                    organizerUser: _appointment!.appointmentCreator.username,
                    idGuestUser: guestUsername,
                    invitationStatus: 0,
                    appointmentId: _appointment!.id ?? 0,
                  );

                  invitationRepository.addInvitation(newInvitation);
                  _loadInvitations();

                  Navigator.pop(context);
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
    );
  }

  String _getInvitationStatusText(int status) {
    final statusMap = {0: 'Pendente', 1: 'Aceito', 2: 'Recusado'};

    return statusMap[status] ?? 'Desconhecido';
  }

  void save(BuildContext context) {
    if (!verifyDate(context)) return;

    final appointmentsRepository = Provider.of<AppointmentsRepositoryMemory>(
      context,
      listen: false,
    );
    final invitationRepository = Provider.of<InvitationRepositoryMemory>(
      context,
      listen: false,
    );

    final startDateTime = parseDateTime(startHourController.text.trim());
    final endDateTime = parseDateTime(endHourController.text.trim());

    if (startDateTime == null || endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data ou hora inválidas. Verifique o formato. ⏰❌'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_appointment?.id != null) {
      final updatedAppointment = Appointment(
        id: _appointment!.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        startHourDate: startDateTime,
        endHourDate: endDateTime,
        local: localController.text.trim(),
        status: _appointment!.status,
        invitations: _appointment!.invitations,
        appointmentCreator: _appointment!.appointmentCreator,
      );

      appointmentsRepository.updateAppointment(updatedAppointment);
    } else {
      final newAppointment = Appointment(
        id: appointmentsRepository.appointments.length + 1,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        startHourDate: startDateTime,
        endHourDate: endDateTime,
        local: localController.text.trim(),
        status: true,
        invitations: [],
        appointmentCreator: _appointment!.appointmentCreator,
      );

      for (var inv in invitationRepository.invitations.where(
        (inv) => inv.appointmentId == 0,
      )) {
        inv.appointmentId = newAppointment.id!;
      }
      appointmentsRepository.addAppointment(newAppointment);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final DateTime? dataSelecionada =
        arguments != null
            ? (arguments as Map)['startHourDate'] as DateTime?
            : null;

    if (dataSelecionada != null && startHourController.text.isEmpty) {
      final horaFixa = const TimeOfDay(hour: 8, minute: 0);
      final dataHora = DateTime(
        dataSelecionada.year,
        dataSelecionada.month,
        dataSelecionada.day,
        horaFixa.hour,
        horaFixa.minute,
      );
      startHourController.text = formatDateTime(dataHora);
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: _isReadOnly ? 'Compromisso' : 'Novo compromisso',
      ),
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
                  readOnly: _isReadOnly,
                ),
                const SizedBox(height: 16),
                AppInputWidget(
                  label: 'Descrição',
                  hintText: 'Digite a descrição do evento',
                  controller: descriptionController,
                  readOnly: _isReadOnly,
                ),
                const SizedBox(height: 16),
                Text('Data e hora de início'),
                const SizedBox(height: 8),
                TextField(
                  controller: startHourController,
                  readOnly: true,
                  onTap: () async {
                    if (_isReadOnly) return;
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
                  decoration: const InputDecoration(
                    hintText: 'Digite a data e hora de início',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Data e hora de término'),
                const SizedBox(height: 8),
                TextField(
                  controller: endHourController,
                  readOnly: true,

                  onTap: () async {
                    if (_isReadOnly) return;
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
                  decoration: const InputDecoration(
                    hintText: 'Digite a data e hora de término',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
                AppInputWidget(
                  label: 'Local',
                  hintText: 'Digite o local do evento',
                  controller: localController,
                  readOnly: _isReadOnly,
                ),
                const SizedBox(height: 24),
                if (_isReadOnly || _appointment != null) ...[
                  const Text(
                    'Convidados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (_invitations.isEmpty)
                    const Text('Nenhum convidado adicionado.')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _invitations.length,
                      itemBuilder: (context, index) {
                        final invitation = _invitations[index];
                        return ListTile(
                          title: Text('Username: ${invitation.idGuestUser}'),
                          subtitle: Text(
                            'Status: ${_getInvitationStatusText(invitation.invitationStatus)}',
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  if (!_isReadOnly) ...[
                    AppButtonWidget(
                      text: 'Adicionar convidado',
                      onPressed: _addGuest,
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    const SizedBox(height: 8),
                  ],
                ],
                if (!_isReadOnly)
                  AppButtonWidget(
                    text: 'Salvar compromisso',
                    onPressed: () => save(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
