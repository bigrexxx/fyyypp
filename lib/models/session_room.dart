/* ============================ SESSION ROOM =========================== */

class SessionRoom {
  final String id;
  final String title;
  final String subtitle;
  final List<String> participants;

  const SessionRoom({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.participants,
  });
}
