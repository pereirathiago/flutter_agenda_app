import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/comment.dart';
import 'package:flutter_agenda_app/repositories/comment_repository.dart';
import 'package:flutter_agenda_app/repositories/comment_repository_api.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:flutter_agenda_app/ui/appointments/widget/comment_item_widget.dart';
import 'package:provider/provider.dart';

class CommentsSection extends StatefulWidget {
  final String appointmentId;

  const CommentsSection({super.key, required this.appointmentId});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final CommentRepository _commentRepository = CommentRepositoryApi();
  final TextEditingController _commentController = TextEditingController();
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _refreshComments();
  }

  void _refreshComments() {
    setState(() {
      _commentsFuture = _commentRepository.getCommentsByAppointment(
        widget.appointmentId,
      );
    });
  }

  Future<void> _addComment() async {
    final loggedUser =
        Provider.of<UserRepository>(context, listen: false).loggedUser!;
    if (_commentController.text.trim().isEmpty) return;

    final newComment = Comment(
      id: '',
      appointmentId: widget.appointmentId,
      userId: loggedUser.id.toString(),
      userName: loggedUser.fullName,
      userAvatarUrl: loggedUser.profilePicture!,
      text: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await _commentRepository.addComment(newComment);
      _commentController.clear();
      _refreshComments();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar comentário: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Comentários',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<List<Comment>>(
          future: _commentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Nenhum comentário ainda');
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final comment = snapshot.data![index];
                  return CommentItem(comment: comment);
                },
              );
            }
          },
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Adicione um comentário...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              color: AppColors.primary,
              onPressed: _addComment,
            ),
          ],
        ),
      ],
    );
  }
}
