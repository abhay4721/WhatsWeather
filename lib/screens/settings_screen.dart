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

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _saveAndExit() {
    Navigator.of(context).pop({
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
        backgroundColor: scheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            value: _useFahrenheit,
            onChanged: (val) => setState(() => _useFahrenheit = val),
            title: const Text("Use Fahrenheit (°F)"),
            secondary: const Icon(Icons.thermostat),
          ),
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: "Default City",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text("Save"),
            onPressed: _saveAndExit,
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
