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
