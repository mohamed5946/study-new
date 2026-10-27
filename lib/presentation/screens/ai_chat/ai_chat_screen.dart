import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/services/ai_service.dart';
import '../../../data/services/hive_service.dart';
import '../../providers/app_provider.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isThinking = false;

  final List<List<String>> _promptGroups = [
    ['لخّص لي هذا الموضوع', 'أعطني أسئلة تدريبية', 'اشرح بمخطط'],
    ['اشرح لي الكود', 'ما الفرق بين ...', 'أعطني مثال عملي'],
    ['كيف أذاكر هذه المادة؟', 'نصيحة قبل الامتحان', 'رتّب لي خطة مذاكرة'],
  ];
  int _promptGroupIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    final box = HiveService.chatBox;
    _messages.addAll(box.values.toList());
    if (_messages.isEmpty) {
      _messages.add(ChatMessage(
        role: 'assistant',
        content: 'مرحبًا! أنا مساعدك الدراسي. اسألني أي شيء عن موادك، شرح، ملخصات، كود، أو نصائح مذاكرة.',
      ));
    }
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty || _isThinking) return;

    final userMsg = ChatMessage(role: 'user', content: text.trim());
    setState(() {
      _messages.add(userMsg);
      _isThinking = true;
    });
    await HiveService.chatBox.put(userMsg.id, userMsg);
    _controller.clear();
    _scrollToBottom();

    final history = _messages
        .where((m) => m.role == 'user' || m.role == 'assistant')
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();

    final isAr = context.read<AppProvider>().isArabic;
    final reply = await AIService.chat(
      messages: history,
      systemPrompt: isAr
          ? 'أنت مساعد مذاكرة لطالب علوم حاسب. أجب بالعربية الفصحى المبسطة، وكن واضحًا ومفيدًا. إذا كان هناك كود ضعه داخل ```.'
          : 'You are a study assistant for a CS student. Be clear and helpful. Put code inside ``` blocks.',
    );

    final botMsg = ChatMessage(role: 'assistant', content: reply);
    setState(() {
      _messages.add(botMsg);
      _isThinking = false;
    });
    await HiveService.chatBox.put(botMsg.id, botMsg);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.watch<AppProvider>().isArabic;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios_new, size: 20)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.school_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'study',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'AI Chat',
                        style: TextStyle(fontSize: 12, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: _messages.length + (_isThinking ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isThinking && index == _messages.length) {
                    return const _ThinkingBubble();
                  }
                  final msg = _messages[index];
                  return _MessageBubble(message: msg);
                },
              ),
            ),

            // Suggested prompts
            if (!_isThinking)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isAr ? 'اقتراحات' : 'Suggested prompts',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _promptGroupIndex = (_promptGroupIndex + 1) % _promptGroups.length;
                            });
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: Text(isAr ? 'تحديث' : 'Refresh'),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _promptGroups[_promptGroupIndex].map((p) {
                        return ActionChip(
                          label: Text(p, style: const TextStyle(fontSize: 12)),
                          onPressed: () => _send(p),
                          backgroundColor: AppColors.primarySoft,
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            // Input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _send,
                      decoration: InputDecoration(
                        hintText: isAr ? 'اكتب سؤالك...' : 'Type your question...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: AppColors.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _send(_controller.text),
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.send_rounded, color: Colors.white, size: 22),
                      ),
                    ),
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

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.content.contains('```'))
              _CodeBlock(content: message.content, isUser: isUser)
            else
              Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : AppColors.textPrimaryLight,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.white70 : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String content;
  final bool isUser;

  const _CodeBlock({required this.content, required this.isUser});

  @override
  Widget build(BuildContext context) {
    // Simple extraction
    final parts = content.split('```');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < parts.length; i++)
          if (i.isOdd)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Code', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: parts[i].trim()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم النسخ'), duration: Duration(seconds: 1)),
                          );
                        },
                        child: const Icon(Icons.copy, size: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    parts[i].trim(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else if (parts[i].trim().isNotEmpty)
            Text(
              parts[i].trim(),
              style: TextStyle(
                color: isUser ? Colors.white : AppColors.textPrimaryLight,
                fontSize: 14,
              ),
            ),
      ],
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            const Text('جاري التفكير...', style: TextStyle(color: AppColors.textSecondaryLight)),
          ],
        ),
      ),
    );
  }
}
