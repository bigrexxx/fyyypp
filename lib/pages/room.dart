import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// --- Improved Models ---
class ChatMessage {
  final String id;
  final String sender;
  final String? message;
  final bool isMe;
  final DateTime timestamp;
  final bool isVoice;
  final String? audioPath;

  ChatMessage({
    required this.id,
    required this.sender,
    this.message,
    required this.isMe,
    required this.timestamp,
    this.isVoice = false,
    this.audioPath,
  });
}

// --- Main Screen ---
class RoomScreen extends StatefulWidget {
  final dynamic room; // Using dynamic for demo; replace with your SessionRoom model
  const RoomScreen({super.key, required this.room});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  String? _currentlyPlayingId;
  double _playbackProgress = 0.0;
  bool _isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initAudio();
    _controller.addListener(() {
      setState(() => _isTextEmpty = _controller.text.trim().isEmpty);
    });

    // Mock initial data
    _messages.add(ChatMessage(
        id: '1', sender: 'David', message: 'Ready for the session?', isMe: false, timestamp: DateTime.now()
    ));
  }

  Future<void> _initAudio() async {
    await _recorder!.openRecorder();
    await _player!.openPlayer();
    await _recorder!.setSubscriptionDuration(const Duration(milliseconds: 50));
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _player?.closePlayer();
    _controller.dispose();
    super.dispose();
  }

  // --- Logic Functions ---

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    final msg = ChatMessage(
      id: DateTime.now().toString(),
      sender: 'Alex',
      message: _controller.text.trim(),
      isMe: true,
      timestamp: DateTime.now(),
    );
    setState(() => _messages.add(msg));
    _controller.clear();
    _scrollToBottom();
  }

  Future<void> _toggleRecording() async {
    if (!_isRecording) {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) return;

      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder!.startRecorder(toFile: path, codec: Codec.aacADTS);
      setState(() => _isRecording = true);
    } else {
      final path = await _recorder!.stopRecorder();
      setState(() => _isRecording = false);
      if (path != null) {
        _messages.add(ChatMessage(
          id: DateTime.now().toString(),
          sender: 'Alex',
          isMe: true,
          isVoice: true,
          audioPath: path,
          timestamp: DateTime.now(),
        ));
        _scrollToBottom();
      }
    }
  }

  Future<void> _playVoice(ChatMessage msg) async {
    if (_currentlyPlayingId == msg.id) {
      await _player!.stopPlayer();
      setState(() => _currentlyPlayingId = null);
      return;
    }

    await _player!.startPlayer(
      fromURI: msg.audioPath,
      whenFinished: () => setState(() => _currentlyPlayingId = null),
    );

    _player!.onProgress!.listen((e) {
      setState(() {
        _currentlyPlayingId = msg.id;
        _playbackProgress = e.position.inMilliseconds / e.duration.inMilliseconds;
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(backgroundColor: Colors.deepPurple.shade50, child: const Icon(Icons.group, color: Colors.deepPurple)),
            const SizedBox(width: 12),
            const Text("Study Group", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _ChatBubble(
                msg: _messages[index],
                isPlaying: _currentlyPlayingId == _messages[index].id,
                progress: _currentlyPlayingId == _messages[index].id ? _playbackProgress : 0.0,
                onPlay: () => _playVoice(_messages[index]),
              ),
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline, color: Colors.deepPurple)),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: _isRecording ? "Recording..." : "Message...",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onLongPress: _toggleRecording,
              onLongPressUp: _toggleRecording,
              child: FloatingActionButton.small(
                elevation: 0,
                backgroundColor: Colors.deepPurple,
                onPressed: _isTextEmpty ? null : _sendMessage,
                child: Icon(_isTextEmpty ? (_isRecording ? Icons.stop : Icons.mic) : Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Specialized UI Components ---

class _ChatBubble extends StatelessWidget {
  final ChatMessage msg;
  final bool isPlaying;
  final double progress;
  final VoidCallback onPlay;

  const _ChatBubble({required this.msg, required this.isPlaying, required this.progress, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              gradient: msg.isMe ? const LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]) : null,
              color: msg.isMe ? null : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(msg.isMe ? 16 : 0),
                bottomRight: Radius.circular(msg.isMe ? 0 : 16),
              ),
            ),
            child: msg.isVoice ? _buildVoiceContent() : Text(msg.message!, style: TextStyle(color: msg.isMe ? Colors.white : Colors.black87, fontSize: 15)),
          ),
          Text(DateFormat('hh:mm a').format(msg.timestamp), style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildVoiceContent() {
    return GestureDetector(
      onTap: onPlay,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: msg.isMe ? Colors.white : Colors.deepPurple),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: msg.isMe ? Colors.white24 : Colors.grey.shade300,
              color: msg.isMe ? Colors.white : Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}