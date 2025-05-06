import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Kho Hàng QR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 237, 237), // Đặt màu nền đen
      appBar: AppBar(
        title: Text('Quản Lý Kho Hàng QR'),
        backgroundColor: const Color.fromARGB(255, 44, 61, 69), // Màu nền AppBar
        foregroundColor: Colors.white, // Màu chữ AppBar
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true, // Để GridView không chiếm toàn bộ không gian
                  children: [
                    _buildFeatureCard(
                      title: 'Khai Báo Sản Phẩm',
                      icon: Icons.add_circle,
                      color: Colors.blue[300]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRScanPage(
                              title: 'Khai Báo Sản Phẩm',
                              onScan: (code) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDeclarationPage(qrCode: code),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      title: 'Nhập Hàng',
                      icon: Icons.input,
                      color: Colors.green[300]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRScanPage(
                              title: 'Nhập Hàng',
                              onScan: (code) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StockInPage(qrCode: code),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      title: 'Xuất Hàng',
                      icon: Icons.output,
                      color: Colors.orange[300]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRScanPage(
                              title: 'Xuất Hàng',
                              onScan: (code) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StockOutPage(qrCode: code),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      title: 'Báo Cáo Tồn Kho',
                      icon: Icons.assessment,
                      color: Colors.purple[300]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InventoryReportPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.blueGrey[900], // Màu nền cho thông tin sinh viên
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Hoàng Duy Hướng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Mã số sinh viên: 22119187',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color.withOpacity(0.8), // Màu nền nhạt
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white, // Màu biểu tượng trắng
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Màu chữ trắng
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Các Model cho ứng dụng
class Product {
  int? id;
  String qrCode;
  String name;
  int quantity;

  Product({
    this.id,
    required this.qrCode,
    required this.name,
    this.quantity = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qrCode': qrCode,
      'name': name,
      'quantity': quantity,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      qrCode: map['qrCode'],
      name: map['name'],
      quantity: map['quantity'],
    );
  }
}

class StockTransaction {
  int? id;
  String qrCode;
  int quantity;
  String type; // "in" or "out"
  String date;

  StockTransaction({
    this.id,
    required this.qrCode,
    required this.quantity,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qrCode': qrCode,
      'quantity': quantity,
      'type': type,
      'date': date,
    };
  }

  static StockTransaction fromMap(Map<String, dynamic> map) {
    return StockTransaction(
      id: map['id'],
      qrCode: map['qrCode'],
      quantity: map['quantity'],
      type: map['type'],
      date: map['date'],
    );
  }
}

// Database Helper
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'warehouse_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, qrCode TEXT, name TEXT, quantity INTEGER)',
        );
        await db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY, qrCode TEXT, quantity INTEGER, type TEXT, date TEXT)',
        );
      },
    );
  }

Future<int> insertProduct(Product product) async {
  Database db = await database;
  
  // Kiểm tra sản phẩm đã có chưa
  var existing = await db.query(
    'products',
    where: 'qrCode = ?',
    whereArgs: [product.qrCode],
  );

  if (existing.isNotEmpty) {
    // Nếu đã có thì không insert mới nữa
    return 0;
  }

  // Nếu chưa có thì mới insert
  return await db.insert('products', product.toMap());
}


  Future<int> updateProduct(Product product) async {
    Database db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: product.id != null ? 'id = ?' : 'qrCode = ?',
      whereArgs: [product.id ?? product.qrCode],
    );
  }


  Future<Product?> getProductByQRCode(String qrCode) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'qrCode = ?',
      whereArgs: [qrCode],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

Future<List<Product>> getAllProducts() async {
  Database db = await database;
  List<Map<String, dynamic>> maps = await db.rawQuery(
    'SELECT qrCode, name, SUM(quantity) as quantity FROM products GROUP BY qrCode'
  );
  return List.generate(maps.length, (i) {
    return Product(
      qrCode: maps[i]['qrCode'],
      name: maps[i]['name'],
      quantity: maps[i]['quantity'],
    );
  });
}


  Future<int> insertTransaction(StockTransaction transaction) async {
    Database db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<StockTransaction>> getTransactionsByQRCode(String qrCode) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'qrCode = ?',
      whereArgs: [qrCode],
    );
    return List.generate(maps.length, (i) {
      return StockTransaction.fromMap(maps[i]);
    });
  }
}

// Trang QR Scanner
class QRScanPage extends StatefulWidget {
  final String title;
  final Function(String) onScan;

  QRScanPage({required this.title, required this.onScan});

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final MobileScannerController controller = MobileScannerController();
  bool scanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && !scanned) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null) {
                    scanned = true;
                    controller.stop();
                    widget.onScan(code);
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Đặt mã QR vào khung để quét',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
  // Removed unused _onQRViewCreated method as it references an undefined QRViewController class.


// Trang Khai Báo Sản Phẩm
class ProductDeclarationPage extends StatefulWidget {
  final String qrCode;

  ProductDeclarationPage({required this.qrCode});

  @override
  _ProductDeclarationPageState createState() => _ProductDeclarationPageState();
}

class _ProductDeclarationPageState extends State<ProductDeclarationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late DatabaseHelper _dbHelper;
  bool _isLoading = true;
  bool _productExists = false;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    final product = await _dbHelper.getProductByQRCode(widget.qrCode);
    if (product != null) {
      // Nếu sản phẩm đã tồn tại thì load thông tin luôn
      _nameController.text = product.name;
      _productExists = true;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khai Báo Sản Phẩm'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã QR: ${widget.qrCode}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Tên Sản Phẩm',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên sản phẩm';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveProduct,
                        child: Text(
                          _productExists ? 'Cập Nhật Sản Phẩm' : 'Lưu Sản Phẩm',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        qrCode: widget.qrCode,
        name: _nameController.text,
      );

      if (_productExists) {
        await _dbHelper.updateProduct(product);
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Đã cập nhật sản phẩm')),
        );
      } else {
        await _dbHelper.insertProduct(product);
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Đã thêm sản phẩm mới')),
        );
      }

      Navigator.pop(context as BuildContext);
    }
  }
}

// Trang Nhập Hàng
class StockInPage extends StatefulWidget {
  final String qrCode;

  StockInPage({required this.qrCode});

  @override
  _StockInPageState createState() => _StockInPageState();
}

class _StockInPageState extends State<StockInPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  late DatabaseHelper _dbHelper;
  Product? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    _product = await _dbHelper.getProductByQRCode(widget.qrCode);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập Hàng'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _product == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sản phẩm không tồn tại trong hệ thống',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDeclarationPage(qrCode: widget.qrCode),
                            ),
                          );
                        },
                        child: Text('Khai Báo Sản Phẩm Mới'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mã QR: ${widget.qrCode}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sản phẩm: ${_product!.name}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Số lượng hiện có: ${_product!.quantity}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(
                            labelText: 'Số Lượng Nhập',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập số lượng';
                            }
                            try {
                              int quantity = int.parse(value);
                              if (quantity <= 0) {
                                return 'Số lượng phải lớn hơn 0';
                              }
                            } catch (e) {
                              return 'Vui lòng nhập số nguyên hợp lệ';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveStockIn,
                            child: Text(
                              'Lưu Nhập Hàng',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Future<void> _saveStockIn() async {
    if (_formKey.currentState!.validate()) {
      int quantity = int.parse(_quantityController.text);

      // Cập nhật số lượng sản phẩm
      _product!.quantity += quantity;
      await _dbHelper.updateProduct(_product!);

      // Lưu giao dịch nhập hàng
      final transaction = StockTransaction(
        qrCode: widget.qrCode,
        quantity: quantity,
        type: 'in',
        date: DateTime.now().toIso8601String(),
      );
      await _dbHelper.insertTransaction(transaction);

      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Đã nhập hàng thành công')),
      );

      Navigator.pop(context as BuildContext);
    }
  }
}

// Trang Xuất Hàng
class StockOutPage extends StatefulWidget {
  final String qrCode;

  StockOutPage({required this.qrCode});

  @override
  _StockOutPageState createState() => _StockOutPageState();
}

class _StockOutPageState extends State<StockOutPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  late DatabaseHelper _dbHelper;
  Product? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    _product = await _dbHelper.getProductByQRCode(widget.qrCode);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xuất Hàng'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _product == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sản phẩm không tồn tại trong hệ thống',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDeclarationPage(qrCode: widget.qrCode),
                            ),
                          );
                        },
                        child: Text('Khai Báo Sản Phẩm Mới'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mã QR: ${widget.qrCode}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sản phẩm: ${_product!.name}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Số lượng hiện có: ${_product!.quantity}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(
                            labelText: 'Số Lượng Xuất',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập số lượng';
                            }
                            try {
                              int quantity = int.parse(value);
                              if (quantity <= 0) {
                                return 'Số lượng phải lớn hơn 0';
                              }
                              if (quantity > _product!.quantity) {
                                return 'Số lượng xuất không thể lớn hơn số lượng hiện có';
                              }
                            } catch (e) {
                              return 'Vui lòng nhập số nguyên hợp lệ';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveStockOut,
                            child: Text(
                              'Lưu Xuất Hàng',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Future<void> _saveStockOut() async {
    if (_formKey.currentState!.validate()) {
      int quantity = int.parse(_quantityController.text);

      // Cập nhật số lượng sản phẩm
      _product!.quantity -= quantity;
      await _dbHelper.updateProduct(_product!);

      // Lưu giao dịch xuất hàng
      final transaction = StockTransaction(
        qrCode: widget.qrCode,
        quantity: quantity,
        type: 'out',
        date: DateTime.now().toIso8601String(),
      );
      await _dbHelper.insertTransaction(transaction);

      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Đã xuất hàng thành công')),
      );

      Navigator.pop(context as BuildContext);
    }
  }
}

// Trang Báo Cáo Tồn Kho
class InventoryReportPage extends StatefulWidget {
  @override
  _InventoryReportPageState createState() => _InventoryReportPageState();
}

class _InventoryReportPageState extends State<InventoryReportPage> {
  late DatabaseHelper _dbHelper;
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _dbHelper.getAllProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Báo Cáo Tồn Kho'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? Center(
                  child: Text(
                    'Chưa có sản phẩm nào trong kho',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Tổng số sản phẩm: ${_products.length}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                              child: ListTile(
                                title: Text(
                                  product.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('Mã QR: ${product.qrCode}'),
                                trailing: Text(
                                  'SL: ${product.quantity}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: product.quantity > 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                                onTap: () {
                                  _showProductDetail(product);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _showProductDetail(Product product) async {
    final transactions = await _dbHelper.getTransactionsByQRCode(product.qrCode);
    
    showModalBottomSheet(
      context: context as BuildContext,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Mã QR: ${product.qrCode}'),
              SizedBox(height: 8),
              Text(
                'Số lượng hiện có: ${product.quantity}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Lịch sử giao dịch:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: transactions.isEmpty
                    ? Center(child: Text('Chưa có giao dịch nào'))
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          final date = DateTime.parse(transaction.date);
                          final formattedDate =
                              '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
                          
                          return ListTile(
                            leading: Icon(
                              transaction.type == 'in' ? Icons.input : Icons.output,
                              color: transaction.type == 'in' ? Colors.green : Colors.red,
                            ),
                            title: Text(
                              transaction.type == 'in' ? 'Nhập hàng' : 'Xuất hàng',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(formattedDate),
                            trailing: Text(
                              '${transaction.type == 'in' ? '+' : '-'}${transaction.quantity}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: transaction.type == 'in' ? Colors.green : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}