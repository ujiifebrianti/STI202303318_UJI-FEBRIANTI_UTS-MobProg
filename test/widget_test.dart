import 'package:flutter_test/flutter_test.dart';
import 'package:my_event_planner/main.dart';

void main() {
  testWidgets('App dimulai dengan halaman WelcomePage', (WidgetTester tester) async {
    // Jalankan aplikasi utama
    await tester.pumpWidget(const MyEventPlanner());

    // Pastikan tombol di halaman WelcomePage muncul
    expect(find.text('Mulai Aplikasi'), findsOneWidget);

    // Klik tombol "Mulai Aplikasi"
    await tester.tap(find.text('Mulai Aplikasi'));
    await tester.pumpAndSettle();

    // Setelah diklik, pastikan halaman HomePage muncul
    expect(find.text('Home Page'), findsOneWidget);
  });
}
