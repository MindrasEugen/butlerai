import 'package:flutter/material.dart';
import 'package:butlerai/core/services/supabase_service.dart';
import 'package:butlerai/core/services/firebase_service.dart';

/// Temporary test screen to verify backend connection
/// This will be removed after F0-T15 is completed
class TestConnectionScreen extends StatefulWidget {
  const TestConnectionScreen({super.key});

  @override
  State<TestConnectionScreen> createState() => _TestConnectionScreenState();
}

class _TestConnectionScreenState extends State<TestConnectionScreen> {
  bool _isTesting = false;
  String _supabaseResult = '⏳ Non testato';
  String _firebaseResult = '⏳ Non testato';
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  Future<void> _runTests() async {
    setState(() {
      _isTesting = true;
      _supabaseResult = '🔍 Test in corso...';
      _firebaseResult = '🔍 Test in corso...';
    });

    // Test Supabase connection
    try {
      final supabaseService = SupabaseService();
      final connected = await supabaseService.testConnection();
      
      if (connected) {
        // Try to fetch categories
        final categories = await supabaseService.getCategories();
        setState(() {
          _supabaseResult = '✅ CONNESSO!';
          _categories = categories;
        });
      } else {
        setState(() {
          _supabaseResult = '❌ CONNESSIONE FALLITA';
        });
      }
    } catch (e) {
      setState(() {
        _supabaseResult = '❌ ERRORE: $e';
      });
    }

    // Test Firebase
    try {
      final firebaseService = FirebaseService();
      // Just check if it initializes without error
      // Note: Firebase might fail in emulator without google-services.json
      setState(() {
        _firebaseResult = '✅ Firebase inizializzato (token: ${await firebaseService.getFcmToken()?.substring(0, 20) ?? "non disponibile"})';
      });
    } catch (e) {
      setState(() {
        _firebaseResult = '⚠️  Firebase: $e';
      });
    }

    setState(() {
      _isTesting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Connessione - F0-T15'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Connessione Backend → Client',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            
            // Supabase Section
            const Text(
              '🔥 Supabase',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Stato: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _supabaseResult.contains('✅') ? Colors.green : 
                           _supabaseResult.contains('❌') ? Colors.red : 
                           Colors.orange,
                  ),
                ),
                Text(_supabaseResult),
              ],
            ),
            const SizedBox(height: 10),
            
            if (_categories.isNotEmpty) ...[
              const Text('Categorie caricate:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Wrap(
                spacing: 8,
                children: _categories
                    .take(10) // Show first 10
                    .map((cat) => Chip(
                          label: Text('${cat['name']} ${cat['icon']}'),
                          avatar: const Icon(Icons.category, size: 16),
                        ))
                    .toList(),
              ),
              if (_categories.length > 10) ...[
                const SizedBox(height: 5),
                Text('+ ${_categories.length - 10} altre...', style: TextStyle(color: Colors.grey)),
              ],
            ],
            
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            
            // Firebase Section
            const Text(
              '📡 Firebase (FCM)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Stato: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _firebaseResult.contains('✅') ? Colors.green : 
                           _firebaseResult.contains('❌') ? Colors.red : 
                           _firebaseResult.contains('⚠️') ? Colors.orange :
                           Colors.orange,
                  ),
                ),
                Flexible(child: Text(_firebaseResult)),
              ],
            ),
            const SizedBox(height: 10),
            
            // Summary
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              '📋 Riepilogo F0-T15',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  children: [
                    TableCell(child: Text('Backend', style: TextStyle(fontWeight: FontWeight.bold))),
                    TableCell(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text('Supabase')),
                    TableCell(
                      child: Icon(
                        _supabaseResult.contains('✅') ? Icons.check_circle : 
                        _supabaseResult.contains('❌') ? Icons.cancel : 
                        Icons.help_outline,
                        color: _supabaseResult.contains('✅') ? Colors.green : 
                               _supabaseResult.contains('❌') ? Colors.red : 
                               Colors.orange,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(child: Text('Firebase/FCM')),
                    TableCell(
                      child: Icon(
                        _firebaseResult.contains('✅') ? Icons.check_circle : 
                        _firebaseResult.contains('❌') ? Icons.cancel : 
                        Icons.help_outline,
                        color: _firebaseResult.contains('✅') ? Colors.green : 
                               _firebaseResult.contains('❌') ? Colors.red : 
                               Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Overall result
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _supabaseResult.contains('✅') && _firebaseResult.contains('✅') 
                    ? Colors.green.withOpacity(0.1) 
                    : _supabaseResult.contains('❌') || _firebaseResult.contains('❌')
                      ? Colors.red.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    _supabaseResult.contains('✅') && _firebaseResult.contains('✅')
                        ? '🎉 TUTTO FUNZIONA!' 
                        : _supabaseResult.contains('❌') || _firebaseResult.contains('❌')
                          ? '❌ CI SONO ERRORI' 
                          : '⚠️  VERIFICARE',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Se tutto e verde, F0-T15 e COMPLETATO!',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Refresh button
            FilledButton.icon(
              onPressed: _isTesting ? null : _runTests,
              icon: const Icon(Icons.refresh),
              label: const Text('Testa di nuovo'),
            ),
            
            const SizedBox(height: 40),
            
            // Help section
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              '❓ Aiuto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Se Supabase fallisce:'
              '\n1. Verifica che .env abbia SUPABASE_URL e SUPABASE_ANON_KEY validi'
              '\n2. Verifica che il progetto Supabase sia accessibile'
              '\n3. Verifica che le RLS policy permettano la lettura delle categorie'
            ),
            const SizedBox(height: 10),
            const Text(
              'Se Firebase fallisce:'
              '\n1. Assicurati che google-services.json e GoogleService-Info.plist siano presenti'
              '\n2. Su Android: esegui flutter pub get e assicurati che il plugin Google Services sia configurato'
              '\n3. Su iOS: esegui pod install nella cartella ios/'
            ),
          ],
        ),
      ),
    );
  }
}
