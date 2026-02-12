import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_localizations/flutter_localizations.dart"
    show
        GlobalMaterialLocalizations,
        GlobalWidgetsLocalizations,
        GlobalCupertinoLocalizations;

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale("uz"),
    Locale("ru"),
    Locale("en"),
  ];

  static final localizationsDelegates = [
    const _AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _values = {
    "app_title": {
      "uz": "Afruza Collection",
      "ru": "Afruza Collection",
      "en": "Afruza Collection",
    },
    "login_title": {
      "uz": "Xush kelibsiz",
      "ru": "С возвращением",
      "en": "Welcome back",
    },
    "login_subtitle": {
      "uz": "Davom etish uchun tizimga kiring.",
      "ru": "Войдите, чтобы продолжить покупки.",
      "en": "Sign in to continue shopping.",
    },
    "signup_title": {
      "uz": "Ro'yxatdan o'tish",
      "ru": "Регистрация",
      "en": "Create an account",
    },
    "signup_subtitle": {
      "uz": "Hisob yarating va xaridni boshlang.",
      "ru": "Создайте аккаунт и начните покупки.",
      "en": "Create an account to start shopping.",
    },
    "email": {
      "uz": "Email",
      "ru": "Эл. почта",
      "en": "Email",
    },
    "password": {
      "uz": "Parol",
      "ru": "Пароль",
      "en": "Password",
    },
    "name": {
      "uz": "Ism",
      "ru": "Имя",
      "en": "Name",
    },
    "login": {
      "uz": "Kirish",
      "ru": "Войти",
      "en": "Sign in",
    },
    "login_failed": {
      "uz": "Kirish amalga oshmadi",
      "ru": "Не удалось войти",
      "en": "Sign-in failed",
    },
    "register_failed": {
      "uz": "Ro'yxatdan o'tish amalga oshmadi",
      "ru": "Не удалось зарегистрироваться",
      "en": "Registration failed",
    },
    "account_created": {
      "uz": "Hisob yaratildi",
      "ru": "Аккаунт создан",
      "en": "Account created",
    },
    "enter_email_password": {
      "uz": "Email va parolni kiriting",
      "ru": "Введите эл. почту и пароль",
      "en": "Enter your email and password",
    },
    "enter_name_email_password": {
      "uz": "Ism, email va parolni kiriting",
      "ru": "Введите имя, эл. почту и пароль",
      "en": "Enter your name, email, and password",
    },
    "invalid_email": {
      "uz": "Email noto'g'ri",
      "ru": "Некорректный адрес эл. почты",
      "en": "Invalid email address",
    },
    "password_too_short": {
      "uz": "Parol kamida 6 ta belgi bo'lsin",
      "ru": "Пароль должен быть не менее 6 символов",
      "en": "Password must be at least 6 characters",
    },
    "create_account": {
      "uz": "Hisob yaratish",
      "ru": "Создать аккаунт",
      "en": "Create account",
    },
    "account": {
      "uz": "Hisob",
      "ru": "Аккаунт",
      "en": "Account",
    },
    "signup_link": {
      "uz": "Yangi hisob yaratish",
      "ru": "Создать аккаунт",
      "en": "Create an account",
    },
    "back_to_login": {
      "uz": "Kirishga qaytish",
      "ru": "Назад ко входу",
      "en": "Back to sign in",
    },
    "no_product_selected": {
      "uz": "Mahsulot tanlanmagan",
      "ru": "Товар не выбран",
      "en": "No product selected",
    },
    "home": {
      "uz": "Bosh sahifa",
      "ru": "Главная",
      "en": "Home",
    },
    "no_orders": {
      "uz": "Buyurtmalar yo'q",
      "ru": "Пока нет заказов",
      "en": "No orders yet",
    },
    "no_orders_subtitle": {
      "uz": "Buyurtmalar tarixi shu yerda ko'rinadi.",
      "ru": "Здесь появится история ваших заказов.",
      "en": "Your order history will appear here.",
    },
    "search": {
      "uz": "Qidiruv",
      "ru": "Поиск",
      "en": "Search",
    },
    "orders": {
      "uz": "Buyurtmalar",
      "ru": "Заказы",
      "en": "Orders",
    },
    "publish_drop": {
      "uz": "Yangi mahsulot chiqarish",
      "ru": "Опубликовать новинку",
      "en": "Publish a new drop",
    },
    "organize_collection": {
      "uz": "Kolleksiyani tartiblang",
      "ru": "Упорядочить коллекцию",
      "en": "Organize the collection",
    },
    "roles_access": {
      "uz": "Rollar va ruxsatlar",
      "ru": "Роли и доступ",
      "en": "Roles and access",
    },
    "profile": {
      "uz": "Profil",
      "ru": "Профиль",
      "en": "Profile",
    },
    "favorites": {
      "uz": "Saqlanganlar",
      "ru": "Избранное",
      "en": "Favorites",
    },
    "admin_panel": {
      "uz": "Admin panel",
      "ru": "Админ-панель",
      "en": "Admin panel",
    },
    "admin_panel_title": {
      "uz": "Admin panel",
      "ru": "Админ-панель",
      "en": "Admin panel",
    },
    "overview": {
      "uz": "Umumiy",
      "ru": "Обзор",
      "en": "Overview",
    },
    "add_product": {
      "uz": "Mahsulot qo'shish",
      "ru": "Добавить товар",
      "en": "Add product",
    },
    "manage_categories": {
      "uz": "Kategoriyalar",
      "ru": "Категории",
      "en": "Categories",
    },
    "user_management": {
      "uz": "Foydalanuvchilar",
      "ru": "Пользователи",
      "en": "Users",
    },
    "language": {
      "uz": "Til",
      "ru": "Язык",
      "en": "Language",
    },
    "brand_tagline": {
      "uz": "Minimal uslub, har kuni tanlangan",
      "ru": "Минимализм и стиль — на каждый день",
      "en": "Minimal style, curated daily",
    },
    "search_hint": {
      "uz": "Nom yoki uslub bo'yicha qidiring",
      "ru": "Ищите по названию, стилю или цвету",
      "en": "Search by name, style, or color",
    },
    "categories": {
      "uz": "Kategoriyalar",
      "ru": "Категории",
      "en": "Categories",
    },
    "all": {
      "uz": "Barchasi",
      "ru": "Все",
      "en": "All",
    },
    "newest_drops": {
      "uz": "Yangi kolleksiya",
      "ru": "Новые поступления",
      "en": "New arrivals",
    },
    "see_all": {
      "uz": "Hammasi",
      "ru": "Смотреть все",
      "en": "See all",
    },
    "most_viewed": {
      "uz": "Eng ko'p ko'rilgan",
      "ru": "Самые просматриваемые",
      "en": "Most viewed",
    },
    "most_sold": {
      "uz": "Eng ko'p sotilgan",
      "ru": "Самые продаваемые",
      "en": "Best sellers",
    },
    "failed_to_load": {
      "uz": "Yuklashda xatolik",
      "ru": "Не удалось загрузить",
      "en": "Failed to load",
    },
    "please_try_again": {
      "uz": "Qayta urinib ko'ring.",
      "ru": "Попробуйте ещё раз.",
      "en": "Please try again.",
    },
    "retry": {
      "uz": "Qayta",
      "ru": "Повторить",
      "en": "Retry",
    },
    "refresh": {
      "uz": "Yangilash",
      "ru": "Обновить",
      "en": "Refresh",
    },
    "no_products": {
      "uz": "Mahsulotlar yo'q",
      "ru": "Пока нет товаров",
      "en": "No products yet",
    },
    "no_products_subtitle": {
      "uz": "Katalog ulanganidan so'ng mahsulotlar chiqadi.",
      "ru": "Лента появится после подключения каталога.",
      "en": "Your boutique feed will appear once the catalog is connected.",
    },
    "results": {
      "uz": "Natijalar",
      "ru": "Результаты",
      "en": "Results",
    },
    "search_failed": {
      "uz": "Qidiruvda xatolik",
      "ru": "Ошибка поиска",
      "en": "Search failed",
    },
    "no_results": {
      "uz": "Natija yo'q",
      "ru": "Ничего не найдено",
      "en": "No results found",
    },
    "try_different": {
      "uz": "Boshqa so'z bilan urinib ko'ring.",
      "ru": "Попробуйте другой запрос.",
      "en": "Try a different keyword.",
    },
    "order_history": {
      "uz": "Buyurtmalar tarixi",
      "ru": "История заказов",
      "en": "Order history",
    },
    "login_required": {
      "uz": "Kirish talab qilinadi",
      "ru": "Требуется вход",
      "en": "Sign-in required",
    },
    "sign_in_to_view_orders": {
      "uz": "Buyurtmalarni ko'rish uchun kiring.",
      "ru": "Войдите, чтобы посмотреть заказы.",
      "en": "Sign in to view your orders.",
    },
    "sign_in": {
      "uz": "Kirish",
      "ru": "Войти",
      "en": "Sign in",
    },
    "order_now": {
      "uz": "Buyurtma berish",
      "ru": "Оформить заказ",
      "en": "Order now",
    },
    "price": {
      "uz": "Narx",
      "ru": "Цена",
      "en": "Price",
    },
    "order_placed": {
      "uz": "Buyurtma qabul qilindi",
      "ru": "Заказ оформлен",
      "en": "Order placed",
    },
    "order_confirm_title": {
      "uz": "Buyurtmani tasdiqlang",
      "ru": "Подтвердите заказ",
      "en": "Confirm your order",
    },
    "delivery_notice_15_days": {
      "uz": "Mahsulot 15 kungacha yetkazib beriladi.",
      "ru": "Доставка может занять до 15 дней.",
      "en": "Delivery may take up to 15 days.",
    },
    "confirm_order": {
      "uz": "Tasdiqlash",
      "ru": "Подтвердить",
      "en": "Confirm",
    },
    "order_failed": {
      "uz": "Buyurtma amalga oshmadi",
      "ru": "Не удалось оформить заказ",
      "en": "Order failed",
    },
    "order_success": {
      "uz": "Buyurtmangiz muvaffaqiyatli qabul qilindi.",
      "ru": "Ваш заказ успешно оформлен.",
      "en": "Your order was placed successfully.",
    },
    "close": {
      "uz": "Yopish",
      "ru": "Закрыть",
      "en": "Close",
    },
    "chat": {
      "uz": "Chat",
      "ru": "Чат",
      "en": "Chat",
    },
    "chat_input": {
      "uz": "Xabar yozing",
      "ru": "Напишите сообщение",
      "en": "Type a message",
    },
    "chat_failed": {
      "uz": "Chat ulanmadi.",
      "ru": "Не удалось подключить чат.",
      "en": "Couldn’t connect to chat.",
    },
    "location_denied": {
      "uz": "Lokatsiya ruxsati berilmadi.",
      "ru": "Доступ к геолокации отклонён.",
      "en": "Location permission denied.",
    },
    "location_disabled": {
      "uz": "Lokatsiya xizmati o'chirilgan.",
      "ru": "Службы геолокации отключены.",
      "en": "Location services are disabled.",
    },
    "location_shared": {
      "uz": "Lokatsiya yuborildi",
      "ru": "Геолокация отправлена",
      "en": "Location shared",
    },
    "favorites_empty": {
      "uz": "Saqlanganlar yo'q",
      "ru": "Пока нет избранного",
      "en": "No favorites yet",
    },
    "favorites_empty_subtitle": {
      "uz": "Yurak belgisi bilan saqlang.",
      "ru": "Нажмите на значок сердца, чтобы сохранить товары.",
      "en": "Tap the heart icon to save items.",
    },
    "account_subtitle": {
      "uz": "Profil va kontaktlar",
      "ru": "Профиль и контакты",
      "en": "Preferences and contact details",
    },
    "orders_subtitle": {
      "uz": "So'nggi xaridlar",
      "ru": "Ваши последние покупки",
      "en": "Track your recent purchases",
    },
    "chat_subtitle": {
      "uz": "Yordam yoki lokatsiya",
      "ru": "Поддержка или геолокация",
      "en": "Get support or share your location",
    },
    "favorites_subtitle": {
      "uz": "Saqlangan mahsulotlar",
      "ru": "Сохранённые товары",
      "en": "Saved items and wish list",
    },
    "language_subtitle": {
      "uz": "O'zbek / Rus / Ingliz",
      "ru": "Узбекский / Русский / Английский",
      "en": "Uzbek / Russian / English",
    },
    "admin_panel_subtitle": {
      "uz": "Katalog va foydalanuvchilar",
      "ru": "Каталог и пользователи",
      "en": "Manage catalog and users",
    },
    "access_denied": {
      "uz": "Kirish taqiqlangan",
      "ru": "Доступ запрещён",
      "en": "Access denied",
    },
    "admin_only": {
      "uz": "Faqat admin uchun",
      "ru": "Только для администратора",
      "en": "Admins only",
    },
    "go_back": {
      "uz": "Orqaga",
      "ru": "Назад",
      "en": "Go back",
    },
    "logout": {
      "uz": "Chiqish",
      "ru": "Выйти",
      "en": "Sign out",
    },
    "logout_subtitle": {
      "uz": "Hisobdan chiqish",
      "ru": "Выйти из аккаунта",
      "en": "Sign out of your account",
    },
    "confirm_logout": {
      "uz": "Chiqishni tasdiqlang",
      "ru": "Подтверждение выхода",
      "en": "Confirm sign out",
    },
    "logout_message": {
      "uz": "Rostdan ham hisobdan chiqmoqchisiz?",
      "ru": "Вы действительно хотите выйти?",
      "en": "Are you sure you want to sign out?",
    },
    "login_required_message": {
      "uz": "Ushbu funksiyani ishlatish uchun avval tizimga kiring.",
      "ru": "Для использования этой функции необходимо войти.",
      "en": "You need to sign in to access this feature.",
    },
    "cancel": {
      "uz": "Bekor qilish",
      "ru": "Отмена",
      "en": "Cancel",
    },
    "products": {
      "uz": "Mahsulotlar",
      "ru": "Товары",
      "en": "Products",
    },
    "categories_count": {
      "uz": "Kategoriyalar",
      "ru": "Категории",
      "en": "Categories",
    },
    "users": {
      "uz": "Foydalanuvchilar",
      "ru": "Пользователи",
      "en": "Users",
    },
    "quick_actions": {
      "uz": "Tezkor amallar",
      "ru": "Быстрые действия",
      "en": "Quick actions",
    },
    "management": {
      "uz": "Boshqaruv",
      "ru": "Управление",
      "en": "Management",
    },
    "manage_products": {
      "uz": "Mahsulotlarni boshqarish",
      "ru": "Управление товарами",
      "en": "Manage products",
    },
    "manage_users": {
      "uz": "Foydalanuvchilar",
      "ru": "Пользователи",
      "en": "Manage users",
    },
    "send_image": {
      "uz": "Rasm yuborish",
      "ru": "Отправить фото",
      "en": "Send image",
    },
    "send_video": {
      "uz": "Video yuborish",
      "ru": "Отправить видео",
      "en": "Send video",
    },
    "send_audio": {
      "uz": "Audio yuborish",
      "ru": "Отправить аудио",
      "en": "Send audio",
    },
    "send_location": {
      "uz": "Joylashuvni yuborish",
      "ru": "Отправить локацию",
      "en": "Send location",
    },
    "image_sent": {
      "uz": "Rasm yuborildi",
      "ru": "Фото отправлено",
      "en": "Image sent",
    },
    "video_sent": {
      "uz": "Video yuborildi",
      "ru": "Видео отправлено",
      "en": "Video sent",
    },
    "audio_sent": {
      "uz": "Audio yuborildi",
      "ru": "Аудио отправлено",
      "en": "Audio sent",
    },
    "chat_list_title": {
      "uz": "Chatlar",
      "ru": "Чаты",
      "en": "Chats",
    },
    "no_chats": {
      "uz": "Chatlar yo'q",
      "ru": "Нет чатов",
      "en": "No chats",
    },
  };

  String t(String key) {
    final map = _values[key];
    if (map == null) return key;
    return map[locale.languageCode] ?? map["en"] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
