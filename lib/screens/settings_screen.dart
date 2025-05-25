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
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveAndExit,
            tooltip: 'Save',
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
            secondary: Icon(_darkMode ? Icons.dark_mode : Icons.light_mode),
          ),
          SwitchListTile(
            title: const Text("Temperature in °F (Fahrenheit)"),
            value: _useFahrenheit,
            onChanged: (val) => setState(() => _useFahrenheit = val),
            secondary: Icon(Icons.thermostat),
          ),
          const SizedBox(height: 22),
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: "Default City",
              prefixIcon: const Icon(Icons.location_city),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              filled: true,
              fillColor: scheme.surfaceVariant.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 36),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Save Settings"),
            onPressed: _saveAndExit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(130, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
