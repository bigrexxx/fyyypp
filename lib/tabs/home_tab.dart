import 'package:flutter/material.dart';
import '../data/mock_tutors.dart';
import '../pages/room.dart';
import '../models/session_room.dart';
import '../widgets/tutor_card.dart';

/* ============================== HOME TAB ============================== */

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTutors = tutors.where((tutor) {
      final q = _query.toLowerCase();
      return tutor.name.toLowerCase().contains(q) ||
          tutor.subject.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              sliver: SliverToBoxAdapter(
                child: HomeHeader(
                  userName: "Alex",
                  onNotificationsTap: () => _showNotificationOverlay(context),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const ActiveSessionSlider(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SearchBarField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Header for the Tutor List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recommended Tutors',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Dynamic List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: TutorList(tutors: filteredTutors),
            ),
            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  void _showNotificationOverlay(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You have no new notifications'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/* ============================== HEADER ============================== */

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationsTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // FIX: Re-added the circular shape properly
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.deepPurple.shade100, width: 2),
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello $userName 👋',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              Text(
                'Ready to learn today?',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
        _HeaderIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onNotificationsTap,
          hasBadge: true,
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _HeaderIconButton({required this.icon, required this.onTap, this.hasBadge = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(icon, size: 28, color: Colors.black87),
          onPressed: onTap,
        ),
        if (hasBadge)
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          )
      ],
    );
  }
}

/* ========================= ACTIVE SESSIONS ========================== */

class ActiveSessionSlider extends StatefulWidget {
  const ActiveSessionSlider({super.key});

  @override
  State<ActiveSessionSlider> createState() => _ActiveSessionSliderState();
}

class _ActiveSessionSliderState extends State<ActiveSessionSlider> {
  final PageController _controller = PageController(viewportFraction: 0.88);

  final List<SessionRoom> rooms = const [
    SessionRoom(id: 'physics_1', title: 'Physics with David', subtitle: 'Live in 10 min', participants: ['Alex', 'David']),
    SessionRoom(id: 'math_1', title: 'Calculus Advanced', subtitle: 'Tomorrow • 4:00 PM', participants: ['Alex', 'Sarah']),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text('Active Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _controller,
            itemCount: rooms.length,
            itemBuilder: (context, index) => ActiveSessionCard(room: rooms[index]),
          ),
        ),
      ],
    );
  }
}

class ActiveSessionCard extends StatelessWidget {
  final SessionRoom room;
  const ActiveSessionCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 3, backgroundColor: Colors.greenAccent),
                    const SizedBox(width: 6),
                    Text(room.subtitle, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            room.title,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RoomScreen(room: room))),
              child: const Text('Join Now', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================== SEARCH ============================== */

class SearchBarField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchBarField({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4)),
          ],
      ),
      child: TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
      hintText: 'Search tutors or subjects',
      prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400]),
      suffixIcon: Icon(Icons.tune_rounded, color: Colors.deepPurple.shade300), // Added filter icon
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
    ),
    );
  } 
}

/* ============================== TUTORS ============================== */

class TutorList extends StatelessWidget {
  final List tutors;
  const TutorList({super.key, required this.tutors});

  @override
  Widget build(BuildContext context) {
    if (tutors.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('No tutors match your search.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TutorCard(tutor: tutors[index]),
        ),
        childCount: tutors.length,
      ),
    );
  }
}