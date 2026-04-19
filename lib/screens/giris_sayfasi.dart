import 'package:flutter/material.dart'; //FLutter'ın temel kütüphanesi
import 'modeller_sayfasi.dart'; //Modeller sayfasına geçiş yapabilmek için ekledim

//Bu ekranı GirisSayfasi olarak tanımladı.
class GirisSayfasi extends StatelessWidget {
  const GirisSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( //Scaffold widget'ı, temel bir uygulama yapısı sağlar. AppBar, body gibi bölümleri içerir.
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration( //Bu kısım arka plan görelini eklemek için.
          image: DecorationImage(
            image: AssetImage('assets/BG.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: SafeArea( //Bu widget cihazın kendi UI elemtlerinin üzerine gelmemesi için kullanılır. Mesala telefonun üst çentiği.
          child: Center( //Bu widget içindeki elemanları ortalamak için kullanılır.
            child: Padding( //Bu widget içindeki elemanlara yatayda 32 birim boşluk vveriyor.
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column( //Bu widget içindeki elemanları dikey olarak sıralamak için kullanılır.
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ //Bu kısımda ikon, başlık, açıklama ve butonu sıraladım.
                  Container( //Bu kısımda Widget ikonunun nasıl görüneceğini belirtir(Renk , Boyut Knear vb.).
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A6FA5).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.hub_outlined,
                      size: 52,
                      color: Color(0xFF4A6FA5),
                    ),
                  ),
                  const SizedBox(height: 40), //Boşluk ekler.
                  const Text( //Başlık metni ve stili
                    'Yapay Zeka\nDünyasını Keşfet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16), //Yine boşluk ekler.
                  const Text( //Açıklama metni ve stili
                    'En güncel yapay zeka modellerini incele,\nperformanslarını karşılaştır ve donanımınla\nuyumluluğunu test et.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(//Butonun genişliğini ekranın tamamına yaymak için kullanılır.
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () { //Butona tıklandığında ne yapılacağını belirler , burda ModellerSayfasi'na geçiş yapar.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ModellerSayfasi(),
                          ),
                        );
                      },
                      child: const Row( //Butonun içindeki metin ve ikonun nasıl görüneceğini belirtir.
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Modelleri İncele'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
