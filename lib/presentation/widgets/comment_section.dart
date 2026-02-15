import "package:flutter/material.dart";

import "../../../domain/entities/comment.dart";

/// Comment section with "Coming Soon" state
class CommentSection extends StatefulWidget {
  const CommentSection({
    super.key,
    required this.productId,
    required this.isFeatureAvailable,
    required this.comments,
    required this.onAddComment,
  });

  final int productId;
  final bool isFeatureAvailable;
  final List<Comment> comments;
  final Future<void> Function(String text, double rating) onAddComment;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _textController = TextEditingController();
  double _rating = 5.0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Izohlar",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 8),
            if (!widget.isFeatureAvailable)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Tez orada",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Coming Soon state
        if (!widget.isFeatureAvailable)
          _buildComingSoonState()
        else
          _buildCommentsContent(),
      ],
    );
  }

  Widget _buildComingSoonState() {
    return Opacity(
      opacity: 0.5,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Column(
          children: [
            Icon(
              Icons.comment_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              "Izohlar tez orada",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              "Bu funksiya hozircha tayyorlanmoqda.\nKeyingi yangilanishda mavjud bo'ladi.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ),
            const SizedBox(height: 16),
            // Demo izohlar
            _buildDemoComment(
              "Juda yaxshi mahsulot! ⭐⭐⭐⭐⭐",
              "5.0",
            ),
            const SizedBox(height: 8),
            _buildDemoComment(
              "Sifati a'lo darajada 👍",
              "4.8",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoComment(String text, String rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, size: 16, color: Colors.grey.shade500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add comment form
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _textController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Fikringizni yozing...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "Baho:",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    ...List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => _rating = index + 1.0),
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 24,
                        ),
                      );
                    }),
                    const Spacer(),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submitComment,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Yuborish"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Comments list
        if (widget.comments.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Hali izohlar yo'q. Birinchi bo'lib yozing!"),
            ),
          )
        else
          ...widget.comments.map((comment) => _CommentCard(comment: comment)),
      ],
    );
  }

  Future<void> _submitComment() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      await widget.onAddComment(_textController.text.trim(), _rating);
      _textController.clear();
      setState(() => _rating = 5.0);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Izoh qo'shildi")),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Xatolik: $error")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    comment.userEmail[0].toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userEmail,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            comment.rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(comment.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(comment.text),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) return "${diff.inDays} kun oldin";
    if (diff.inHours > 0) return "${diff.inHours} soat oldin";
    if (diff.inMinutes > 0) return "${diff.inMinutes} daqiqa oldin";
    return "Hozir";
  }
}
