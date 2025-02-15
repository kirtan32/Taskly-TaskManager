
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:task_manager/utils/constants.dart';

final filterTypeProvider =
    StateNotifierProvider<FilterNotifier, bool>((ref) => FilterNotifier());


class FilterNotifier extends StateNotifier<bool> {
  static const String _filterBox = "filterBox";
  static const String _filterType = "selectedFilterType";

  FilterNotifier() : super(true) {
    loadFilterType();
  }

  Future<void> loadFilterType() async {
    var box = await Hive.openBox(_filterBox);
    state = box.get(_filterType, defaultValue: true);
  }

  Future<void> setFilterType(bool newFilter) async {
    var box = await Hive.openBox(_filterBox);
    state = newFilter;
    await box.put(_filterType, newFilter);
  }
}

final filterOptionProvider =
    StateNotifierProvider<FilterOptionNotifier, SortOptions>((ref) => FilterOptionNotifier());


class FilterOptionNotifier extends StateNotifier<SortOptions> {
  static const String _filterBox = "filterBox";
  static const String _filterOption = "selectedFilterOption";

  FilterOptionNotifier() : super(SortOptions.none) {
    loadFilterOption();
  }

  Future<void> loadFilterOption() async {
    var box = await Hive.openBox(_filterBox);
    state = box.get(_filterOption, defaultValue: SortOptions.none);
  }

  Future<void> setFilterOption(SortOptions newFilter) async {
    var box = await Hive.openBox(_filterBox);
    state = newFilter;
    await box.put(_filterOption, newFilter);
  }
}