import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/comment.dart';
import 'package:flutter_agenda_app/repositories/comment_repository.dart';
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
  final TextEditingController _commentController = TextEditingController();
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    final commentRepo = Provider.of<CommentRepository>(context, listen: false);
    _commentsFuture = commentRepo.getCommentsByAppointment(
      widget.appointmentId,
    );
  }

  Future<void> _addComment(
    CommentRepository commentRepo,
    UserRepository userRepo,
  ) async {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = Comment(
      id: '',
      appointmentId: widget.appointmentId,
      userId: userRepo.loggedUser!.id.toString(),
      userName: userRepo.loggedUser!.fullName,
      userAvatarUrl: userRepo.loggedUser!.profilePicture!,
      text: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await commentRepo.addComment(newComment);
      _commentController.clear();
      _commentsFuture = commentRepo.getCommentsByAppointment(
        widget.appointmentId,
      );
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar comentário: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteComment(String commentId) async {
    final commentRepo = Provider.of<CommentRepository>(context, listen: false);
    try {
      await commentRepo.deleteComment(commentId);
      _commentsFuture = commentRepo.getCommentsByAppointment(
        widget.appointmentId,
      );

      setState(() {});

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comentário deletado com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deletar comentário: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDelete(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Deletar comentário'),
            content: const Text(
              'Tem certeza que deseja deletar este comentário?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteComment(commentId);
                },
                child: const Text(
                  'Deletar',
                  style: TextStyle(color: AppColors.delete),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final commentRepo = Provider.of<CommentRepository>(context);
    final userRepo = Provider.of<UserRepository>(context);
    final currentUserId = userRepo.loggedUser?.id.toString();

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
                  final isCurrentUser = comment.userId == currentUserId;

                  return GestureDetector(
                    onLongPress:
                        isCurrentUser
                            ? () => _confirmDelete(context, comment.id)
                            : null,
                    child: CommentItem(
                      comment: comment,
                      isCurrentUser: isCurrentUser,
                    ),
                  );
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
              onPressed: () => _addComment(commentRepo, userRepo),
            ),
          ],
        ),
      ],
    );
  }
}
