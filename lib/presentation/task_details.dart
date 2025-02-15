import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/data/db/database_helper.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/providers/task_providers.dart';
import 'package:task_manager/utils/colors.dart';
import 'package:task_manager/utils/constants.dart';
import 'package:task_manager/utils/custom_widgets/bounce_button.dart';

class TaskDetails extends ConsumerStatefulWidget {
  final Task? task;
  final bool isTab;
  final Function()
      onSave;
  const TaskDetails({super.key, this.isTab = false, required this.task, required this.onSave});

  @override
  ConsumerState<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends ConsumerState<TaskDetails> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _dueDate;
  String _selectedPriority = PriorityType.medium.name;
  String _selectedStatus = TaskStatus.pending.name;

  String title = "Add New Task";
  String primaryButtonName = "Save";
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();

    setDefaultDetails();
  }

  void setDefaultDetails() async {
    if (widget.task != null) {
      setState(() {
        isUpdate = true;
        title = "Update Task";
        primaryButtonName = "Update";
        _titleController.text = widget.task!.title;
        _descController.text = widget.task!.description;
        _selectedPriority = widget.task!.priority;
        _selectedStatus = widget.task!.status;
        _dueDate = Task.parseDateTime(widget.task!.dueDate);
      });
    }
  }

  void _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _dueDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
              pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  void _saveNewTask() {
    if (_validate()) {
      Task newTask = Task(
        title: _titleController.text,
        description: _descController.text,
        status: _selectedStatus,
        dueDate: Task.formatDateTime(_dueDate!),
        priority: _selectedPriority,
        createdAt: Task.formatDateTime(DateTime.now()),
      );

      onProcessCompleted(newTask, 1);
    }
  }

  void _saveUpdatedTask() {
    if (_validate()) {
      Task newTask = Task(
        id: widget.task!.id,
        title: _titleController.text,
        description: _descController.text,
        status: _selectedStatus,
        dueDate: Task.formatDateTime(_dueDate!),
        priority: _selectedPriority,
        createdAt: widget.task!.createdAt,
      );

      onProcessCompleted(newTask, 2);
    }
  }

  bool _validate() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title is required")),
      );
      return false;
    }

    if (_descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task description is required")),
      );
      return false;
    }

    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Due Date is required")),
      );
      return false;
    }
    return true;
  }

  void onProcessCompleted(Task task, int processCode) {
    //1: create, 2: update, 3: delete
    // Navigator.pop(context, {
    //   'task': task,
    //   'code': processCode,
    // });

    Map<String, dynamic> result = {
      'task': task,
      'code': processCode,
    };

    if (result != null) {
        try {
          int processCode = result['code'];
          switch (processCode) {
            case 1:
              ref.read(taskProvider.notifier).addTask(result['task'] as Task);
              break;
            case 2:
              ref
                  .read(taskProvider.notifier)
                  .updateTask(result['task'] as Task);
              break;
            case 3:
              ref
                  .read(taskProvider.notifier)
                  .deleteTask(result['task'] as Task);
              break;
          }
        } catch (exception) {}
      }


      widget.onSave();


  }

  void deleteConfirmation() {
    customUIAlertPopUp(
        context: context,
        headerName: "Delete Task?",
        message: "Are you sure, you want to delete the task?",
        isPositivePresent: true,
        isNegativePresent: true,
        positiveButtonName: "Yes",
        negativeButtonName: "No",
        onNeutralButtonClick: () {},
        onPositiveButtonClick: () {
          onProcessCompleted(widget.task!, 3);
        },
        onNegativeButtonClick: () {});
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.isTab?Text(title, style: TextStyle(fontSize: 24, color: Theme.of(context).textTheme.bodyMedium!.color),):const SizedBox(),
                    SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: TextField(
                          controller: _titleController,
                          maxLines: 2,
                          decoration: InputDecoration(
                              hintText: "Enter Task Title",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: TextField(
                          controller: _descController,
                          maxLines: 6,
                          decoration: InputDecoration(
                              hintText: "Enter Task Description",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    BounceButton(
                      onPressed: _pickDueDate,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _dueDate == null
                                    ? "Select Due Date & Time"
                                    : Task.formatForDisplay(
                                        Task.formatDateTime(_dueDate!)),
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.calendar_today, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        // Priority Dropdown
                        Expanded(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: DropdownButtonFormField<String>(
                                value: _selectedPriority,
                                items: PriorityType.values
                                    .map((priority) => DropdownMenuItem(
                                          value: priority.name,
                                          child: Text(capitalizeFirstLetter(
                                              priority.name)),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(
                                    () => _selectedPriority = value!),
                                decoration: InputDecoration(
                                    labelText: "Priority",
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
      
                        SizedBox(width: 8),
      
                        // Status Dropdown
                        Expanded(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: DropdownButtonFormField<String>(
                                value: _selectedStatus,
                                items: TaskStatus.values
                                    .map((status) => DropdownMenuItem(
                                          value: status.name,
                                          child: Text(capitalizeFirstLetter(
                                              status.name)),
                                        ))
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => _selectedStatus = value!),
                                decoration: InputDecoration(
                                    labelText: "Status",
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          Container(
            // width: double.infinity,
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Color.fromRGBO(0, 0, 0, 0.1), width: 1))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: Row(
                children: [
                  Expanded(
                    child: BounceButton(
                      onPressed: () {
                        isUpdate ? _saveUpdatedTask() : _saveNewTask();
                      },
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(primaryButtonName,
                            style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ),
                  isUpdate
                      ? Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: BounceButton(
                            onPressed: () {
                              deleteConfirmation();
                            },
                            child: ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Icon(
                                Icons.delete,
                                size: 24,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return widget.isTab? bodyWidget : Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(child: bodyWidget),
    );
  }
}
