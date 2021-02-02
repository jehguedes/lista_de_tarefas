class Todo {
  String title;
  String description;
  String status;

  Todo();

  Todo.fromTituloDescricao(
    String titulo,
    String descricao,
  ) {
    this.title = titulo;
    this.description = descricao;
    this.status = 'A';
  }

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['titulo'],
        description = json['descricao'],
        status = json['status'];

  Map toJson() => {
        'titulo': title,
        'descricao': description,
        'status': status,
      };
}
