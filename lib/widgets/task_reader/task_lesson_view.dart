import 'package:flutter/material.dart';
import 'package:oxford/models/task_lesson.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/theme/oxford_text.dart';
import 'package:oxford/widgets/icons/reader_icons.dart';

/// Середина экрана задания: всё, что меняется при листании.
class TaskLessonView extends StatelessWidget {
  const TaskLessonView({super.key, required this.lesson});

  final TaskLesson lesson;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(lesson.headline, style: OxfordText.lessonTitle),
            ),
            if (lesson.speakable) ...[
              const SizedBox(width: 12),
              const _SpeakerButton(),
            ],
          ],
        ),
        const SizedBox(height: 16),
        const Divider(
          height: 1,
          thickness: 1,
          color: OxfordColors.readerDivider,
        ),
        if (lesson.transcription != null) ...[
          const SizedBox(height: 16),
          Text(lesson.transcription!, style: OxfordText.lessonTranscription),
        ],
        if (lesson.translation != null) ...[
          const SizedBox(height: 14),
          Text(lesson.translation!, style: OxfordText.lessonTranslation),
        ],
        if (lesson.note != null) ...[
          const SizedBox(height: 12),
          Text(lesson.note!, style: OxfordText.lessonNote),
        ],
        for (final paragraph in lesson.paragraphs) ...[
          const SizedBox(height: 16),
          Text(paragraph, style: OxfordText.lessonBody),
        ],
        if (lesson.sectionTitle != null) ...[
          const SizedBox(height: 32),
          Text(lesson.sectionTitle!, style: OxfordText.lessonSection),
        ],
        for (final example in lesson.examples) ...[
          const SizedBox(height: 18),
          Text(example.original, style: OxfordText.lessonOriginal),
          const SizedBox(height: 8),
          Text(example.translation, style: OxfordText.lessonExampleTranslation),
        ],
      ],
    );
  }
}

class _SpeakerButton extends StatefulWidget {
  const _SpeakerButton();

  @override
  State<_SpeakerButton> createState() => _SpeakerButtonState();
}

class _SpeakerButtonState extends State<_SpeakerButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waves;

  @override
  void initState() {
    super.initState();
    _waves = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _waves.dispose();
    super.dispose();
  }

  void _play() {
    _waves.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Произношение',
      onPressed: _play,
      icon: AnimatedBuilder(
        animation: _waves,
        builder: (context, _) {
          final t = _waves.value;
          final pulse = t == 0 ? 1.0 : 0.35 + 0.65 * (1 - (t - 0.5).abs() * 2);
          return SpeakerIcon(size: 34, waves: pulse.clamp(0, 1));
        },
      ),
    );
  }
}
