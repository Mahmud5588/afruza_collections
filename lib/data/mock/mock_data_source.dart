import "../../domain/entities/category.dart";
import "../../domain/entities/order.dart";
import "../../domain/entities/product.dart";
import "../../domain/entities/user.dart";

/// Mock data source - Backend tayyor bo'lgunicha ishlatish uchun
class MockDataSource {
  // Mock kategoriyalar
  static final List<Category> categories = [
    const Category(id: 1, name: "Ko'ylaklar", icon: "dress"),
    const Category(id: 2, name: "Shim va Jinsi", icon: "casual"),
    const Category(id: 3, name: "Kurtka va Palto", icon: "formal"),
    const Category(id: 4, name: "Futbolka va Sviter", icon: "casual"),
    const Category(id: 5, name: "Aksessuarlar", icon: "accessories"),
    const Category(id: 6, name: "Oyoq Kiyim", icon: "shoes"),
    const Category(id: 7, name: "Sumka va Ryukzak", icon: "bag"),
    const Category(id: 8, name: "Sport Kiyim", icon: "sport"),
  ];

  // Mock mahsulotlar
  static final List<Product> products = [
    const Product(
      id: 1,
      name: "Klassik Ko'ylak",
      description:
          "Yuqori sifatli paxta materialidan tikilgan klassik ko'ylak. Ofis va rasmiy tadbirlar uchun ideal.",
      price: 150000,
      rating: 4.5,
      categoryName: "Ko'ylaklar",
      categoryId: 1,
      imageUrls: [
        "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500",
        "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500",
      ],
      variants: [
        ProductVariant(id: 1, name: "S", price: 150000),
        ProductVariant(id: 2, name: "M", price: 150000),
        ProductVariant(id: 3, name: "L", price: 155000),
        ProductVariant(id: 4, name: "XL", price: 160000),
      ],
      viewsCount: 256,
      soldCount: 42,
    ),
    const Product(
      id: 2,
      name: "Jinsi Shim",
      description:
          "Zamonaviy uslubdagi jinsi shim. Yumshoq va bardoshli material.",
      price: 250000,
      rating: 4.8,
      categoryName: "Shim va Jinsi",
      categoryId: 2,
      imageUrls: [
        "https://images.unsplash.com/photo-1542272604-787c3835535d?w=500",
        "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=500",
      ],
      variants: [
        ProductVariant(id: 5, name: "28", price: 250000),
        ProductVariant(id: 6, name: "30", price: 250000),
        ProductVariant(id: 7, name: "32", price: 255000),
        ProductVariant(id: 8, name: "34", price: 260000),
      ],
      viewsCount: 489,
      soldCount: 156,
    ),
    const Product(
      id: 3,
      name: "Qishki Kurtka",
      description: "Issiq va qulay qishki kurtka. Suv o'tkazmaydigan material.",
      price: 450000,
      rating: 4.9,
      categoryName: "Kurtka va Palto",
      categoryId: 3,
      imageUrls: [
        "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500",
        "https://images.unsplash.com/photo-1610045910749-c10e2a1d0b06?w=500",
      ],
      variants: [
        ProductVariant(id: 9, name: "M", price: 450000),
        ProductVariant(id: 10, name: "L", price: 460000),
        ProductVariant(id: 11, name: "XL", price: 470000),
      ],
      viewsCount: 512,
      soldCount: 98,
    ),
    const Product(
      id: 4,
      name: "Sport Futbolka",
      description:
          "Nafas oladigan materialdan tikilgan sport futbolka. Mashqlar uchun juda qulay.",
      price: 80000,
      rating: 4.3,
      categoryName: "Sport Kiyim",
      categoryId: 8,
      imageUrls: [
        "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500",
      ],
      variants: [
        ProductVariant(id: 12, name: "S", price: 80000),
        ProductVariant(id: 13, name: "M", price: 80000),
        ProductVariant(id: 14, name: "L", price: 85000),
      ],
      viewsCount: 128,
      soldCount: 67,
    ),
    const Product(
      id: 5,
      name: "Zamonaviy Sviter",
      description:
          "Zamonaviy dizayndagi yumshoq sviter. Kundalik kiyish uchun.",
      price: 180000,
      rating: 4.6,
      categoryName: "Futbolka va Sviter",
      categoryId: 4,
      imageUrls: [
        "https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=500",
      ],
      variants: [
        ProductVariant(id: 15, name: "M", price: 180000),
        ProductVariant(id: 16, name: "L", price: 185000),
      ],
      viewsCount: 234,
      soldCount: 51,
    ),
    const Product(
      id: 6,
      name: "Charm Sumka",
      description: "Sifatli charmdан tikilgan klassik sumka.",
      price: 350000,
      rating: 4.7,
      categoryName: "Sumka va Ryukzak",
      categoryId: 7,
      imageUrls: [
        "https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=500",
      ],
      variants: [
        ProductVariant(id: 17, name: "Qora", price: 350000),
        ProductVariant(id: 18, name: "Jigarrang", price: 360000),
      ],
      viewsCount: 156,
      soldCount: 34,
    ),
    const Product(
      id: 7,
      name: "Krossovka",
      description: "Qulay va zamonaviy sport oyoq kiyim.",
      price: 320000,
      rating: 4.8,
      categoryName: "Oyoq Kiyim",
      categoryId: 6,
      imageUrls: [
        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500",
      ],
      variants: [
        ProductVariant(id: 19, name: "40", price: 320000),
        ProductVariant(id: 20, name: "41", price: 320000),
        ProductVariant(id: 21, name: "42", price: 325000),
        ProductVariant(id: 22, name: "43", price: 330000),
      ],
      viewsCount: 367,
      soldCount: 123,
    ),
    const Product(
      id: 8,
      name: "Soat",
      description: "Klassik uslubdagi qo'l soati. Suv o'tkazmaydigan.",
      price: 420000,
      rating: 4.9,
      categoryName: "Aksessuarlar",
      categoryId: 5,
      imageUrls: [
        "https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=500",
      ],
      variants: [
        ProductVariant(id: 23, name: "Kumush", price: 420000),
        ProductVariant(id: 24, name: "Oltin", price: 520000),
      ],
      viewsCount: 445,
      soldCount: 189,
    ),
  ];

  // Mock buyurtmalar
  static final List<Order> orders = [
    Order(
      id: 1,
      status: "pending",
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      total: 150000,
      items: const [
        OrderItem(
            productName: "Klassik Ko'ylak", quantity: 1, unitPrice: 150000),
      ],
    ),
    Order(
      id: 2,
      status: "completed",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      total: 500000,
      items: const [
        OrderItem(productName: "Jinsi Shim", quantity: 1, unitPrice: 250000),
        OrderItem(productName: "Jinsi Shim", quantity: 1, unitPrice: 250000),
      ],
    ),
    Order(
      id: 3,
      status: "shipped",
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      total: 800000,
      items: const [
        OrderItem(productName: "Qishki Kurtka", quantity: 1, unitPrice: 450000),
        OrderItem(productName: "Charm Sumka", quantity: 1, unitPrice: 350000),
      ],
    ),
    Order(
      id: 4,
      status: "pending",
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      total: 260000,
      items: const [
        OrderItem(productName: "Sport Futbolka", quantity: 1, unitPrice: 80000),
        OrderItem(
            productName: "Zamonaviy Sviter", quantity: 1, unitPrice: 180000),
      ],
    ),
  ];

  // Mock foydalanuvchilar
  static final List<UserAccount> users = [
    const UserAccount(
      id: 1,
      email: "admin@afruza.com",
      isAdmin: true,
      isActive: true,
    ),
    const UserAccount(
      id: 2,
      email: "user1@example.com",
      isAdmin: false,
      isActive: true,
    ),
    const UserAccount(
      id: 3,
      email: "user2@example.com",
      isAdmin: false,
      isActive: true,
    ),
    const UserAccount(
      id: 4,
      email: "user3@example.com",
      isAdmin: false,
      isActive: false,
    ),
  ];

  // Yozilgan mahsulotlar ID'lari (sessionga bog'liq bo'lishi kerak, lekin mock uchun static)
  static final List<int> _favoritesIds = [1, 3, 5];

  static bool isProductFavorite(int productId) {
    return _favoritesIds.contains(productId);
  }

  static void toggleFavorite(int productId) {
    if (_favoritesIds.contains(productId)) {
      _favoritesIds.remove(productId);
    } else {
      _favoritesIds.add(productId);
    }
  }
}
