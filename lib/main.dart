import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const SafeDocsApp());
}

class SafeDocsApp extends StatelessWidget {
  const SafeDocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeDocs',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepOrange,
      ),

      home: user == null ? const LoginPage() : const HomePage(),
    );
  }
}

// 🔹 Servicios de autenticación
class AuthService {
  final _auth = Supabase.instance.client.auth;

  Future<AuthResponse> signUp(String email, String password) =>
      _auth.signUp(email: email, password: password);

  Future<AuthResponse> signIn(String email, String password) =>
      _auth.signInWithPassword(email: email, password: password);

  Future<void> signOut() => _auth.signOut();

  User? get currentUser => _auth.currentUser;
}
