import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/repositories/location_repository_memory.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:provider/provider.dart';

class LocationListView extends StatefulWidget {
  const LocationListView({super.key});

  @override
  State<LocationListView> createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  @override
  Widget build(BuildContext context) {
    final locationRepository = Provider.of<LocationRepositoryMemory>(
      context,
      listen: true,
    );
    final locations = locationRepository.getAll('');

    return Scaffold(
      appBar: const AppBarWidget(title: 'Meus Locais'),
      body:
          locations.isEmpty
              ? const Center(
                child: Text(
                  'Nenhum local cadastrado.',
                  style: TextStyle(fontSize: 18, color: AppColors.primary),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: locations.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final location = locations[index];

                  return Dismissible(
                    key: Key(location.id.toString()),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: AppColors.alert,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: AppColors.delete,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        Navigator.pushNamed(
                          context,
                          '/new-location',
                          arguments: {'location': location},
                        );
                        return false;
                      } else if (direction == DismissDirection.endToStart) {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Excluir'),
                                content: const Text(
                                  'Deseja realmente excluir este local?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text('Excluir'),
                                  ),
                                ],
                              ),
                        );
                        if (confirm == true) {
                          final messenger = ScaffoldMessenger.of(context);
                          locationRepository.remove(location.id!);
                          setState(() {});
                          messenger.showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Local excluído com sucesso!',
                              ),
                              action: SnackBarAction(
                                label: 'Desfazer',
                                onPressed: () {
                                  locationRepository.add(location);
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                          return confirm;
                        }
                        return false;
                      }
                      return false;
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        location.address ?? 'Endereço desconhecido',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${location.number?.isEmpty == true ? 'S/N' : location.number} - ${location.city ?? 'Cidade desconhecida'}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/new-location',
                          arguments: {'location': location, 'readonly': true},
                        );
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/new-location');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.primaryDegrade),
      ),
    );
  }
}
