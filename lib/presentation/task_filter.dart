import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/utils/colors.dart';
import 'package:task_manager/utils/constants.dart';
import 'package:task_manager/utils/custom_widgets/bounce_button.dart';

class TaskFilter extends StatefulWidget {
  const TaskFilter(
      {super.key,
      required this.sortBySelected,
      required this.isAsc,
      required this.onSubmit,
      required this.onClear,
      required this.onCancel});

  final Function(SortOptions sortValue, bool sortStatus)
      onSubmit;
  final Function onClear;
  final Function onCancel;
  final SortOptions sortBySelected;
  final bool isAsc;

  @override
  State<TaskFilter> createState() {
    return _TaskFilterState();
  }
}

class _TaskFilterState extends State<TaskFilter> {
  SortOptions filterSortBySelected = SortOptions.createDate;
  bool filterSortIsAsc = true;

  @override
  void initState() {
    super.initState();
    filterSortBySelected = widget.sortBySelected;
    filterSortIsAsc = widget.isAsc;
  }

  Widget getFilterRadioCardWidget(
      {required String selectedText,
      required String refText,
      required String titleText,
      required Function(String) onClicked}) {
    bool isSelected = selectedText == refText;
    return InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
          decoration: BoxDecoration(
            // color: isSelected ? const Color(0xFFECFFE3) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleText,
                style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color,)
              ),
              isSelected
                  ? Icon(
                      Icons.radio_button_checked_rounded,
                      color: Theme.of(context).primaryColor,
                    )
                  : const Icon(
                      Icons.radio_button_off_rounded,
                      color: Color.fromARGB(255, 163, 163, 163),
                    ),
            ],
          ),
        ),
        onTap: () {
          onClicked(!isSelected ? refText : '');
        });
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 6.0,
      color: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).cardColor,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            
            ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter",
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(), // Empty space for alignment
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 0.0,
              ),
              Container(
                height: 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 2.0,
                  right: 2.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sort By",
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            if (!filterSortIsAsc) {
                              setState(() {
                                filterSortIsAsc = !filterSortIsAsc;
                              });
                            }
                          },
                          child: Container(
                            height: 24,
                            margin: const EdgeInsets.only(left: 6, right: 6),
                            child: Row(
                              children: [
                                filterSortIsAsc
                                    ? Icon(
                                        Icons.radio_button_checked_rounded,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      )
                                    : Icon(
                                        Icons.radio_button_off_rounded,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  'A - Z',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            if (filterSortIsAsc) {
                              setState(() {
                                filterSortIsAsc = !filterSortIsAsc;
                              });
                            }
                          },
                          child: Container(
                            height: 24,
                            margin: const EdgeInsets.only(left: 6, right: 6),
                            child: Row(
                              children: [
                                !filterSortIsAsc
                                    ? Icon(
                                        Icons.radio_button_checked_rounded,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      )
                                    : Icon(
                                        Icons.radio_button_off_rounded,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  'Z - A',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              getFilterRadioCardWidget(
                selectedText: filterSortBySelected.name,
                refText: SortOptions.createDate.name,
                titleText: "Create Time",
                onClicked: (value) {
                  setState(() {
                    filterSortBySelected = SortOptions.createDate;
                  });
                },
              ),
              const SizedBox(
                height: 4.0,
              ),
              getFilterRadioCardWidget(
                selectedText: filterSortBySelected.name,
                refText: SortOptions.dueDate.name,
                titleText: "Due Time",
                onClicked: (value) {
                  setState(() {
                    filterSortBySelected = SortOptions.dueDate;
                  });
                },
              ),
              const SizedBox(
                height: 4.0,
              ),
              getFilterRadioCardWidget(
                selectedText: filterSortBySelected.name,
                refText: SortOptions.priority.name,
                titleText: "Priority",
                onClicked: (value) {
                  setState(() {
                    filterSortBySelected = SortOptions.priority;
                  });
                },
              ),
              const SizedBox(
                height: 4.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: BounceButton(
                      onPressed: () {
                        setState(() {
                          filterSortBySelected = SortOptions.none;
                          filterSortIsAsc = true;
                          widget.onSubmit(filterSortBySelected, filterSortIsAsc);
                          Navigator.of(context).pop();
                        });
                      },
                      child: ElevatedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          // backgroundColor: WidgetStateProperty.all(),
                          shadowColor: WidgetStateProperty.all(grayF4),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              // side: BorderSide(
                              //   color: Theme.of(context).primaryColor, // 1-pixel gray border
                              //   width: 1,
                              // ),
                            ),
                          ),
                        ),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              'Clear',
                              style:
                                  GoogleFonts.roboto(fontSize: 14, color: gray82),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: BounceButton(
                      onPressed: () {
                        widget.onSubmit(filterSortBySelected, filterSortIsAsc);
                        Navigator.of(context).pop();
                      },
                      child: ElevatedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                          shadowColor: WidgetStateProperty.all(grayF4),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              'Apply',
                              style: GoogleFonts.roboto(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
