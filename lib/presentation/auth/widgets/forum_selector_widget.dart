import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/firestore_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/forum_model.dart';

class ForumSelectorWidget extends StatefulWidget {
  final List<String> selectedForumIds;
  final ValueChanged<List<String>> onSelectionChanged;

  const ForumSelectorWidget({
    super.key,
    required this.selectedForumIds,
    required this.onSelectionChanged,
  });

  @override
  State<ForumSelectorWidget> createState() => _ForumSelectorWidgetState();
}

class _ForumSelectorWidgetState extends State<ForumSelectorWidget> {
  List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedForumIds);
  }

  void _toggle(String forumId) {
    setState(() {
      if (_selected.contains(forumId)) {
        _selected.remove(forumId);
      } else {
        _selected.add(forumId);
      }
    });
    widget.onSelectionChanged(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreConstants.forums)
          .orderBy(FirestoreConstants.forumCreatedAt)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading forums',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.error),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                const Icon(Icons.forum_outlined,
                    size: 40, color: AppColors.textHint),
                const SizedBox(height: 12),
                Text(
                  'No forums available yet',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Forums will be added by the admin. You can still proceed.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          );
        }

        final forums = docs
            .map((doc) => ForumModel.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_selected.length} forum(s) selected',
              style: AppTypography.labelMedium.copyWith(
                color: _selected.isEmpty
                    ? AppColors.textHint
                    : AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: forums.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final forum = forums[index];
                final isSelected = _selected.contains(forum.id);

                return GestureDetector(
                  onTap: () => _toggle(forum.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.07)
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.divider,
                        width: isSelected ? 2 : 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        // ── Forum Icon ──
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              forum.name.isNotEmpty
                                  ? forum.name[0].toUpperCase()
                                  : 'F',
                              style: AppTypography.headingSmall.copyWith(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // ── Forum Info ──
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                forum.name,
                                style: AppTypography.headingSmall,
                              ),
                              if (forum.description.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(
                                  forum.description,
                                  style: AppTypography.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                '${forum.memberCount} member${forum.memberCount == 1 ? '' : 's'}',
                                style: AppTypography.labelSmall,
                              ),
                            ],
                          ),
                        ),

                        // ── Checkbox ──
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textHint,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppColors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}