
import 'package:flutter/material.dart';
import '../models/injection_technique.dart';
import '../screens/injection_detail_page.dart';
import '../theme/favorites_manager.dart';

class InjectionCard extends StatelessWidget {
  final InjectionTechnique technique;

  const InjectionCard({super.key, required this.technique});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InjectionDetailPage(technique: technique),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.medical_services_outlined, color: Theme.of(context).primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      technique.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.1,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      technique.treats.first,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: technique.tags.take(2).map((tag) => _buildMiniBadge(context, tag)).toList(),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  favoritesManager.isFavorite(technique.id) ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: favoritesManager.isFavorite(technique.id) ? Colors.orange : Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                  size: 20,
                ),
                onPressed: () => favoritesManager.toggleFavorite(technique.id),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBadge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 8, 
          fontWeight: FontWeight.bold, 
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
