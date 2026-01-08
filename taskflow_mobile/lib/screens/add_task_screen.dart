import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../providers/app_providers.dart';
import '../services/smart_parser.dart';
import '../models/task.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool isSmartMode = true;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        bool available = await _speech.initialize();
        if (available) {
          setState(() => _isListening = true);
          _speech.listen(onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
            });
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Speech recognition not available')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission denied')),
          );
        }
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("✨ Smart AI Input"),
              subtitle: const Text("Type or say 'Meeting tomorrow urgent'"),
              value: isSmartMode,
              onChanged: (v) => setState(() => isSmartMode = v),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "What needs to be done?",
                hintText: "e.g., Buy groceries tomorrow urgent",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? Colors.red : null,
                  ),
                  onPressed: _listen,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            if (isSmartMode)
              const Text(
                "💡 AI will detect dates (today, tomorrow) and priority (urgent, important)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () async {
                if (_controller.text.isEmpty) return;

                Task newTask;
                if (isSmartMode) {
                  final data = SmartParser.parse(_controller.text);
                  newTask = Task(
                    id: 0,
                    title: data['title'],
                    category: 'General',
                    priority: data['priority'],
                    energyReq: data['energy_req'],
                    estimatedMinutes: 30,
                    isCompleted: false,
                    dueDate: data['due_date'],
                  );
                } else {
                  newTask = Task(
                    id: 0,
                    title: _controller.text,
                    category: 'General',
                    priority: 3,
                    energyReq: 3,
                    estimatedMinutes: 30,
                    isCompleted: false,
                  );
                }

                await ref.read(repositoryProvider).addTask(newTask);
                ref.refresh(taskListProvider);
                if (mounted) Navigator.pop(context);
              },
              icon: const Icon(Icons.check),
              label: const Text("Create Task"),
            )
          ],
        ),
      ),
    );
  }
}
