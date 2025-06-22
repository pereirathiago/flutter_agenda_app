import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/comment.dart';

abstract class CommentRepository extends ChangeNotifier {
  Future<Comment> addComment(Comment comment);
  Future<List<Comment>> getCommentsByAppointment(String appointmentId);
}
