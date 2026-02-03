import 'package:flutter/material.dart';
import '../models/tutor.dart';
import '../models/review.dart';

class TutorProfilePage extends StatefulWidget {
  final Tutor tutor;

  const TutorProfilePage({super.key, required this.tutor});

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final tutor = widget.tutor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ---------------- APP BAR ----------------
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: Colors.deepPurple,
            leading: const BackButton(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () => setState(() => isFavorite = !isFavorite),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 12),
              title: Text(
                tutor.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'avatar-${tutor.id}',
                    child: Image.network(
                      tutor.avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.deepPurple.shade200,
                        child: const Icon(Icons.person, size: 80, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------- CONTENT ----------------
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth > 700 ? 700.0 : constraints.maxWidth;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoRow(tutor: tutor),
                          const SizedBox(height: 24),

                          const _SectionTitle('Skills'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: tutor.skills
                                .map(
                                  (skill) => Chip(
                                label: Text(skill),
                                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                              ),
                            )
                                .toList(),
                          ),

                          const SizedBox(height: 24),
                          const _SectionTitle('About'),
                          const SizedBox(height: 8),
                          Text(
                            'Experienced tutor specializing in ${tutor.skills.join(', ')}. '
                                'Focused on clear explanations, confidence building, and personalized learning strategies.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade700),
                          ),

                          const SizedBox(height: 28),
                          const _SectionTitle('Reviews'),
                          const SizedBox(height: 12),
                          // TODO: Replace with actual review list
                          // ...reviews.map((r) => ReviewCard(review: r)).toList(),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ---------------- ACTION BAR ----------------
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: Colors.deepPurple,
                    side: BorderSide(color: Colors.deepPurple.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.video_call),
                  label: const Text('Book Session'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final Tutor tutor;

  const _InfoRow({required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tutor.subject,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.star, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '${tutor.rating}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          '\$${tutor.price}/hr',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 22, backgroundImage: NetworkImage(review.avatar)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          review.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                              (i) => Icon(
                            i < review.rating ? Icons.star : Icons.star_border,
                            size: 14,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.comment,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
