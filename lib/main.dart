import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI/UX Quiz Demo',
      theme: _isDark
          ? ThemeData.dark()
          : ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
            ),
      home: HomePage(
        isDark: _isDark,
        onToggleTheme: () => setState(() => _isDark = !_isDark),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const HomePage({
    required this.isDark,
    required this.onToggleTheme,
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Product> products = List.generate(
    8,
    (i) => Product(
      name: 'Produk ${i + 1}',
      price: (10 + i * 5).toDouble(),
      imageUrl: 'https://picsum.photos/seed/prod$i/200/200',
    ),
  );

  final List<Contact> contacts = [
    Contact(name: 'Andi', phone: '081234567890', status: ContactStatus.online),
    Contact(name: 'Budi', phone: '082345678901', status: ContactStatus.offline),
    Contact(name: 'Citra', phone: '083456789012', status: ContactStatus.away),
    Contact(name: 'Dewi', phone: '084567890123', status: ContactStatus.online),
  ];

  final List<String> activities = [
    'Login berhasil',
    'Mengunggah file tugas',
    'Melihat detail produk 3',
    'Memanggil kontak Andi',
  ];

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  void _showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KUIS UI/UX Flutter'),
        actions: [
          IconButton(
            tooltip: widget.isDark ? 'Light Mode' : 'Dark Mode',
            icon: Icon(
              widget.isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view), text: 'Produk'),
            Tab(icon: Icon(Icons.credit_card), text: 'Profil'),
            Tab(icon: Icon(Icons.contact_page), text: 'Kontak'),
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.analytics), text: 'Evaluasi UX'),
          ],
        ),
      ),

      // ================================
      // TAB VIEW
      // ================================
      body: TabBarView(
        controller: _tabController,
        children: [
          // ================================
          // TAB 1 - GRID PRODUK
          // ================================
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, idx) {
                final p = products[idx];
                return ProductCard(
                  product: p,
                  onTap: () => _showSnackbar('Tapped ${p.name}'),
                );
              },
            ),
          ),

          // ================================
          // TAB 2 - KARTU PROFIL
          // ================================
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _showSnackbar('Lihat detail profil'),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                    width: 360,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            'https://picsum.photos/seed/profile/200/200',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'M. Ilham Arif Akbar',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'NIM: 231080200082',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Program Studi: Informatika',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.info_outline),
                                label: const Text('Lihat detail'),
                                onPressed: () =>
                                    _showSnackbar('Detail profil ditampilkan'),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ================================
          // TAB 3 - KONTAK
          // ================================
          ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: contacts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final c = contacts[i];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(child: Text(c.name[0])),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: StatusDot(status: c.status),
                      ),
                    ],
                  ),
                  title: Text(c.name),
                  subtitle: Text(c.phone),
                  trailing: IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () {
                      _showSnackbar('Memanggil ${c.name}...');
                    },
                  ),
                  onTap: () => _showContactDialog(context, c),
                ),
              );
            },
          ),

          // ================================
          // TAB 4 – DASHBOARD
          // ================================
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: GridView.count(
                    crossAxisCount: 1,
                    scrollDirection: Axis.horizontal,
                    childAspectRatio: 1.8,
                    children: const [
                      CategoryCard(title: 'Elektronik', icon: Icons.devices),
                      CategoryCard(title: 'Pakaian', icon: Icons.checkroom),
                      CategoryCard(title: 'Makanan', icon: Icons.fastfood),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: const Text('Ringkasan Hari Ini'),
                    subtitle: const Text(
                      'Total penjualan meningkat 12% dibanding kemarin.',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => _showSnackbar('Data diperbarui'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: activities.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) => ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(activities[i]),
                        subtitle: Text(
                          'Waktu: ${(i + 1) * 5} menit lalu',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================================
          // TAB 5 – EVALUASI UX (FINAL)
          // ================================
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluasi UX dari Semua Desain (Soal 1–4)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // ===============================
                  // SOAL 1
                  // ===============================
                  Text(
                    'SOAL 1 – Grid Produk',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. UX terbaik: Grid produk rapi, mudah dipindai, gambar mempermudah identifikasi.',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '2. Perbaikan: Spacing antar elemen & konsistensi ukuran gambar.',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '3. Material Design: Card, Elevation, Grid Layout.',
                  ),
                  const SizedBox(height: 20),

                  // ===============================
                  // SOAL 2
                  // ===============================
                  Text(
                    'SOAL 2 – Profil Pengguna',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. UX terbaik: Avatar jelas, identity mudah dikenali, tombol aksi jelas.',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '2. Perbaikan: Tambahkan ikon pendukung untuk meningkatkan informasi visual.',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '3. Material Design: Typography, Card, Shape.',
                  ),
                  const SizedBox(height: 20),

                  // ===============================
                  // SOAL 3
                  // ===============================
                  Text(
                    'SOAL 3 – Kontak',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. UX terbaik: Status dot sangat membantu membedakan status pengguna.',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '2. Perbaikan: Tambahkan fitur pencarian kontak.',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '3. Material Design: ListTile, Color Indicator, Feedback.',
                  ),
                  const SizedBox(height: 20),

                  // ===============================
                  // SOAL 4
                  // ===============================
                  Text(
                    'SOAL 4 – Dashboard',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. UX terbaik: Informasi ringkas, riwayat aktivitas terstruktur.',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '2. Perbaikan: Tambah grafik visual agar lebih informatif.',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '3. Material Design: Information Hierarchy, Card, Layout Structure.',
                  ),
                  const SizedBox(height: 28),

                  // ===============================
                  // KESIMPULAN
                  // ===============================
                  Text(
                    'KESIMPULAN UMUM UX',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Desain telah menerapkan UX dasar seperti:'
                    '\n• Konsistensi layout'
                    '\n• Navigasi jelas'
                    '\n• Penggunaan ikon & warna yang baik'
                    '\n\nPerbaikan yang disarankan:'
                    '\n• Spacing'
                    '\n• Kontras warna'
                    '\n• Penambahan fitur pendukung'
                    '\n\nMaterial Design yang digunakan:'
                    '\n• Card'
                    '\n• Typography'
                    '\n• Elevation'
                    '\n• Ripple Feedback'
                    '\n• Layout Grid & List',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext ctx, Contact c) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(c.name),
        content: Text(
          'Nomor: ${c.phone}\nStatus: ${c.status.name}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackbar('Memanggil ${c.name}...');
            },
            child: const Text('Panggil'),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    required this.product,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(product.name),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rp ${product.price.toStringAsFixed(0)}'),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                    onPressed: onTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ContactStatus { online, offline, away }

class Contact {
  final String name;
  final String phone;
  final ContactStatus status;

  Contact({
    required this.name,
    required this.phone,
    required this.status,
  });
}

class StatusDot extends StatelessWidget {
  final ContactStatus status;

  const StatusDot({required this.status, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case ContactStatus.online:
        color = Colors.green;
        break;
      case ContactStatus.offline:
        color = Colors.grey;
        break;
      case ContactStatus.away:
        color = Colors.orange;
        break;
    }

    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 2,
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryCard({
    required this.title,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
      ),
    );
  }
}
