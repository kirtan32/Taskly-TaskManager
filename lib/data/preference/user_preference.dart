

import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class UserPreferences extends HiveObject {

  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  String? filterType;

  UserPreferences({required this.isDarkMode, this.filterType});

}