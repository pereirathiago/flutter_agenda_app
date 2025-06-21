import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/models/location.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository.dart';
import 'package:flutter_agenda_app/repositories/location_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_input_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_agenda_app/models/user.dart';

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
  int? usuarioLogado;
  int? _selectedLocationId;
  int? _novoLocal;
  List<Location> _userLocations = [];
  final LocationRepositorySqlite _locationRepository =
      LocationRepositorySqlite();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _isReadOnly = false;
  Appointment? _appointment;
  List<Invitation> _invitations = [];

  bool verifyDate(BuildContext context) {
    final now = DateTime.now();
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final locationValid = _selectedLocationId != null;
    final startText = startHourController.text.trim();
    final endText = endHourController.text.trim();

    if (!locationValid ||
        title.isEmpty ||
        description.isEmpty ||
        startText.isEmpty ||
        endText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios!'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
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
      return false;
    }

    if (startDateTime.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data de início não pode ser no passado! ⏳❌'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (endDateTime.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data de término não pode ser no passado! ⏳🚫'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
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
    final loggedUser =
        Provider.of<UserRepository>(context, listen: false).loggedUser!;
    usuarioLogado = loggedUser.id;

    _loadUserLocations(loggedUser.id!).then((_) {
      setState(() {
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
            _selectedLocationId = _appointment?.locationId;
            _loadInvitations();
          }
        }
      });
    });
  }

  Future<void> _loadUserLocations(int userId) async {
    final locations = await _locationRepository.getAll(userId: userId);
    setState(() {
      _userLocations = locations;
    });
  }

  Future<void> _loadInvitations() async {
    final invitationRepository = Provider.of<InvitationRepository>(
      context,
      listen: false,
    );
    if (_appointment == null) return;

    final appointmentInvitations = await invitationRepository
        .getInvitationsByAppointmentAndOrganizer(
          _appointment!.id ?? 0,
          _appointment!.appointmentCreatorId!,
        );

    setState(() {
      _invitations = appointmentInvitations;
    });
  }

  void removerConvidado(Invitation invitation) async {
    if (invitation.id == null) return;

    try {
      if (invitation.invitationStatus != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Convite já foi respondido'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      await context.read<InvitationRepository>().removeInvitation(
        invitation.id!,
      );

      setState(() {
        _invitations.remove(invitation);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Convidado removido com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Erro ao remover convite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao remover convidado')),
      );
    }
  }

  void _addGuest() async {
    final userRepository = Provider.of<UserRepository>(context, listen: false);
    final invitationRepository = Provider.of<InvitationRepository>(
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
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final guestUsername = guestUsernameController.text.trim();

                  if (guestUsername.isEmpty) {
                    _showError('Informe o username do convidado!');
                    return;
                  }

                  if (guestUsername == loggedUser.username) {
                    _showError(
                      'Você não pode se convidar para o próprio compromisso! 🙅‍♂️',
                    );
                    return;
                  }

                  User? guestUser;
                  try {
                    guestUser = await userRepository.getUserByUsername(
                      guestUsername,
                    );
                  } catch (_) {
                    _showError('Usuário não encontrado!');
                    return;
                  }

                  if (guestUser == null) {
                    _showError('Usuário não encontrado!');
                    return;
                  }

                  final alreadyInvited = _invitations.any(
                    (inv) => inv.idGuestUser == guestUser!.id,
                  );

                  if (alreadyInvited) {
                    _showError(
                      'Este usuário já foi convidado para este compromisso!',
                    );
                    return;
                  }

                  final newInvitation = Invitation(
                    id: null,
                    idOrganizerUser: _appointment!.appointmentCreatorId!,
                    idGuestUser: guestUser.id,
                    invitationStatus: 0,
                    appointmentId: _appointment!.id ?? 0,
                  );

                  await invitationRepository.addInvitation(newInvitation);
                  await _loadInvitations();

                  Navigator.pop(context, true);
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

  Future<void> save(BuildContext context) async {
    if (!verifyDate(context)) return;

    final appointmentsRepository = Provider.of<AppointmentsRepository>(
      context,
      listen: false,
    );
    final invitationRepository = Provider.of<InvitationRepository>(
      context,
      listen: false,
    );

    final startDateTime = parseDateTime(startHourController.text.trim());
    final endDateTime = parseDateTime(endHourController.text.trim());

    if (startDateTime == null || endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data ou hora inválidas. Verifique o formato.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      if (_appointment?.id != null) {
        // Atualizando compromisso existente
        _novoLocal ??= _appointment!.locationId;
        final updatedAppointment = Appointment(
          id: _appointment!.id,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          status: _appointment!.status,
          startHourDate: startDateTime,
          endHourDate: endDateTime,
          appointmentCreatorId: _appointment!.appointmentCreatorId,
          locationId: _novoLocal,
        );

        print(
          'Atualizando compromisso com locationId selecionado: $_appointment',
        );

        await appointmentsRepository.updateAppointment(updatedAppointment);
      } else {
        final newAppointment = Appointment(
          id: null,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          status: true,
          startHourDate: startDateTime,
          endHourDate: endDateTime,
          appointmentCreatorId: usuarioLogado,
          locationId: _selectedLocationId,
        );

        final insertedId = await appointmentsRepository.addAppointment(
          newAppointment,
        );
        for (var inv in await invitationRepository
            .getInvitationsByAppointmentAndOrganizer(
              0,
              _appointment?.appointmentCreatorId ?? 0,
            )) {
          final updatedInvitation = Invitation(
            id: inv.id,
            idOrganizerUser: inv.idOrganizerUser,
            idGuestUser: inv.idGuestUser,
            invitationStatus: inv.invitationStatus,
            appointmentId: insertedId,
          );
          await invitationRepository.updateInvitation(updatedInvitation);
        }
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar compromisso 😵👉 $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                        setState(() {
                          startHourController.text =
                              '${dateTimeStart.day}/${dateTimeStart.month}/${dateTimeStart.year} ${timeStart.format(context)}';
                        });
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
                Text('Local'),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      flex: _userLocations.isEmpty ? 4 : 1,
                      child: DropdownButtonFormField<int>(
                        key: ValueKey(
                          _userLocations.length.toString() +
                              (_selectedLocationId?.toString() ?? 'null'),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                        value:
                            _userLocations.any(
                                  (loc) => loc.id == _selectedLocationId,
                                )
                                ? _selectedLocationId
                                : null,
                        items:
                            _userLocations.isEmpty
                                ? [
                                  const DropdownMenuItem<int>(
                                    value: null,
                                    child: Text(
                                      'Sem locais cadastrados',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ]
                                : _userLocations.map((location) {
                                  return DropdownMenuItem<int>(
                                    value: location.id,
                                    child: Text(
                                      '${location.address}, ${location.number} - ${location.city}',
                                    ),
                                  );
                                }).toList(),
                        onChanged:
                            (_userLocations.isEmpty || _isReadOnly)
                                ? null
                                : (int? value) {
                                  if (value == null) return;
                                  setState(() {
                                    _selectedLocationId = value;
                                    _novoLocal = value;
                                  });
                                },
                        decoration: const InputDecoration(
                          hintText: 'Selecione o local do evento',
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Visibility(
                      visible: _userLocations.isEmpty,
                      child: IconButton(
                        tooltip: 'Adicionar novo local',
                        icon: const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                        ),
                        onPressed:
                            _isReadOnly
                                ? null
                                : () {
                                  Navigator.pushNamed(context, '/location');
                                },
                      ),
                    ),
                  ],
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
                        final guestId = invitation.idGuestUser;
                        print('Guest ID: ${invitation.idGuestUser}');

                        if (guestId == null) {
                          return const ListTile(
                            title: Text('Convidado desconhecido'),
                          );
                        }
                        return FutureBuilder<User?>(
                          future: context.read<UserRepository>().getProfile(
                            guestId,
                          ),
                          builder: (context, snapshot) {
                            final guestUser = snapshot.data;
                            final username =
                                guestUser?.username ?? 'Desconhecido';

                            return ListTile(
                              title: Text('Username: $username'),
                              subtitle: Text(
                                'Status: ${_getInvitationStatusText(invitation.invitationStatus)}',
                              ),
                              trailing:
                                  !_isReadOnly
                                      ? IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => removerConvidado(invitation),
                                      )
                                      : null,
                            );
                          },
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
