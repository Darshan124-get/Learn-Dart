import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/module.dart';
import '../utils/app_theme.dart';

class ModuleCard extends StatelessWidget {
  final Module module;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Module Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(module.icon),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Module Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: AppTheme.heading3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Module Details
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        // Level Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getLevelColor(module.level).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getLevelColor(module.level).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            module.level,
                            style: AppTheme.bodySmall.copyWith(
                              color: _getLevelColor(module.level),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        // Time Estimate
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppTheme.textSecondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              module.estimatedTime,
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                        
                        // Lesson/Quiz Count
                        if (module.lessons.isNotEmpty)
                          _buildCountChip(
                            '${module.lessons.length} Lessons',
                            Icons.book,
                          ),
                        if (module.quizzes.isNotEmpty)
                          _buildCountChip(
                            '${module.quizzes.length} Quizzes',
                            Icons.quiz,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow Icon
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'play_circle':
        return Icons.play_circle;
      case 'code':
        return Icons.code;
      case 'settings':
        return Icons.settings;
      case 'functions':
        return Icons.functions;
      case 'list':
        return Icons.list;
      case 'account_tree':
        return Icons.account_tree;
      case 'error':
        return Icons.error;
      case 'security':
        return Icons.security;
      case 'schedule':
        return Icons.schedule;
      case 'build':
        return Icons.build;
      default:
        return Icons.code;
    }
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return AppTheme.successColor;
      case 'intermediate':
        return AppTheme.warningColor;
      case 'advanced':
        return AppTheme.errorColor;
      default:
        return AppTheme.primaryColor;
    }
  }
}
