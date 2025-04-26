import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/location.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_input_widget.dart';

class LocationNewView extends StatefulWidget {
  const LocationNewView({super.key});

  @override
  State<LocationNewView> createState() => _LocationNewViewState();
}

class _LocationNewViewState extends State<LocationNewView> {
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();

  bool _noNumber = false;
  bool _isReadOnly = false;
  Location? _location;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map) {
      _location = arguments['location'] as Location?;
      _isReadOnly = arguments['readonly'] == true;

      if (_location != null) {
        _zipCodeController.text = _location?.zipCode ?? '';
        _addressController.text = _location?.address ?? '';
        _noNumber = _location?.noNumber ?? false;
        _numberController.text = _location?.number ?? '';
        _cityController.text = _location?.city ?? '';
        _stateController.text = _location?.state ?? '';
        _neighborhoodController.text = _location?.neighborhood ?? '';
      }
    }
  }

  void _saveLocation() {
    final newLocation = Location(
      zipCode: _zipCodeController.text,
      address: _addressController.text,
      noNumber: _noNumber,
      number: _noNumber ? '' : _numberController.text,
      city: _cityController.text,
      state: _stateController.text,
      neighborhood: _neighborhoodController.text,
    );

    Navigator.pop(context, newLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Local'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppInputWidget(
              label: 'CEP',
              hintText: 'Digite o CEP',
              controller: _zipCodeController,
              keyboardType: TextInputType.number,
              readOnly: _isReadOnly,
            ),
            const SizedBox(height: 16),
            AppInputWidget(
              label: 'Endereço',
              hintText: 'Digite o endereço',
              controller: _addressController,
              readOnly: _isReadOnly,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: AppInputWidget(
                    label: 'Número',
                    hintText: 'Digite o número',
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    readOnly: _isReadOnly || _noNumber,
                  ),
                ),
                const SizedBox(width: 16),
                if (!_isReadOnly)
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Sem número'),
                      value: _noNumber,
                      onChanged: (value) {
                        setState(() {
                          _noNumber = value ?? false;
                          if (_noNumber) _numberController.clear();
                        });
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            AppInputWidget(
              label: 'Bairro',
              hintText: 'Digite o bairro',
              controller: _neighborhoodController,
              readOnly: _isReadOnly,
            ),
            const SizedBox(height: 16),
            AppInputWidget(
              label: 'Cidade',
              hintText: 'Digite a cidade',
              controller: _cityController,
              readOnly: _isReadOnly,
            ),
            const SizedBox(height: 16),
            AppInputWidget(
              label: 'Estado',
              hintText: 'Digite o estado',
              controller: _stateController,
              readOnly: _isReadOnly,
            ),
            const SizedBox(height: 32),
            if (!_isReadOnly)
              AppButtonWidget(
                text: _location == null ? 'Cadastrar' : 'Editar',
                onPressed: _saveLocation,
              ),
          ],
        ),
      ),
    );
  }
}
