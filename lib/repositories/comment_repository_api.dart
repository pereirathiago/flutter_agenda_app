import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_agenda_app/models/comment.dart';
import 'package:flutter_agenda_app/repositories/comment_repository.dart';

class CommentRepositoryApi extends ChangeNotifier implements CommentRepository {
  final String baseUrl = '$baseUrlApi/comentario';

  @override
  Future<List<Comment>> getCommentsByAppointment(String appointmentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl?appointmentId=$appointmentId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Comment.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Falha ao carregar comentários');
    }
  }

  @override
  Future<Comment> addComment(Comment comment) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(comment.toJson()),
    );

    if (response.statusCode == 201) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao adicionar comentário');
    }
  }
}
