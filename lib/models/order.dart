import '../models/cart.dart';

class Order {
  final String id;
  final String customerName;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.customerName,
    required this.items,
    required this.totalAmount,
    required this.dateTime,
  });


  // Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  // Get formatted time
  String get formattedTime {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  // Get full date string
  String get fullDateString {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }
}

class OrderHistory {
  final List<Order> orders = [];

  void addOrder(Order order) {
    orders.insert(0, order); // Add to beginning (most recent first)
  }

  List<Order> get todayOrders {
    final now = DateTime.now();
    return orders.where((o) => 
      o.dateTime.year == now.year && 
      o.dateTime.month == now.month && 
      o.dateTime.day == now.day
    ).toList();
  }

  List<Order> get thisWeekOrders {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return orders.where((o) => o.dateTime.isAfter(weekAgo)).toList();
  }

  List<Order> get thisMonthOrders {
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));
    return orders.where((o) => o.dateTime.isAfter(monthAgo)).toList();
  }
}
