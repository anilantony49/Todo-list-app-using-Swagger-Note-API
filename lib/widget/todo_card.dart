import 'package:flutter/material.dart';
import 'package:to_do_app/model/todo_model.dart';

class TodoCard extends StatelessWidget {
  const TodoCard(
      {super.key,
      required this.index,
      required this.item,
      required this.navigateEdit,
      required this.deleteById});
  final int index;
  final TodoModel item;
  final Function(TodoModel) navigateEdit;
  final Function(BuildContext, String) deleteById;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item.title),
        subtitle: Text(item.description),
        trailing: PopupMenuButton(onSelected: (value) {
          if (value == 'edit') {
            navigateEdit(item);
          } else if (value == 'delete') {
            deleteById(context, item.id!);
          }
        }, itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            )
          ];
        }),
      ),
    );
  }
}
