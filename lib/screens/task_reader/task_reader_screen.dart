import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxford/data/task_lessons.dart';
import 'package:oxford/theme/oxford_colors.dart';
import 'package:oxford/widgets/icons/reader_icons.dart';
import 'package:oxford/widgets/task_reader/task_action_bar.dart';
import 'package:oxford/widgets/task_reader/task_lesson_view.dart';

/// Экран задания. Листается середина, шапка и нижняя панель остаются.
class TaskReaderScreen extends StatefulWidget {
  const TaskReaderScreen({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  State<TaskReaderScreen> createState() => _TaskReaderScreenState();
}

class _TaskReaderScreenState extends State<TaskReaderScreen> {
  late final PageController _pages;
  late final List<_Reaction> _reactions;
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
    _index = widget.initialIndex.clamp(0, taskLessons.length - 1);
    _pages = PageController(initialPage: _index);
    _reactions = List.generate(taskLessons.length, (_) => _Reaction());
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    if (_index >= taskLessons.length - 1) return;
    _pages.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _setSaved() {
    setState(() => _reactions[_index].saved = !_reactions[_index].saved);
  }

  void _setLike() {
    setState(() {
      final reaction = _reactions[_index];
      reaction.liked = reaction.liked == true ? null : true;
    });
  }

  void _setDislike() {
    setState(() {
      final reaction = _reactions[_index];
      reaction.liked = reaction.liked == false ? null : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reaction = _reactions[_index];

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
                itemCount: taskLessons.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) {
                  return TaskLessonView(lesson: taskLessons[index]);
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
                    onNext: _next,
                    saved: reaction.saved,
                    liked: reaction.liked,
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

class _Reaction {
  bool saved = false;
  bool? liked;
}
