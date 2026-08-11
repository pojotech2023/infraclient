import 'package:builder_customer/feature/home/domain/entities/checklist_entity.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/env_service.dart';

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
      physics: const AlwaysScrollableScrollPhysics(),
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
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
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
                                if (task.image.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32, top: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => Scaffold(
                                            backgroundColor: Colors.black,
                                            appBar: AppBar(
                                              backgroundColor: Colors.black,
                                              iconTheme: const IconThemeData(color: Colors.white),
                                            ),
                                            body: Center(
                                              child: InteractiveViewer(
                                                panEnabled: true,
                                                minScale: 0.5,
                                                maxScale: 4.0,
                                                child: Image.network(
                                                  task.image.startsWith('http') 
                                                    ? task.image 
                                                    : '${EnvService.getString('IMAGE_URL')}/${task.image}',
                                                  errorBuilder: (context, error, stackTrace) =>
                                                      const Icon(Icons.broken_image, color: Colors.white, size: 50),
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return const CircularProgressIndicator(color: Colors.white);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                                      },
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            task.image.startsWith('http') 
                                              ? task.image 
                                              : '${EnvService.getString('IMAGE_URL')}/${task.image}',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image, color: Colors.grey),
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                            },
                                          ),
                                        ),
                                      ),
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
