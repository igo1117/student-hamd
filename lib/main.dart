import 'package:flutter/material.dart';

void main() {
  runApp(const StudyVaultProApp());
}

// ==================== نماذج البيانات (Models) ====================

class LecturePageSlide {
  final int pageNumber;
  final String title;
  final String imageUrl;
  final String caption;
  bool isReviewed;

  LecturePageSlide({
    required this.pageNumber,
    required this.title,
    required this.imageUrl,
    required this.caption,
    this.isReviewed = false,
  });
}

class StudyNoteItem {
  final String id;
  final String heading;
  final String content;
  final String tag; // مثال: نقطة مهمة، تعريف، قانون
  bool isMastered;

  StudyNoteItem({
    required this.id,
    required this.heading,
    required this.content,
    required this.tag,
    this.isMastered = false,
  });
}

class AssignmentItem {
  final String id;
  final String title;
  final String details;
  final String dueLabel;
  bool isCompleted;

  AssignmentItem({
    required this.id,
    required this.title,
    required this.details,
    required this.dueLabel,
    this.isCompleted = false,
  });
}

class LectureRecord {
  final String id;
  final String title;
  final String summary;
  final List<LecturePageSlide> pages;
  final List<StudyNoteItem> notes;
  final List<AssignmentItem> assignments;
  final DateTime createdAt;

  LectureRecord({
    required this.id,
    required this.title,
    required this.summary,
    required this.pages,
    required this.notes,
    required this.assignments,
    required this.createdAt,
  });
}

class SubjectRecord {
  final int id;
  final String name;
  final String? professorName;
  final int colorValue;
  final List<LectureRecord> lectures;

  SubjectRecord({
    required this.id,
    required this.name,
    this.professorName,
    required this.colorValue,
    List<LectureRecord>? lectures,
  }) : lectures = lectures ?? [];
}

// ==================== التطبيق الرئيسي ====================

class StudyVaultProApp extends StatelessWidget {
  const StudyVaultProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Vault Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12121A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF12121A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: SubjectsHomeScreen(),
      ),
    );
  }
}

// ==================== الشاشة الرئيسية: المواد الدراسية ====================

class SubjectsHomeScreen extends StatefulWidget {
  const SubjectsHomeScreen({super.key});

  @override
  State<SubjectsHomeScreen> createState() => _SubjectsHomeScreenState();
}

class _SubjectsHomeScreenState extends State<SubjectsHomeScreen> {
  final List<SubjectRecord> _subjects = [];
  int _nextSubjectId = 1;

  final List<int> _palette = const [
    0xFF1E88E5, // أزرق ملكي
    0xFF00897B, // زمردي
    0xFF8E24AA, // بنفسجي عميق
    0xFFE53935, // أحمر قرمزي
    0xFFF4511E, // برتقالي داكن
    0xFF3949AB, // نيلي
  ];

  void _showAddSubjectSheet() {
    final nameController = TextEditingController();
    final profController = TextEditingController();
    int selectedColor = _palette.first;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
              left: 24,
              right: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إضافة مادة دراسية جديدة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'اسم المادة (مثال: برمجة C++ / تفاضل)',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF2A2A3D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'يرجى إدخال اسم المادة'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: profController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'اسم الدكتور / المدرس (اختياري)',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF2A2A3D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'اختر لوناً مميزاً للمادة:',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _palette.map((colorVal) {
                      final isSelected = selectedColor == colorVal;
                      return GestureDetector(
                        onTap: () =>
                            setModalState(() => selectedColor = colorVal),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(colorVal),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(selectedColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            _subjects.insert(
                              0,
                              SubjectRecord(
                                id: _nextSubjectId++,
                                name: nameController.text.trim(),
                                professorName:
                                    profController.text.trim().isEmpty
                                    ? null
                                    : profController.text.trim(),
                                colorValue: selectedColor,
                              ),
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'حفظ المادة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSubject(SubjectRecord subject) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: SubjectLecturesListScreen(subject: subject),
        ),
      ),
    );
    setState(() {});
  }

  void _deleteSubject(SubjectRecord subject) {
    setState(() {
      _subjects.removeWhere((item) => item.id == subject.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حقيبتي الدراسية الاحترافية',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _subjects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 76,
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'لا توجد مواد مضافة بعد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'اضغط على (مادة جديدة) لإضافة مادتك والدكتور',
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.92,
              ),
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                final color = Color(subject.colorValue);

                return GestureDetector(
                  onTap: () => _openSubject(subject),
                  onLongPress: () => _deleteSubject(subject),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.92),
                          color.withValues(alpha: 0.58),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.auto_stories_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.28),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${subject.lectures.length} محاضرات',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (subject.professorName != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'د. ${subject.professorName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSubjectSheet,
        backgroundColor: const Color(0xFF1E88E5),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'مادة جديدة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ==================== شاشة قائمة محاضرات المادة ====================

class SubjectLecturesListScreen extends StatefulWidget {
  final SubjectRecord subject;

  const SubjectLecturesListScreen({super.key, required this.subject});

  @override
  State<SubjectLecturesListScreen> createState() =>
      _SubjectLecturesListScreenState();
}

class _SubjectLecturesListScreenState extends State<SubjectLecturesListScreen> {
  void _showCreateLectureDialog() {
    final titleController = TextEditingController();
    final summaryController = TextEditingController();
    final firstNoteHeadingController = TextEditingController();
    final firstNoteContentController = TextEditingController();
    final assignmentTitleController = TextEditingController();
    final assignmentDetailsController = TextEditingController();
    final pagesCountController = TextEditingController(text: '3');

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text(
            'إنشاء محاضرة للمذاكرة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'عنوان المحاضرة (مثال: المحاضرة الأولى)',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: summaryController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'ملخص عام للمحاضرة',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pagesCountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'عدد صفحات / صور المحاضرة (مثلاً 3)',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 14),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'ملاحظة أساسية أولية (اختياري):',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: firstNoteHeadingController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'عنوان الملاحظة',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: firstNoteContentController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'تفاصيل الملاحظة أو القانون أو المفهوم',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 14),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'واجب المحاضرة (اختياري):',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: assignmentTitleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'عنوان الواجب',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: assignmentDetailsController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'مطلوب الواجب',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(widget.subject.colorValue),
              ),
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isEmpty) return;

                final pagesCount =
                    (int.tryParse(pagesCountController.text.trim()) ?? 2).clamp(
                      1,
                      15,
                    );

                final sampleImages = [
                  'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1000&q=80',
                  'https://images.unsplash.com/photo-1509228468518-180dd4864904?auto=format&fit=crop&w=1000&q=80',
                  'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&w=1000&q=80',
                ];

                final generatedPages = List.generate(pagesCount, (idx) {
                  final pageNum = idx + 1;
                  return LecturePageSlide(
                    pageNumber: pageNum,
                    title: 'الصورة $pageNum — صفحة المحاضرة رقم $pageNum',
                    imageUrl: sampleImages[idx % sampleImages.length],
                    caption:
                        'شرح الصفحة رقم $pageNum من $title — ركّز على المفاهيم والأمثلة الموضحة.',
                  );
                });

                final notes = <StudyNoteItem>[];
                if (firstNoteHeadingController.text.trim().isNotEmpty ||
                    firstNoteContentController.text.trim().isNotEmpty) {
                  notes.add(
                    StudyNoteItem(
                      id: '${DateTime.now().millisecondsSinceEpoch}_n1',
                      heading: firstNoteHeadingController.text.trim().isEmpty
                          ? 'نقطة مذاكرة مهمة'
                          : firstNoteHeadingController.text.trim(),
                      content: firstNoteContentController.text.trim(),
                      tag: 'مذاكرة',
                    ),
                  );
                }

                final assignments = <AssignmentItem>[];
                if (assignmentTitleController.text.trim().isNotEmpty) {
                  assignments.add(
                    AssignmentItem(
                      id: '${DateTime.now().millisecondsSinceEpoch}_a1',
                      title: assignmentTitleController.text.trim(),
                      details: assignmentDetailsController.text.trim().isEmpty
                          ? 'حل التمارين المطلوبة ومراجعتها قبل المحاضرة القادمة.'
                          : assignmentDetailsController.text.trim(),
                      dueLabel: 'مطلوب تسليمه',
                    ),
                  );
                }

                final lecture = LectureRecord(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title,
                  summary: summaryController.text.trim().isEmpty
                      ? 'محاضرة منظمة للمذاكرة تشمل الصور، الملاحظات، والواجبات.'
                      : summaryController.text.trim(),
                  pages: generatedPages,
                  notes: notes,
                  assignments: assignments,
                  createdAt: DateTime.now(),
                );

                setState(() {
                  widget.subject.lectures.insert(0, lecture);
                });

                Navigator.pop(context);
              },
              child: const Text(
                'إضافة المحاضرة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLectureWorkspace(LectureRecord lecture) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: LectureStudyWorkspaceScreen(
            subject: widget.subject,
            lecture: lecture,
          ),
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.subject.colorValue);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.subject.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (widget.subject.professorName != null)
              Text(
                'د. ${widget.subject.professorName}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
          ],
        ),
        backgroundColor: color.withValues(alpha: 0.35),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateLectureDialog,
        backgroundColor: color,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'محاضرة جديدة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: widget.subject.lectures.isEmpty
          ? const Center(
              child: Text(
                'لا توجد محاضرات في هذه المادة بعد\nاضغط (محاضرة جديدة) لبدء تنظيم المذاكرة',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 15),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.subject.lectures.length,
              itemBuilder: (context, index) {
                final lecture = widget.subject.lectures[index];
                final reviewedCount = lecture.pages
                    .where((p) => p.isReviewed)
                    .length;
                final pendingAssignments = lecture.assignments
                    .where((a) => !a.isCompleted)
                    .length;

                return Card(
                  color: const Color(0xFF1A1A28),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: color.withValues(alpha: 0.3)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _openLectureWorkspace(lecture),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: color.withValues(alpha: 0.22),
                                child: Icon(
                                  Icons.menu_book_rounded,
                                  color: color,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  lecture.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 16,
                                color: Colors.white54,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            lecture.summary,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _InfoChip(
                                label:
                                    'الصور: $reviewedCount/${lecture.pages.length} مراجعة',
                                color: Colors.lightBlueAccent,
                              ),
                              _InfoChip(
                                label: 'الملاحظات: ${lecture.notes.length}',
                                color: const Color.fromARGB(255, 36, 45, 43),
                              ),
                              _InfoChip(
                                label: 'الواجبات المتبقية: $pendingAssignments',
                                color: Colors.amberAccent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ==================== مساحة المذاكرة الاحترافية داخل المحاضرة ====================

class LectureStudyWorkspaceScreen extends StatefulWidget {
  final SubjectRecord subject;
  final LectureRecord lecture;

  const LectureStudyWorkspaceScreen({
    super.key,
    required this.subject,
    required this.lecture,
  });

  @override
  State<LectureStudyWorkspaceScreen> createState() =>
      _LectureStudyWorkspaceScreenState();
}

class _LectureStudyWorkspaceScreenState
    extends State<LectureStudyWorkspaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _addSlideDialog() {
    final titleController = TextEditingController(
      text: 'الصورة ${widget.lecture.pages.length + 1}',
    );
    final captionController = TextEditingController();
    final imageUrlController = TextEditingController(
      text:
          'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=1000&q=80',
    );

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text(
            'إضافة صورة جديدة للمحاضرة',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'عنوان الصفحة / الصورة',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: captionController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'ملاحظة سريعة على هذه الصورة',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageUrlController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'رابط الصورة (أو اترك الافتراضي للمعاينة)',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(widget.subject.colorValue),
              ),
              onPressed: () {
                final newIndex = widget.lecture.pages.length + 1;
                setState(() {
                  widget.lecture.pages.add(
                    LecturePageSlide(
                      pageNumber: newIndex,
                      title: titleController.text.trim().isEmpty
                          ? 'الصورة $newIndex'
                          : titleController.text.trim(),
                      imageUrl: imageUrlController.text.trim().isEmpty
                          ? 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=1000&q=80'
                          : imageUrlController.text.trim(),
                      caption: captionController.text.trim().isEmpty
                          ? 'صفحة مضافة للمذاكرة.'
                          : captionController.text.trim(),
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('إضافة', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _addNoteDialog() {
    final headingController = TextEditingController();
    final contentController = TextEditingController();
    String selectedTag = 'نقطة مهمة';

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E2C),
            title: const Text(
              'إضافة ملاحظة احترافية للمذاكرة',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: headingController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'عنوان الملاحظة أو المفهوم',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: contentController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'شرح أو قاعدة أو ملخص للمذاكرة',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedTag,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF2A2A3D),
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(
                        value: 'نقطة مهمة',
                        child: Text('نقطة مهمة'),
                      ),
                      DropdownMenuItem(
                        value: 'تعريف / قاعدة',
                        child: Text('تعريف / قاعدة'),
                      ),
                      DropdownMenuItem(
                        value: 'مراجعة امتحان',
                        child: Text('مراجعة امتحان'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedTag = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(widget.subject.colorValue),
                ),
                onPressed: () {
                  if (headingController.text.trim().isEmpty &&
                      contentController.text.trim().isEmpty) {
                    return;
                  }
                  setState(() {
                    widget.lecture.notes.insert(
                      0,
                      StudyNoteItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        heading: headingController.text.trim().isEmpty
                            ? 'ملاحظة دراسية'
                            : headingController.text.trim(),
                        content: contentController.text.trim(),
                        tag: selectedTag,
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'حفظ الملاحظة',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addAssignmentDialog() {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    final dueController = TextEditingController(text: 'قبل المحاضرة القادمة');

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text(
            'إضافة واجب للمحاضرة',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'عنوان الواجب',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: detailsController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'تفاصيل الحل أو المطلوب',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dueController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'موعد التسليم',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(widget.subject.colorValue),
              ),
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;
                setState(() {
                  widget.lecture.assignments.insert(
                    0,
                    AssignmentItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      details: detailsController.text.trim(),
                      dueLabel: dueController.text.trim().isEmpty
                          ? 'مطلوب'
                          : dueController.text.trim(),
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text(
                'إضافة الواجب',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Color(widget.subject.colorValue);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lecture.title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.subject.name}${widget.subject.professorName != null ? ' • د. ${widget.subject.professorName}' : ''}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: accentColor.withValues(alpha: 0.35),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: accentColor,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(
              icon: Icon(Icons.photo_library_outlined),
              text: 'الصور والصفحات',
            ),
            Tab(icon: Icon(Icons.edit_note_rounded), text: 'الملاحظات'),
            Tab(
              icon: Icon(Icons.assignment_turned_in_outlined),
              text: 'الواجبات',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPagesStudyTab(accentColor),
          _buildNotesStudyTab(accentColor),
          _buildAssignmentsTab(accentColor),
        ],
      ),
    );
  }

  // --- التبويب الأول: عرض الصور والصفحات بأسلوب مذاكرة احترافي ---
  Widget _buildPagesStudyTab(Color accentColor) {
    final pages = widget.lecture.pages;
    if (pages.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: _addSlideDialog,
          style: ElevatedButton.styleFrom(backgroundColor: accentColor),
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: const Text('إضافة أول صورة للمحاضرة'),
        ),
      );
    }

    final currentSlide = pages[_currentPageIndex.clamp(0, pages.length - 1)];

    return Column(
      children: [
        // شريط علوي يوضح الصورة الحالية وإمكانية إضافة صورة جديدة
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الصفحة ${_currentPageIndex + 1} من ${pages.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  FilterChip(
                    selected: currentSlide.isReviewed,
                    selectedColor: Colors.green.withValues(alpha: 0.28),
                    checkmarkColor: Colors.greenAccent,
                    label: Text(
                      currentSlide.isReviewed
                          ? 'تمت المذاكرة'
                          : 'لم تُذاكر بعد',
                      style: TextStyle(
                        color: currentSlide.isReviewed
                            ? Colors.greenAccent
                            : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    onSelected: (val) {
                      setState(() {
                        currentSlide.isReviewed = val;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addSlideDialog,
                    icon: Icon(Icons.add_photo_alternate, color: accentColor),
                    tooltip: 'إضافة صورة',
                  ),
                ],
              ),
            ],
          ),
        ),

        // عارض الصور الرئيسي القابل للتكبير والتنقل باللمس
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (idx) {
              setState(() => _currentPageIndex = idx);
            },
            itemBuilder: (context, idx) {
              final slide = pages[idx];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          color: const Color(0xFF1A1A28),
                          child: InteractiveViewer(
                            minScale: 1.0,
                            maxScale: 3.5,
                            child: Image.network(
                              slide.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        size: 56,
                                        color: accentColor,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        slide.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'تعذر تحميل الصورة من الشبكة — يمكنك تكبير البطاقة ومراجعة الشرح بالأسفل',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A28),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slide.title,
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            slide.caption,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // شريط مصغرات الصور السريع للتنقل بين الصورة الأولى والثانية وغيرها
        SizedBox(
          height: 76,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            itemCount: pages.length,
            itemBuilder: (context, idx) {
              final isSelected = idx == _currentPageIndex;
              final slide = pages[idx];
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    idx,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 68,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor.withValues(alpha: 0.25)
                        : const Color(0xFF1A1A28),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? accentColor : Colors.white12,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'صورة ${slide.pageNumber}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Icon(
                        slide.isReviewed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 14,
                        color: slide.isReviewed
                            ? Colors.greenAccent
                            : Colors.white38,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- التبويب الثاني: الملاحظات الاحترافية للمذاكرة ---
  Widget _buildNotesStudyTab(Color accentColor) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNoteDialog,
        backgroundColor: accentColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'إضافة ملاحظة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: widget.lecture.notes.isEmpty
          ? const Center(
              child: Text(
                'لا توجد ملاحظات مضافة لهذه المحاضرة بعد\nاضغط (إضافة ملاحظة) لتسجيل النقاط المهمة للمذاكرة',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 15),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.lecture.notes.length,
              itemBuilder: (context, idx) {
                final note = widget.lecture.notes[idx];
                return Card(
                  color: const Color(0xFF1A1A28),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _InfoChip(label: note.tag, color: accentColor),
                            IconButton(
                              icon: Icon(
                                note.isMastered
                                    ? Icons.verified
                                    : Icons.check_circle_outline,
                                color: note.isMastered
                                    ? Colors.greenAccent
                                    : Colors.white54,
                              ),
                              tooltip: 'تم فهمها وحفظها',
                              onPressed: () {
                                setState(() {
                                  note.isMastered = !note.isMastered;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          note.heading,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (note.content.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            note.content,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // --- التبويب الثالث: الواجبات الخاصة بالمحاضرة ---
  Widget _buildAssignmentsTab(Color accentColor) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAssignmentDialog,
        backgroundColor: accentColor,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text(
          'إضافة واجب',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: widget.lecture.assignments.isEmpty
          ? const Center(
              child: Text(
                'لا توجد واجبات مسجلة لهذه المحاضرة\nاضغط (إضافة واجب) لمتابعة التكاليف والأسئلة',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 15),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.lecture.assignments.length,
              itemBuilder: (context, idx) {
                final item = widget.lecture.assignments[idx];
                return Card(
                  color: const Color(0xFF1A1A28),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CheckboxListTile(
                    value: item.isCompleted,
                    activeColor: Colors.greenAccent,
                    checkColor: Colors.black,
                    onChanged: (val) {
                      setState(() {
                        item.isCompleted = val ?? false;
                      });
                    },
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.details.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.details,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          'الموعد: ${item.dueLabel}',
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
