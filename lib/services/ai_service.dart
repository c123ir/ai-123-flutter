import '../models/ai_chat.dart';

class AiService {
  static final List<AiChat> _chats = [];

  static Future<String> sendMessage(int userId, String message) async {
    // شبیه‌سازی پردازش AI
    await Future.delayed(const Duration(milliseconds: 1500));

    String response;

    // پاسخ‌های ساده بر اساس کلمات کلیدی
    if (message.contains('سلام') || message.contains('درود')) {
      response = 'سلام! چطور می‌تونم کمکتون کنم؟';
    } else if (message.contains('قیمت') || message.contains('هزینه')) {
      response =
          'برای اطلاع از قیمت محصولات، لطفاً نام محصول مورد نظرتون رو بگید.';
    } else if (message.contains('خرید') || message.contains('سفارش')) {
      response =
          'برای ثبت سفارش، می‌تونید از بخش محصولات اقدام کنید. نیاز به راهنمایی دارید؟';
    } else if (message.contains('مشاوره')) {
      response =
          'خوشحال می‌شم راهنماییتون کنم. در چه زمینه‌ای نیاز به مشاوره دارید؟';
    } else if (message.contains('تشکر') || message.contains('ممنون')) {
      response = 'خواهش می‌کنم! همیشه در خدمتتون هستم.';
    } else {
      response =
          'متشکرم از پیامتون. سوال شما ثبت شد و کارشناسان ما در اسرع وقت پاسخ خواهند داد.';
    }

    // ذخیره چت
    final chat = AiChat(
      id: _chats.length + 1,
      userId: userId,
      message: message,
      response: response,
      chatType: 'general',
      createdAt: DateTime.now(),
    );

    _chats.add(chat);

    return response;
  }

  static Future<List<AiChat>> getUserChats(int userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _chats.where((chat) => chat.userId == userId).toList();
  }

  static Future<String> getProductRecommendation(String userQuery) async {
    await Future.delayed(const Duration(milliseconds: 2000));

    // توصیه‌های ساده بر اساس کلمات کلیدی
    if (userQuery.contains('گوشی') || userQuery.contains('موبایل')) {
      return 'بر اساس نیازتون، گوشی سامسونگ Galaxy رو پیشنهاد می‌کنم. کیفیت عالی و قیمت مناسب داره.';
    } else if (userQuery.contains('لپ‌تاپ') || userQuery.contains('کامپیوتر')) {
      return 'برای کار اداری، لپ‌تاپ ایسوس مناسبه. برای بازی هم عملکرد خوبی داره.';
    } else if (userQuery.contains('پوشاک') || userQuery.contains('لباس')) {
      return 'پیراهن‌های جدید رسیده که کیفیت خوبی دارن. طراحی مدرن و قیمت مناسب.';
    } else {
      return 'لطفاً بیشتر توضیح بدید تا بهتر بتونم کمکتون کنم. چه نوع محصولی دنبال می‌گردید؟';
    }
  }

  static Future<void> clearUserChats(int userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _chats.removeWhere((chat) => chat.userId == userId);
  }

  static Future<List<AiChat>> getAllChats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _chats;
  }
}
