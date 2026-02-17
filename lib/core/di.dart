import "package:dio/dio.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../data/local/favorites_service.dart";
import "../data/local/chat_storage.dart";
import "../data/local/storage_service.dart";
import "../core/localization/locale_controller.dart";
import "../data/remote/dio_client.dart";
import "../data/repositories/auth_repository_impl.dart";
import "../data/repositories/category_repository_impl.dart";
import "../data/repositories/order_repository_impl.dart";
import "../data/repositories/product_repository_impl.dart";
import "../data/repositories/recommendation_repository_impl.dart";
import "../data/repositories/user_repository_impl.dart";
import "../data/repositories/comment_repository_impl.dart";
import "../data/repositories/chat_repository_impl.dart";
import "../data/repositories/notification_repository_impl.dart";
import "../data/repositories/rating_repository_impl.dart";
// Mock imports are commented - only real API is used
import "../domain/repositories/auth_repository.dart";
import "../domain/repositories/category_repository.dart";
import "../domain/repositories/order_repository.dart";
import "../domain/repositories/product_repository.dart";
import "../domain/repositories/recommendation_repository.dart";
import "../domain/repositories/user_repository.dart";
import "../domain/repositories/comment_repository.dart";
import "../domain/repositories/chat_repository.dart";
import "../domain/repositories/notification_repository.dart";
import "../domain/repositories/rating_repository.dart";
import "feature_availability_service.dart";
import "../domain/usecases/create_order.dart";
import "../domain/usecases/create_category.dart";
import "../domain/usecases/create_product.dart";
import "../domain/usecases/delete_category.dart";
import "../domain/usecases/delete_product.dart";
import "../domain/usecases/get_categories.dart";
import "../domain/usecases/get_most_sold.dart";
import "../domain/usecases/get_most_viewed.dart";
import "../domain/usecases/get_orders.dart";
import "../domain/usecases/get_products.dart";
import "../domain/usecases/get_users.dart";
import "../domain/usecases/login_user.dart";
import "../domain/usecases/logout_user.dart";
import "../domain/usecases/register_user.dart";
import "../domain/usecases/update_category.dart";
import "../domain/usecases/update_product.dart";
import "../domain/usecases/update_profile.dart";
import "../domain/usecases/update_user.dart";
import "../domain/usecases/delete_user.dart";
import "../domain/usecases/get_chat_with_user.dart";
import "../domain/usecases/send_message.dart";
import "../domain/usecases/get_my_notifications.dart";
import "../domain/usecases/mark_notification_as_read.dart";
import "../domain/usecases/get_rating_stats.dart";
import "../domain/usecases/get_my_rating.dart";
import "../domain/usecases/upsert_rating.dart";
import "../domain/usecases/delete_rating.dart";
import "../domain/usecases/create_category_with_icon.dart";
import "../domain/usecases/create_product_with_image.dart";
import "../domain/usecases/update_order_status.dart";
import "../presentation/blocs/product/product_bloc.dart";
import "../presentation/blocs/auth/auth_bloc.dart";
import "../presentation/blocs/category/category_bloc.dart";
import "../presentation/blocs/order/order_bloc.dart";
import "../presentation/blocs/auth/admin/admin_category_bloc.dart";
import "../presentation/blocs/auth/admin/admin_product_bloc.dart";
import "../presentation/blocs/auth/admin/admin_user_bloc.dart";
import "../presentation/blocs/recommendation/recommendation_bloc.dart";

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
  sl.registerLazySingleton<StorageService>(
      () => StorageService(prefs, secureStorage));
  sl.registerLazySingleton<FavoritesService>(() => FavoritesService(prefs));
  sl.registerLazySingleton<ChatStorage>(() => ChatStorage(prefs));
  sl.registerLazySingleton<LocaleController>(() => LocaleController());

  sl.registerLazySingleton<Dio>(() => buildDioClient(sl()));
  sl.registerLazySingleton<FeatureAvailabilityService>(
      () => FeatureAvailabilityService(sl()));

  // Repository'lar - Real API ishlatilyapti (mock o'chirildi)
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton<RecommendationRepository>(
      () => RecommendationRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<CommentRepository>(
      () => CommentRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl()));
  sl.registerLazySingleton<RatingRepository>(() => RatingRepositoryImpl(sl()));
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl()));
  sl.registerLazySingleton<LogoutUser>(() => LogoutUser(sl()));
  sl.registerLazySingleton<RegisterUser>(() => RegisterUser(sl()));
  sl.registerLazySingleton<CreateCategory>(() => CreateCategory(sl()));
  sl.registerLazySingleton<CreateCategoryWithIcon>(
      () => CreateCategoryWithIcon(sl()));
  sl.registerLazySingleton<DeleteCategory>(() => DeleteCategory(sl()));
  sl.registerLazySingleton<CreateProduct>(() => CreateProduct(sl()));
  sl.registerLazySingleton<CreateProductWithImage>(
      () => CreateProductWithImage(sl()));
  sl.registerLazySingleton<DeleteProduct>(() => DeleteProduct(sl()));
  sl.registerLazySingleton<UpdateCategory>(() => UpdateCategory(sl()));
  sl.registerLazySingleton<UpdateProduct>(() => UpdateProduct(sl()));
  sl.registerLazySingleton<GetCategories>(() => GetCategories(sl()));
  sl.registerLazySingleton<GetMostViewed>(() => GetMostViewed(sl()));
  sl.registerLazySingleton<GetMostSold>(() => GetMostSold(sl()));
  sl.registerLazySingleton<GetOrders>(() => GetOrders(sl()));
  sl.registerLazySingleton<GetProducts>(() => GetProducts(sl()));
  sl.registerLazySingleton<GetUsers>(() => GetUsers(sl()));
  sl.registerLazySingleton<UpdateUser>(() => UpdateUser(sl()));
  sl.registerLazySingleton<DeleteUser>(() => DeleteUser(sl()));
  sl.registerLazySingleton<UpdateProfile>(() => UpdateProfile(sl()));
  sl.registerLazySingleton<CreateOrder>(() => CreateOrder(sl()));
  sl.registerLazySingleton<UpdateOrderStatus>(() => UpdateOrderStatus(sl()));
  sl.registerLazySingleton<GetChatWithUser>(() => GetChatWithUser(sl()));
  sl.registerLazySingleton<SendMessage>(() => SendMessage(sl()));
  sl.registerLazySingleton<GetMyNotifications>(() => GetMyNotifications(sl()));
  sl.registerLazySingleton<MarkNotificationAsRead>(
      () => MarkNotificationAsRead(sl()));
  sl.registerLazySingleton<GetRatingStats>(() => GetRatingStats(sl()));
  sl.registerLazySingleton<GetMyRating>(() => GetMyRating(sl()));
  sl.registerLazySingleton<UpsertRating>(() => UpsertRating(sl()));
  sl.registerLazySingleton<DeleteRating>(() => DeleteRating(sl()));

  sl.registerFactory<AuthBloc>(() => AuthBloc(sl(), sl()));
  sl.registerFactory<AdminCategoryBloc>(
      () => AdminCategoryBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory<AdminProductBloc>(
      () => AdminProductBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<AdminUserBloc>(() => AdminUserBloc(sl(), sl(), sl()));
  sl.registerFactory<CategoryBloc>(() => CategoryBloc(sl()));
  sl.registerFactory<OrderBloc>(() => OrderBloc(sl()));
  sl.registerFactory<ProductBloc>(() => ProductBloc(sl()));
  sl.registerFactory<RecommendationBloc>(() => RecommendationBloc(sl(), sl()));
}
