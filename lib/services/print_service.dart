import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../models/order.dart';

/// Service for managing Bluetooth thermal printer connections and printing
class PrintService {
  static PrintService? _instance;
  static PrintService get instance => _instance ??= PrintService._();
  
  PrintService._();
  
  // Connected printer info
  BluetoothInfo? _connectedPrinter;
  bool _isConnected = false;
  
  // Stream controller for connection status
  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;
  
  bool get isConnected => _isConnected;
  String? get connectedPrinterName => _connectedPrinter?.name;
  
  /// Get list of paired Bluetooth devices
  Future<List<BluetoothInfo>> getPairedDevices() async {
    try {
      final bool result = await PrintBluetoothThermal.bluetoothEnabled;
      if (!result) {
        debugPrint('PrintService: Bluetooth is not enabled');
        return [];
      }
      
      final List<BluetoothInfo> devices = await PrintBluetoothThermal.pairedBluetooths;
      debugPrint('PrintService: Found ${devices.length} paired devices');
      return devices;
    } catch (e) {
      debugPrint('PrintService: Error getting paired devices: $e');
      return [];
    }
  }
  
  /// Connect to a Bluetooth printer
  Future<bool> connectToPrinter(BluetoothInfo printer) async {
    try {
      debugPrint('PrintService: Connecting to ${printer.name}...');
      
      // Disconnect if already connected
      if (_isConnected) {
        await disconnect();
      }
      
      final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: printer.macAdress);
      
      if (result) {
        _connectedPrinter = printer;
        _isConnected = true;
        _connectionController.add(true);
        debugPrint('PrintService: Connected to ${printer.name}');
        return true;
      } else {
        debugPrint('PrintService: Failed to connect to ${printer.name}');
        return false;
      }
    } catch (e) {
      debugPrint('PrintService: Error connecting to printer: $e');
      return false;
    }
  }
  
  /// Disconnect from the current printer
  Future<void> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
      _connectedPrinter = null;
      _isConnected = false;
      _connectionController.add(false);
      debugPrint('PrintService: Disconnected from printer');
    } catch (e) {
      debugPrint('PrintService: Error disconnecting: $e');
    }
  }
  
  /// Check if Bluetooth is enabled
  Future<bool> isBluetoothEnabled() async {
    try {
      return await PrintBluetoothThermal.bluetoothEnabled;
    } catch (e) {
      return false;
    }
  }
  
  /// Check if a printer is currently connected
  Future<bool> checkConnection() async {
    try {
      final bool result = await PrintBluetoothThermal.connectionStatus;
      _isConnected = result;
      _connectionController.add(result);
      return result;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }
  
  /// Print a receipt for the given order
  Future<bool> printReceipt(Order order) async {
    if (!_isConnected) {
      debugPrint('PrintService: Not connected to a printer');
      return false;
    }
    
    try {
      // Build ESC/POS commands for receipt
      List<int> bytes = [];
      
      // Initialize printer
      bytes += [0x1B, 0x40]; // ESC @ - Initialize
      
      // Center align
      bytes += [0x1B, 0x61, 0x01]; // ESC a 1 - Center
      
      // Store name (double height/width)
      bytes += [0x1B, 0x21, 0x30]; // ESC ! 0x30 - Double size
      bytes += 'Mr. Buenaz\n'.codeUnits;
      bytes += [0x1B, 0x21, 0x00]; // ESC ! 0x00 - Normal size
      
      // Address
      bytes += 'Brgy. Buenavista\n'.codeUnits;
      bytes += 'Magdalena, Laguna\n'.codeUnits;
      bytes += 'Tel: 0917-123-4567\n'.codeUnits;
      bytes += '\n'.codeUnits;
      
      // Dashed line
      bytes += '--------------------------------\n'.codeUnits;
      
      // Left align
      bytes += [0x1B, 0x61, 0x00]; // ESC a 0 - Left
      
      // Order info
      bytes += 'Order #${order.id.substring(order.id.length - 6)}\n'.codeUnits;
      bytes += '${order.fullDateString} ${order.formattedTime}\n'.codeUnits;
      bytes += '\n'.codeUnits;
      
      // Customer name (bold)
      bytes += [0x1B, 0x45, 0x01]; // ESC E 1 - Bold ON
      bytes += 'CUSTOMER: ${order.customerName.toUpperCase()}\n'.codeUnits;
      bytes += [0x1B, 0x45, 0x00]; // ESC E 0 - Bold OFF
      bytes += '\n'.codeUnits;
      
      // Dashed line
      bytes += '--------------------------------\n'.codeUnits;
      
      // Items
      for (var item in order.items) {
        final qty = item.quantity;
        final name = item.product.name;
        final price = (item.basePrice * qty).toStringAsFixed(2);
        final size = item.product.categoryId == '7' 
            ? (item.size == 'tall' ? 'Small' : 'Large')
            : (item.size == 'tall' ? '16oz' : '22oz');
        
        bytes += '${qty}x $name\n'.codeUnits;
        bytes += '   $size                 P$price\n'.codeUnits;
        
        // Add-ons
        for (var addOn in item.addOns) {
          final addOnPrice = (addOn.price * qty).toStringAsFixed(2);
          bytes += '   + ${addOn.name}           P$addOnPrice\n'.codeUnits;
        }
      }
      
      // Dashed line
      bytes += '--------------------------------\n'.codeUnits;
      
      // Total (bold, larger)
      bytes += [0x1B, 0x21, 0x10]; // Double height
      bytes += [0x1B, 0x45, 0x01]; // Bold
      final total = order.totalAmount.toStringAsFixed(2);
      bytes += 'TOTAL:              P$total\n'.codeUnits;
      bytes += [0x1B, 0x21, 0x00]; // Normal
      bytes += [0x1B, 0x45, 0x00]; // Bold off
      bytes += '\n'.codeUnits;
      
      // Dashed line
      bytes += '--------------------------------\n'.codeUnits;
      
      // Footer (center)
      bytes += [0x1B, 0x61, 0x01]; // Center
      bytes += '\n'.codeUnits;
      bytes += '~ drop by and have a taste! ~\n'.codeUnits;
      bytes += 'OPEN 2PM - 10PM\n'.codeUnits;
      bytes += '\n'.codeUnits;
      bytes += 'Follow us on Facebook!\n'.codeUnits;
      bytes += '@mr.buenaz.2025\n'.codeUnits;
      bytes += '\n'.codeUnits;
      bytes += 'Thank you for your order!\n'.codeUnits;
      bytes += '\n\n\n'.codeUnits;
      
      // Cut paper (if supported)
      bytes += [0x1D, 0x56, 0x00]; // GS V 0 - Full cut
      
      // Send to printer
      final bool result = await PrintBluetoothThermal.writeBytes(bytes);
      
      if (result) {
        debugPrint('PrintService: Receipt printed successfully');
        return true;
      } else {
        debugPrint('PrintService: Failed to print receipt');
        return false;
      }
    } catch (e) {
      debugPrint('PrintService: Error printing receipt: $e');
      return false;
    }
  }
  
  /// Print stickers for each cup in the order
  Future<bool> printStickers(Order order) async {
    if (!_isConnected) return false;
    
    try {
      // Flatten items (e.g. 2x Latte -> 2 separate stickers)
      List<Map<String, dynamic>> stickers = [];
      for (var item in order.items) {
        for (int i = 0; i < item.quantity; i++) {
          stickers.add({
            'item': item,
            'index': i + 1, // 1-based index for this item type
            'total': item.quantity,
            'globalIndex': stickers.length + 1,
            'globalTotal': order.items.fold(0, (sum, i) => sum + i.quantity),
          });
        }
      }

      int currentSticker = 0;
      for (var stickerData in stickers) {
        currentSticker++;
        final item = stickerData['item'] as dynamic; // CartItem
        final globalIndex = stickerData['globalIndex'] as int;
        final globalTotal = stickerData['globalTotal'] as int;
        
        List<int> bytes = [];
        
        // Initialize
        bytes += [0x1B, 0x40];
        
        // --- STICKER START ---
        
        // Box border top (simulate with dashes or just spacing)
        bytes += '--------------------------------\n'.codeUnits;
        
        // Header: Store Name + Index
        bytes += [0x1B, 0x61, 0x00]; // Left align
        bytes += [0x1B, 0x45, 0x01]; // Bold
        bytes += 'Mr. Buenaz'.codeUnits;
        bytes += [0x1B, 0x45, 0x00]; // Bold off
        
        // Right align for index
        // ESC/POS doesn't easily do mixed alignment on one line without positioning. 
        // We'll just print on next line or use tabs. Simpler to just print separate lines.
        bytes += '\n'.codeUnits;
        
        bytes += [0x1B, 0x61, 0x02]; // Right align
        bytes += [0x1D, 0x21, 0x11]; // Double width/height
        bytes += '$globalIndex/$globalTotal\n'.codeUnits;
        bytes += [0x1D, 0x21, 0x00]; // Normal
        
        // Customer Name
        bytes += [0x1B, 0x61, 0x00]; // Left align
        bytes += 'CUSTOMER: '.codeUnits;
        bytes += [0x1B, 0x45, 0x01]; // Bold
        bytes += '${order.customerName.toUpperCase()}\n'.codeUnits;
        bytes += [0x1B, 0x45, 0x00]; // Bold off
        bytes += '\n'.codeUnits;
        
        // Product Name (Large)
        bytes += [0x1D, 0x21, 0x11]; // Double size
        bytes += '${item.product.name}\n'.codeUnits;
        bytes += [0x1D, 0x21, 0x00]; // Normal
        
        // Size & Price
        final size = item.product.categoryId == '7' 
            ? (item.size == 'tall' ? 'Small' : 'Large')
            : (item.size == 'tall' ? '16oz' : '22oz');
        
        bytes += '$size           P${item.basePrice.toInt()}\n'.codeUnits;
        
        // Add-ons
        if (item.addOns.isNotEmpty) {
           bytes += 'ADD-ONS:\n'.codeUnits;
           for (var addOn in item.addOns) {
             bytes += '+ ${addOn.name}   P${addOn.price.toInt()}\n'.codeUnits;
           }
        }
        
        // Footer: Date & Total
        bytes += '\n'.codeUnits;
        bytes += '${order.formattedDate} ${order.formattedTime}\n'.codeUnits;
        bytes += '\n'.codeUnits;
        
        // Cut paper
        bytes += [0x1D, 0x56, 0x00]; 
        
        // Send bytes for this sticker
        await PrintBluetoothThermal.writeBytes(bytes);
        
        // Small delay between stickers
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      return true;
    } catch (e) {
      debugPrint('PrintService: Error printing stickers: $e');
      return false;
    }
  }
  
  /// Auto-connect to the last used printer (if available)
  Future<bool> autoConnect() async {
    try {
      final devices = await getPairedDevices();
      if (devices.isEmpty) return false;
      
      // Try to connect to the first printer-like device
      for (var device in devices) {
        final name = device.name.toLowerCase();
        if (name.contains('printer') || 
            name.contains('pos') || 
            name.contains('thermal') ||
            name.contains('58') ||
            name.contains('80')) {
          final connected = await connectToPrinter(device);
          if (connected) return true;
        }
      }
      
      // If no printer found by name, try the first device
      if (devices.isNotEmpty) {
        return await connectToPrinter(devices.first);
      }
      
      return false;
    } catch (e) {
      debugPrint('PrintService: Auto-connect failed: $e');
      return false;
    }
  }
  
  void dispose() {
    _connectionController.close();
  }
}
