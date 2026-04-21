import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/features/auth/auth_provider.dart';
import 'package:flutter_application_1/features/reports/report_provider.dart';

void main() {
  testWidgets('App loads and shows Login Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ReportProvider()),
        ],
        child: MedSevaApp(),
      ),
    );

    // Verify that the login screen title is present
    expect(find.text('Welcome to MedSeva'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
