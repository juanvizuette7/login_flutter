import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = AuthService();
  List<Map<String, dynamic>> _docs = [];
  bool _loading = true;
  String _filter = "Todos";

  final List<String> categories = ["Todos", "Académico", "Legal", "Financiero", "Personal", "Otro"];

  Future<void> _fetchDocs() async {
    try {
      final data = await Supabase.instance.client
          .from('documents')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _docs = List<Map<String, dynamic>>.from(data);
        _loading = false;
      });
    } catch (e) {
      print("ERROR FETCHING DOCS: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _newDocumentDialog() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final titleController = TextEditingController();
    String category = "Otro";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Subir Documento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Título del documento"),
            ),
            DropdownButtonFormField<String>(
              value: category,
              items: categories.where((c) => c != "Todos").map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) => category = val ?? "Otro",
              decoration: const InputDecoration(labelText: "Categoría"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.deepOrange),
            onPressed: () {
              Navigator.pop(ctx);
              _pickFile(titleController.text, category, user.id);
            },
            child: const Text("Elegir archivo"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile(String title, String category, String userId) async {
    final input = html.FileUploadInputElement()
      ..accept = '.pdf,.doc,.docx,.xls,.xlsx,.txt';
    input.click();

    input.onChange.listen((event) async {
      final file = input.files?.first;
      if (file == null) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;

      final bytes = reader.result as List<int>;
      final uint8list = Uint8List.fromList(bytes);

      final filePath = '$userId/${DateTime.now().millisecondsSinceEpoch}_${file.name}';

      try {
        await Supabase.instance.client.storage
            .from('safe-docs')
            .uploadBinary(filePath, uint8list);

        final url = Supabase.instance.client.storage.from('safe-docs').getPublicUrl(filePath);

        await Supabase.instance.client.from('documents').insert({
          'user_id': userId,
          'title': title.isEmpty ? file.name : title,
          'file_url': url,
          'category': category,
        });

        _fetchDocs();
      } catch (e) {
        print("UPLOAD ERROR: $e");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error al subir: $e")));
      }
    });
  }

  IconData _iconForFile(String name) {
    if (name.endsWith(".pdf")) return Icons.picture_as_pdf;
    if (name.endsWith(".xls") || name.endsWith(".xlsx")) return Icons.table_chart;
    if (name.endsWith(".doc") || name.endsWith(".docx")) return Icons.description;
    return Icons.insert_drive_file;
  }

  @override
  void initState() {
    super.initState();
    _fetchDocs();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDocs = _filter == "Todos"
        ? _docs
        : _docs.where((d) => d["category"] == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("SafeDocs – Documentos"),
        backgroundColor: Colors.deepOrange,
        actions: [
          DropdownButton<String>(
            value: _filter,
            items: categories.map((cat) {
              return DropdownMenuItem(value: cat, child: Text(cat));
            }).toList(),
            onChanged: (val) => setState(() => _filter = val ?? "Todos"),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : filteredDocs.isEmpty
              ? const Center(child: Text("📂 No hay documentos todavía"))
              : ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (ctx, i) {
                    final doc = filteredDocs[i];
                    return Card(
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: Icon(
                          _iconForFile(doc['title'] ?? ''),
                          color: Colors.deepOrange,
                        ),
                        title: Text(doc['title']),
                        subtitle: Text("Categoría: ${doc['category']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () =>
                              html.window.open(doc['file_url'], "_blank"),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.upload_file),
        label: const Text("Subir Documento"),
        onPressed: _newDocumentDialog,
      ),
    );
  }
}
