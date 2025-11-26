// Flutter'daki widget'ları test etmek için gerekli kütüphane.
import 'package:flutter/material.dart';
// Flutter test araçlarını içerir.
import 'package:flutter_test/flutter_test.dart';

// Test edeceğimiz uygulamamızın ana dosyasını içe aktarıyoruz.
// Projenizin adına göre (Örn: dailyflow_simple) bu satırı güncelleyin!
import 'package:dailyflow_simple/main.dart'; 

void main() {
  // `testWidgets` fonksiyonu, widget'ları (kullanıcı arayüzü bileşenlerini) test etmek için kullanılır.
  // İlk argüman testin adıdır.
  testWidgets('Uygulama temel başlığı ve görev listesi ekleme butonunu kontrol et', (WidgetTester tester) async {
    // 1. Uygulamayı Hazırla (Render Et)
    // `tester.pumpWidget` uygulamayı test ortamında başlatır ve render (çizim) edilmesini sağlar.
    await tester.pumpWidget(const DailyFlowApp());

    // 2. Kontrol Et (Verify)
    
    // a) Başlık Kontrolü
    // Uygulamanın AppBar'ında "DailyFlow Basit" metninin görünüp görünmediğini kontrol eder.
    // `find.text()` belirli bir metin içeren widget'ları bulur.
    expect(
      find.text('DailyFlow Basit'), 
      findsOneWidget, // Ekranda tam olarak BİR tane bu metinden olmasını bekliyoruz.
      reason: 'Uygulama başlığı "DailyFlow Basit" bulunamadı.'
    );

    // b) Başlangıç Durumunda Görev Listesi Başlığını Kontrol Et
    // Varsayılan olarak uygulama açıldığında görev listesinin boş olduğunu belirten metin görünüyor mu?
    expect(
      find.text('Görev listeniz boş.'),
      findsOneWidget,
      reason: 'Boş ekran durumu metni görünmüyor.'
    );

    // c) Ekleme Butonunu Kontrol Et
    // Floating Action Button (FAB) üzerindeki '+' simgesinin (Icons.add) varlığını kontrol eder.
    // `find.byIcon()` belirli bir simgeyi içeren widget'ı bulur.
    expect(
      find.byIcon(Icons.add), 
      findsOneWidget,
      reason: 'Yeni görev ekleme butonu (+) bulunamadı.'
    );
    
    // -------------------------------------------------------------------------
    
    // 3. Etkileşimi Simüle Et (Interact)
    // '+' butonuna basma eylemini simüle edelim. Bu, modal (alt pencere) açmalıdır.
    await tester.tap(find.byIcon(Icons.add));
    // `pump()` ile Flutter'a, buton tıklaması sonucu oluşan arayüz değişikliğini (modal açılmasını) çizmesi için zaman tanıyoruz.
    await tester.pump(); 

    // 4. Etkileşim Sonucunu Kontrol Et
    // Butona bastıktan sonra açılan modal'daki "Yeni Görev Ekle" başlığını kontrol ediyoruz.
    expect(
      find.text('Yeni Görev Ekle'),
      findsOneWidget,
      reason: 'FAB tıklandıktan sonra görev ekleme modalı açılmadı.'
    );
  });
}