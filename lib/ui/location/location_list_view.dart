import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/location.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';

class LocationListView extends StatelessWidget {
  const LocationListView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Location> locations = [];

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
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        Navigator.pushNamed(
                          context,
                          '/new-location',
                          arguments: {'location': location},
                        );
                      } else if (direction == DismissDirection.endToStart) {}
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
                        '${location.number ?? 'S/N'} - ${location.city ?? 'Cidade desconhecida'}',
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
