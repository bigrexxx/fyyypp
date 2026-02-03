import 'package:flutter/material.dart';
import '../models/tutor.dart';
import '../pages/TutorProfilePage.dart';

class TutorCard extends StatefulWidget {
  final Tutor tutor;

  const TutorCard({super.key, required this.tutor});

  @override
  State<TutorCard> createState() => _TutorCardState();
}

class _TutorCardState extends State<TutorCard> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.tutor;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TutorProfilePage(tutor: t),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'avatar-${t.id}',
                  child: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(t.avatar),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        t.subject,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    favorite
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () =>
                      setState(() => favorite = !favorite),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${t.rating}'),
                const Spacer(),
                Text(
                  '\$${t.price}/hr',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: t.skills
                  .map(
                    (s) => Chip(
                  label: Text(s, style: const TextStyle(fontSize: 12)),
                  backgroundColor:
                  Colors.deepPurple.withOpacity(.1),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
