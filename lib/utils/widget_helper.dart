import 'package:home_widget/home_widget.dart';

Future<void> updateWeatherWidget({
  required String iconType,
  required String temp,
  required String desc,
  required String city,
}) async {
  await HomeWidget.saveWidgetData<String>('weather_icon_type', iconType);
  await HomeWidget.saveWidgetData<String>('weather_temp', temp);
  await HomeWidget.saveWidgetData<String>('weather_desc', desc);
  await HomeWidget.saveWidgetData<String>('weather_city', city);
  await HomeWidget.updateWidget(name: 'HomeWidgetProvider');
}

String getWeatherDescription(int code) {
  switch (code) {
    case 0: return 'Clear';
    case 1:
    case 2: return 'Partly Cloudy';
    case 3: return 'Cloudy';
    case 45:
    case 48: return 'Fog/Mist';
    case 51:
    case 53:
    case 55:
    case 61:
    case 63:
    case 65:
    case 80:
    case 81:
    case 82: return 'Rain';
    case 71:
    case 73:
    case 75:
    case 85:
    case 86: return 'Snow';
    case 95:
    case 96:
    case 99: return 'Thunderstorm';
    default: return 'Clear';
  }
}

