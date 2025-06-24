import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/models/location.dart';
import 'package:flutter_agenda_app/models/user.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository.dart';
import 'package:flutter_agenda_app/repositories/location_repository.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/appointments/new_appointment.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:url_launcher/url_launcher.dart';

class InvitationsScreenView extends StatelessWidget {
  const InvitationsScreenView({super.key});

  String formatDateTime(DateTime dateTime) {
    String formatTwoDigits(String input) {
      final regex = RegExp(r'^\d$');
      return regex.hasMatch(input) ? '0$input' : input;
    }

    return '${dateTime.day}/${formatTwoDigits(dateTime.month.toString())}/${dateTime.year} '
        '${formatTwoDigits(dateTime.hour.toString())}:${formatTwoDigits(dateTime.minute.toString())}';
  }

  Color _getBackgroundColor(int status) {
    final statusColors = {
      1: Colors.green.shade100, // Aceito
      2: Colors.red.shade100, // Recusado
      0: Colors.white, // Pendente
    };

    return statusColors[status] ?? Colors.white;
  }

  String _getStatusText(int status) {
    final statusText = {1: 'Aceito', 2: 'Recusado', 0: 'Pendente'};

    return statusText[status] ?? 'Pendente';
  }

  Future<void> _openLocationInGoogleMapsFromLocation(
    Location location,
    BuildContext context,
  ) async {
    final fullAddress =
        '${location.address}, ${location.number}, ${location.neighborhood}, ${location.city}, ${location.state}';

    final encodedAddress = Uri.encodeComponent(fullAddress);

    final fallbackUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
    );

    try {
      final launched = await launchUrl(
        fallbackUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Não foi possível abrir o navegador para o Google Maps.';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir mapa: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = context.watch<UserRepository>();
    final invitationRepo = context.watch<InvitationRepository>();
    final appointmentRepo = context.watch<AppointmentsRepository>();

    final loggedUser = userRepo.loggedUser;

    if (loggedUser == null) {
      return const Center(child: Text('Nenhum usuário logado.'));
    }

    return FutureBuilder(
      future: invitationRepo.getInvitationsByGuestId(loggedUser.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }

        final invitations = snapshot.data ?? [];

        if (invitations.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum convite encontrado.',
              style: TextStyle(fontSize: 18, color: AppColors.primary),
            ),
          );
        }

        return ListView.builder(
          itemCount: invitations.length,
          itemBuilder: (context, index) {
            final invitation = invitations[index];

            return FutureBuilder<Appointment?>(
              future: appointmentRepo.getAppointmentById(
                invitation.appointmentId!,
              ),
              builder: (context, appointmentSnapshot) {
                final appointment = appointmentSnapshot.data;

                return FutureBuilder<User?>(
                  future: userRepo.getProfile(invitation.idOrganizerUser!),
                  builder: (context, userSnapshot) {
                    final organizer = userSnapshot.data;

                    return Card(
                      color: _getBackgroundColor(invitation.invitationStatus),
                      margin: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8),
                            child: ListTile(
                              onTap: () {
                                if (appointment != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => NewAppointmentView(),
                                      settings: RouteSettings(
                                        arguments: {
                                          'appointment': appointment,
                                          'readonly': true,
                                          'invitation': true,
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Organizador: ${organizer?.username ?? 'Desconhecido'}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Status: ${_getStatusText(invitation.invitationStatus)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Título: ${appointment?.title ?? 'N/A'}',
                                  ),
                                  appointment != null
                                      ? FutureBuilder<Location>(
                                        future: context
                                            .read<LocationRepository>()
                                            .getById(appointment.locationId!),
                                        builder: (context, locationSnapshot) {
                                          final location =
                                              locationSnapshot.data;
                                          return Text(
                                            'Local: ${location != null ? '${location.address}, ${location.number} - ${location.city}' : 'Desconhecido'}',
                                          );
                                        },
                                      )
                                      : const Text('Local: N/A'),
                                  Text(
                                    'Início: ${appointment != null ? formatDateTime(appointment.startHourDate) : 'N/A'}',
                                  ),
                                  Text(
                                    'Fim: ${appointment != null ? formatDateTime(appointment.endHourDate) : 'N/A'}',
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async {
                                      if (invitation.id != null) {
                                        await invitationRepo.acceptInvitation(
                                          invitation.id!,
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      if (invitation.id != null) {
                                        await invitationRepo.declineInvitation(
                                          invitation.id!,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: FutureBuilder<Location>(
                              future: context
                                  .read<LocationRepository>()
                                  .getById(appointment?.locationId ?? -1),
                              builder: (context, snapshot) {
                                final location = snapshot.data;
                                if (location == null)
                                  return const SizedBox.shrink();

                                return Tooltip(
                                  message: 'Ver no Google Maps',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(24),
                                      onTap:
                                          () =>
                                              _openLocationInGoogleMapsFromLocation(
                                                location,
                                                context,
                                              ),
                                      child: Ink(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(
                                          Icons.map,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
