import 'package:builder_customer/feature/home/domain/entities/checklist_entity.dart';
import 'package:flutter/material.dart';

// assume each checklist item has: stage, tasks[{taskName, status, remarks}]

class ChecklistListView extends StatefulWidget {
  final List<ChecklistEntity> checklist;
  const ChecklistListView({super.key, required this.checklist});

  @override
  State<ChecklistListView> createState() => _ChecklistListViewState();
}

class _ChecklistListViewState extends State<ChecklistListView> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.checklist.length,
      itemBuilder: (context, index) {
        final data = widget.checklist[index];
        final isExpanded = expandedIndex == index;

        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(data.stage ?? '')),
                  if (data.tasks != null && data.tasks!.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          expandedIndex = isExpanded ? null : index;
                        });
                      },
                      icon: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ),
                ],
              ),
              if (isExpanded && data.tasks != null)
                ...data.tasks!.map((task) {
                  final Color statusColor = switch (task.status) {
                    1 => Colors.green,
                    0 => Colors.yellow,
                    -1 => Colors.grey,
                    _ => Colors.red,
                  };

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: statusColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(child: Text(task.taskName ?? '')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
