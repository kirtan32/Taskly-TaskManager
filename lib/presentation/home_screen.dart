import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/providers/filter_providers.dart';
import 'package:task_manager/data/providers/task_providers.dart';
import 'package:task_manager/data/providers/theme_provider.dart';
import 'package:task_manager/presentation/task_details.dart';
import 'package:task_manager/presentation/task_filter.dart';
import 'package:task_manager/utils/colors.dart';
import 'package:task_manager/utils/constants.dart';
import 'package:task_manager/utils/custom_widgets/bounce_button.dart';

class HomeScreen extends ConsumerStatefulWidget {

  final Function(Task? task)
      onTaskSave;
      final Function() changeTheme;
  const HomeScreen({super.key, required this.onTaskSave, required this.changeTheme});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String filterSortBySelected = '';
  bool filterSortAsc = true;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  void _navigateToTaskDetails(
      BuildContext context, WidgetRef ref, Task? task) async {
        widget.onTaskSave(task);
        
  }

  Widget getListItem(BuildContext context, WidgetRef ref, Task task) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BounceButton(
        onPressed: () {
          _navigateToTaskDetails(context, ref, task);
        },
        child: Card(
          elevation: 1.0,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1,
                color: const Color.fromRGBO(0, 0, 0, 0.05),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          top: 4.0,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: GoogleFonts.roboto(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        task.description,
                        style: GoogleFonts.roboto(
                            fontSize: 12, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              Task.formatForDisplay(task.dueDate),
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 12.0,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 4.0, 12.0, 4.0),
                                  decoration: BoxDecoration(
                                    color: getColorByStatus(task.status),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      width: 1,
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 0.05),
                                    ),
                                  ),
                                  child: Text(
                                    task.status,
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: textWhite,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 12.0,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 4.0, 12.0, 4.0),
                                  decoration: BoxDecoration(
                                    color: getColorByPriority(task.priority),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      width: 1,
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 0.05),
                                    ),
                                  ),
                                  child: Text(
                                    task.priority,
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: textWhite,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showFilterDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          insetPadding: const EdgeInsets.only(left: 24.0, right: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: TaskFilter(
            sortBySelected: ref.read(filterOptionProvider),
            isAsc: ref.read(filterTypeProvider),
            onClear: () {},
            onCancel: () {
              Navigator.of(context).pop();
            },
            onSubmit: (sortValue, sortStatus) {
              ref
                  .read(filterOptionProvider.notifier)
                  .setFilterOption(sortValue);
              ref.read(filterTypeProvider.notifier).setFilterType(sortStatus);
              ref
                  .read(taskProvider.notifier)
                  .loadTasks(isAsc: sortStatus, sortOption: sortValue);
            },
          ),
        );
      },
    );
  }

   void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        ref.read(taskProvider.notifier)
           .loadTasks(isAsc: ref.read(filterTypeProvider), sortOption: ref.read(filterOptionProvider));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(taskProvider);
    final filterType = ref.watch(filterTypeProvider);
    final filterOption = ref.watch(filterOptionProvider);

    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
 
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: isDarkMode ? darkPrimaryColor : lightPrimaryColor,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (query){
                  ref.read(taskProvider.notifier)
                     .loadTasks(isAsc: ref.read(filterTypeProvider), sortOption: ref.read(filterOptionProvider), searchQuery: query);
                },
                decoration: InputDecoration(
                  hintText: "Search ...",
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.labelMedium!.color),
                  hintStyle: TextStyle(color: Theme.of(context).textTheme.labelMedium!.color),
                ),
              )
            : Text("Taskly"),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.filter_alt),
                onPressed: () {
                  showFilterDialog(context, ref);
                },
              ),
              if (filterOption != SortOptions.none)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 255, 106),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              widget.changeTheme();
            },
          ),
        ],
      ),
      body: taskList.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_note_outlined,
                  size: 48.0,
                ),
                SizedBox(
                  height: 12,
                ),
                Text((filterOption == SortOptions.none)
                    ? "No tasks available"
                    : "No tasks available for selected filter"),
              ],
            ))
          : ListView.builder(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];
                return getListItem(context, ref, task);
              },
            ),
      floatingActionButton: BounceButton(
        onPressed: () => _navigateToTaskDetails(context, ref, null),
        child: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
