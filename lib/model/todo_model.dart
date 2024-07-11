class TodoModel {
  String? id;
  String title;
  String description;
  bool? isCompleted;

  TodoModel(
      {this.id,
      required this.title,
      required this.description,
       this.isCompleted});

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        isCompleted: json['is_completed'] ?? false);
  }
}
