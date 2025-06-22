import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/location.dart';
import 'package:flutter_agenda_app/repositories/location_repository.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/ui/widgets/app_bar_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_button_widget.dart';
import 'package:flutter_agenda_app/ui/widgets/app_input_widget.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';

class LocationNewView extends StatefulWidget {
  const LocationNewView({super.key});

  @override
  State<LocationNewView> createState() => _LocationNewViewState();
}

class _LocationNewViewState extends State<LocationNewView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();

  bool _noNumber = false;
  bool _isReadOnly = false;
  bool _useCurrentLocation = false;
  Location? _location;
  bool _loadingLocation = false;

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

  Future<void> _fillAddressFromCurrentLocation() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      try {
        Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
          localeIdentifier: 'pt_BR',
        );

        final place = placemarks.first;

        setState(() {
          _zipCodeController.text = place.postalCode ?? '';
          _addressController.text = place.street ?? '';
          _numberController.text = ''; // Não vem da API, deixar manual
          _neighborhoodController.text = place.subLocality ?? '';
          _cityController.text = place.subAdministrativeArea ?? '';
          _stateController.text = place.administrativeArea ?? '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Endereço atual detectado!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao obter localização: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleUseCurrentLocation() async {
    setState(() => _loadingLocation = true);

    final status = await Permission.location.request();
    if (!status.isGranted) {
      _showError('Permissão de localização negada.');
      setState(() => _loadingLocation = false);
      return;
    }

    await _fillAddressFromCurrentLocation();

    setState(() => _loadingLocation = false); // remove overlay
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  Future<void> _saveLocation(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final locationRepository = Provider.of<LocationRepository>(
      context,
      listen: false,
    );

    final userRepository = Provider.of<UserRepository>(context, listen: false);

    final location = Location(
      id: _location?.id,
      zipCode: _zipCodeController.text,
      address: _addressController.text,
      noNumber: _noNumber,
      number: _noNumber ? '' : _numberController.text,
      city: _cityController.text,
      state: _stateController.text,
      neighborhood: _neighborhoodController.text,
      userId: userRepository.loggedUser?.id,
    );

    try {
      if (_location == null) {
        await locationRepository.add(location);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Local cadastrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await locationRepository.update(location);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Local atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst("Exception: ", "")),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Local'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AppInputWidget(
                    label: 'CEP',
                    hintText: 'Digite o CEP',
                    controller: _zipCodeController,
                    keyboardType: TextInputType.number,
                    readOnly: _isReadOnly,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (value.length < 8) {
                        return 'CEP inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppInputWidget(
                    label: 'Endereço',
                    hintText: 'Digite o endereço',
                    controller: _addressController,
                    readOnly: _isReadOnly,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!_isReadOnly || (_isReadOnly && !_noNumber))
                        Expanded(
                          child: AppInputWidget(
                            label: 'Número',
                            hintText: 'Digite o número',
                            controller: _numberController,
                            keyboardType: TextInputType.number,
                            readOnly: _isReadOnly || _noNumber,
                            validator: (value) {
                              if (_noNumber) return null;
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              } else if (int.tryParse(value) == null) {
                                return 'Número inválido';
                              }
                              return null;
                            },
                          ),
                        ),
                      if (!_isReadOnly) const SizedBox(width: 16),
                      if (!_isReadOnly || (_isReadOnly && _noNumber))
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('Sem número'),
                            value: _noNumber,
                            onChanged:
                                _isReadOnly
                                    ? null
                                    : (value) {
                                      setState(() {
                                        _noNumber = value ?? false;
                                        if (_noNumber)
                                          _numberController.clear();
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppInputWidget(
                    label: 'Cidade',
                    hintText: 'Digite a cidade',
                    controller: _cityController,
                    readOnly: _isReadOnly,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppInputWidget(
                    label: 'Estado',
                    hintText: 'Digite o estado',
                    controller: _stateController,
                    readOnly: _isReadOnly,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isReadOnly && _location == null) ...[
                        CheckboxListTile(
                          title: const Text('Estou no local a ser cadastrado'),
                          value: _useCurrentLocation,
                          onChanged: (value) async {
                            setState(
                              () => _useCurrentLocation = value ?? false,
                            );
                            if (value == true) {
                              await _handleUseCurrentLocation();
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!_isReadOnly)
                    AppButtonWidget(
                      text: _location == null ? 'Cadastrar' : 'Editar',
                      onPressed: () => _saveLocation(context),
                    ),
                ],
              ),
            ),
          ),
          if (_loadingLocation) ...[
            // Fundo escurecido + blur
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.black45),
              ),
            ),
            // Indicador de progresso centralizado
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text(
                    'Buscando localização atual...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
