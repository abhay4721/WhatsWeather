import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool darkMode;
  final bool useFahrenheit;
  final String defaultCity;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.useFahrenheit,
    required this.defaultCity,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _darkMode;
  late bool _useFahrenheit;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _darkMode = widget.darkMode;
    _useFahrenheit = widget.useFahrenheit;
    _cityController = TextEditingController(text: widget.defaultCity);
  }

  void _saveAndExit() {
    Navigator.pop(context, {
      'darkMode': _darkMode,
      'useFahrenheit': _useFahrenheit,
      'defaultCity': _cityController.text.trim().isEmpty ? "Delhi" : _cityController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: "Save",
            onPressed: _saveAndExit,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SwitchListTile(
            value: _darkMode,
            title: const Text("Dark Mode"),
            onChanged: (v) => setState(() => _darkMode = v),
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            value: _useFahrenheit,
            title: const Text("Use Fahrenheit (°F)"),
            onChanged: (v) => setState(() => _useFahrenheit = v),
            secondary: const Icon(Icons.thermostat),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: "Default City",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_city),
            ),
          ),
        ],
      ),
    );
  }
}
