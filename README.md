# study

تطبيق مذاكرة شخصي أوفلاين بالكامل لطلاب علوم الحاسب.

**Package:** `com.mohamed5946.newstudy`  
**Platform:** Android only  
**Stack:** Flutter + Dart + Hive + Groq

## قواعد مهمة
- لا حسابات ولا سيرفر
- لا إعلانات ولا Premium
- لا كلمة "حصص" — فقط محاضرة / سيكشن / مادة
- الألوان: أزرق ولادي فاتح فقط
- الاسم الافتراضي: محمد / Mohamed
- مفتاح Groq يُمرر وقت البناء فقط

## التشغيل

```bash
flutter pub get

# تشغيل مع مفتاح Groq
flutter run --dart-define=GROQ_API_KEY=your_key_here

# بناء APK Universal
flutter build apk --release --dart-define=GROQ_API_KEY=your_key_here
```

## هيكل المشروع

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   ├── models/          # Hive models + adapters
│   ├── repositories/
│   └── services/        # HiveService, AIService
├── presentation/
│   ├── providers/
│   ├── screens/
│   │   ├── home/
│   │   ├── timetable/
│   │   ├── ai_chat/
│   │   ├── study/
│   │   ├── pomodoro/
│   │   ├── settings/
│   │   ├── more/
│   │   └── shell/
│   └── widgets/         # GlassCard, GlassBottomNav
└── main.dart
```

## الميزات المنفذة
- [x] الرئيسية + كارت المحاضرة القادمة + Timeline
- [x] الجدول الأسبوعي (إضافة / حذف بـ Yes-No)
- [x] شات AI حقيقي مع Groq + Suggested Prompts + نسخ كود
- [x] مكتبة PDF (رفع / حذف)
- [x] بومودورو كامل (Focus / Short / Long + عدّاد 4)
- [x] الإعدادات (لغة / ثيم / مدد / اختبار AI / مسح بيانات)
- [x] شاشة المزيد (روابط لكل الأقسام)
- [x] تخزين محلي Hive
- [x] شريط سفلي زجاجي موحّد

## ما يحتاج تكملة لاحقًا
- عارض PDF كامل (Syncfusion) + شريط صفحات
- OCR حقيقي (Tesseract / ML Kit)
- خرائط ذهنية تفاعلية
- إشعارات محلية قبل المحاضرات
- شاشات المواد / المهام / الفلاش كاردز / GPA بتفاصيل أعمق
- اختبارات Widget + اختبار منع كلمة "حصص"

## البناء من GitHub
ارفع المشروع كامل على GitHub، ثم استخدم:
```bash
flutter build apk --release --dart-define=GROQ_API_KEY=sk-...
```
أو أضف الـ key في GitHub Secrets لو هتبني بـ CI.
