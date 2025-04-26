import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';

class ListScheduleView extends StatelessWidget {
  ListScheduleView({super.key});

  final List<Map<String, String>> compromissosTeste = [
  {
    'titulo': 'Reunião com equipe 🧑‍💼👩‍💻',
    'descricao': 'Discutir andamento do projeto Flutter 🚀📱',
    'local': 'Sala 1 - Escritório Central 🏢',
    'inicio': '25/04/2025 10:00',
    'fim': '25/04/2025 11:00',
  },
  {
    'titulo': 'Consulta médica 🩺👨‍⚕️',
    'descricao': 'Check-up de rotina ❤️',
    'local': 'Clínica Saúde & Vida 🏥',
    'inicio': '26/04/2025 08:30',
    'fim': '26/04/2025 09:00',
  },
  {
    'titulo': 'Aniversário da Ana 🎉🎂',
    'descricao': 'Festa surpresa no salão de festas! 🎈🎁',
    'local': 'Buffet Alegria 🎊',
    'inicio': '27/04/2025 19:00',
    'fim': '27/04/2025 23:00',
  },
  {
    'titulo': 'Aula de piano 🎹🎶',
    'descricao': 'Prática da nova música 🎼',
    'local': 'Escola de Música Harmonia 🎵',
    'inicio': '28/04/2025 14:00',
    'fim': '28/04/2025 15:00',
  },
  {
    'titulo': 'Live de tecnologia 💻📡',
    'descricao': 'Assistir webinar sobre IA e Flutter 🤖🔥',
    'local': 'YouTube Live 🌐',
    'inicio': '29/04/2025 20:00',
    'fim': '29/04/2025 21:30',
  },
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (BuildContext context, int moeda) {
          return ListTile(
            title: Text(compromissosTeste[moeda]['titulo']!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(compromissosTeste[moeda]['descricao']!),
                Text(compromissosTeste[moeda]['local']!),
                Text(
                  '${compromissosTeste[moeda]['inicio']} - ${compromissosTeste[moeda]['fim']}',
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.remove_red_eye_outlined, color: AppColors.primary),
              onPressed: () {
                // Lógica para excluir o compromisso
              },
            ),
          );
        },
        padding: EdgeInsets.all(10),
        separatorBuilder: (_____, ___) => Divider(),
        itemCount: compromissosTeste.length,
      ),
    );
  }
}
