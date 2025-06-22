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
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar comentário: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentRepo = Provider.of<CommentRepository>(context);
    final userRepo = Provider.of<UserRepository>(context);

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
          future: commentRepo.getCommentsByAppointment(widget.appointmentId),
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
              onPressed: () => _addComment(commentRepo, userRepo),
            ),
          ],
        ),
      ],
    );
  }
}
