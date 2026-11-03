import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxford/data/task_lessons.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/widgets/icons/reader_icons.dart';
import 'package:oxford/widgets/oxford_dialog.dart';
import 'package:oxford/widgets/task_reader/task_action_bar.dart';
import 'package:oxford/widgets/task_reader/task_lesson_view.dart';

/// Экран задания. Листается середина, шапка и нижняя панель остаются.
class TaskReaderScreen extends StatefulWidget {
  const TaskReaderScreen({
    super.key,
    required this.initialIndex,
    this.saved = false,
    this.liked,
    this.onReaction,
  });

  final int initialIndex;
  final bool saved;
  final bool? liked;

  /// Избранное и лайк общие для всех заданий и живут дольше этого экрана.
  final void Function(bool saved, bool? liked)? onReaction;

  @override
  State<TaskReaderScreen> createState() => _TaskReaderScreenState();
}

class _TaskReaderScreenState extends State<TaskReaderScreen> {
  late final PageController _pages;
  late final List<bool> _answerShown;
  late bool _saved;
  late bool? _liked;
  int _index = 0;

  static const _overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: OxfordColors.bottomBar,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  );

  @override
  void initState() {
    super.initState();
    final last = readableTaskLessons.length - 1;
    _index = widget.initialIndex.clamp(0, last);
    _pages = PageController(initialPage: _index);
    _answerShown = List.filled(readableTaskLessons.length, false);
    _saved = widget.saved;
    _liked = widget.liked;
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    if (_index >= readableTaskLessons.length - 1) return;
    _pages.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _publish() => widget.onReaction?.call(_saved, _liked);

  void _setSaved() {
    setState(() => _saved = !_saved);
    _publish();
  }

  void _setLike() {
    setState(() => _liked = _liked == true ? null : true);
    _publish();
  }

  void _setDislike() {
    setState(() => _liked = _liked == false ? null : false);
    _publish();
  }

  Future<void> _revealAnswer(int index) async {
    final open = await showOxfordChoice(
      context,
      title: 'Показать ответ?',
      message: 'Посмотрите рекламу, чтобы открыть ответ',
    );
    if (!open || !mounted) return;
    setState(() => _answerShown[index] = true);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlay,
      child: Scaffold(
        backgroundColor: OxfordColors.readerBackground,
        body: Column(
          children: [
            const ColoredBox(
              color: OxfordColors.header,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 56,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _BackButton(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: readableTaskLessons.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) {
                  return TaskLessonView(
                    lesson: readableTaskLessons[index],
                    answerShown: _answerShown[index],
                    onRevealAnswer: () => _revealAnswer(index),
                  );
                },
              ),
            ),
            ColoredBox(
              color: OxfordColors.bottomBar,
              child: SafeArea(
                top: false,
                child: ColoredBox(
                  color: OxfordColors.readerBackground,
                  child: TaskActionBar(
                    onNext: _index >= readableTaskLessons.length - 1
                        ? null
                        : _next,
                    saved: _saved,
                    liked: _liked,
                    onSaved: _setSaved,
                    onLike: _setLike,
                    onDislike: _setDislike,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Назад',
      onPressed: () => Navigator.of(context).pop(),
      icon: const BackArrowIcon(),
    );
  }
}
