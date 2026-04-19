import 'package:flutter/material.dart'; //FLutter'ın temel kütüphanesi
import 'tahmin_sayfasi.dart'; //Tahmin sayfasına geçiş yapabilmek için ekledim

class ModellerSayfasi extends StatefulWidget { //Bu ekranı ModellerSayfasi olarak tanımladı. AMA stateful olarak , yani bu sayfadaki widgetlar dinamik olabilir.
  const ModellerSayfasi({super.key});

  @override
  State<ModellerSayfasi> createState() => _ModellerSayfasiState(); //widgetların durumunu yönetmek için bir sınıf oluşturdum.
}

class _ModellerSayfasiState extends State<ModellerSayfasi> {
  int? _expandedIndex; //Hangi model detaylarının gösterildiğini tutar , başta NULL yani hiçbirşey sonra hangileri geniletilirse onun indexini tutar.

  final List<Map<String, dynamic>> modeller = [ //Modelleri ve özelliklerini tanımladığım liste. final olarak çünkü bunları kullanıcı değiiştiremez.
    {
  'isim': 'GPT-4.5',
  'gelistirici': 'OpenAI',
  'aciklama': 'Çok geniş bağlam penceresi ve gelişmiş çok dilli anlama yetenekleriyle karmaşık görevlerde yüksek doğruluk sunan en son dil modeli.',
  'ikon': Icons.diamond_outlined,
  'renk': const Color(0xFF10A37F),
  'logoYolu': 'assets/GPT.png',
  'parametreler': 1800.0,
  'boyut': 2100.0,
  'zeka': 96,
  'ajan': 92,
  'kod': 94,
},
{
  'isim': 'GPT-4o',
  'gelistirici': 'OpenAI',
  'aciklama': 'Metin, görüntü ve sesi aynı anda işleyebilen, gerçek zamanlı yanıt veren çok modlu amiral gemisi model.',
  'ikon': Icons.auto_awesome,
  'renk': const Color(0xFF00A67E),
  'logoYolu': 'assets/GPT.png',
  'parametreler': 750.0,
  'boyut': 900.0,
  'zeka': 92,
  'ajan': 90,
  'kod': 88,
},
{
  'isim': 'Claude 4 Opus',
  'gelistirici': 'Anthropic',
  'aciklama': '200K bağlam uzunluğu ve üstün muhakeme kabiliyeti ile uzun belge analizi ve hassas planlama için optimize edilmiştir.',
  'ikon': Icons.lightbulb_outline,
  'renk': const Color(0xFFD97757),
  'logoYolu': 'assets/Claude.png',
  'parametreler': 1200.0,
  'boyut': 1400.0,
  'zeka': 95,
  'ajan': 93,
  'kod': 90,
},
{
  'isim': 'Claude 4 Sonnet',
  'gelistirici': 'Anthropic',
  'aciklama': 'Hız ve zeka dengesiyle öne çıkan, günlük iş akışları ve hızlı kodlama yardımları için ideal orta seviye model.',
  'ikon': Icons.speed,
  'renk': const Color(0xFFC96438),
  'logoYolu': 'assets/Claude.png',
  'parametreler': 450.0,
  'boyut': 520.0,
  'zeka': 88,
  'ajan': 86,
  'kod': 85,
},
{
  'isim': 'Gemini 2.5 Flash',
  'gelistirici': 'Google DeepMind',
  'aciklama': 'Düşük gecikme süresi ve yüksek işlem hacmi için tasarlanmış, 1M token bağlamı destekleyen verimli çok modlu model.',
  'ikon': Icons.flash_on,
  'renk': const Color(0xFF8E6FD2),
  'logoYolu': 'assets/Google.png',
  'parametreler': 250.0,
  'boyut': 320.0,
  'zeka': 85,
  'ajan': 84,
  'kod': 80,
},
{
  'isim': 'DeepSeek-R2',
  'gelistirici': 'DeepSeek',
  'aciklama': 'Gelişmiş uzun zincirli akıl yürütme (Reasoning) odaklı, bilimsel ve matematiksel problem çözmede üstün performans sunar.',
  'ikon': Icons.psychology,
  'renk': const Color(0xFF3366CC),
  'logoYolu': 'assets/DeepSeek.png',
  'parametreler': 680.0,
  'boyut': 790.0,
  'zeka': 91,
  'ajan': 82,
  'kod': 93,
},
{
  'isim': 'DeepSeek-Coder-V2',
  'gelistirici': 'DeepSeek',
  'aciklama': 'Kod tamamlama, hata ayıklama ve mimari planlama için eğitilmiş, 128K bağlam penceresine sahip açık ağırlıklı model.',
  'ikon': Icons.code,
  'renk': const Color(0xFF1E3A8A),
  'logoYolu': 'assets/DeepSeek.png',
  'parametreler': 230.0,
  'boyut': 280.0,
  'zeka': 84,
  'ajan': 70,
  'kod': 95,
},
{
  'isim': 'Qwen3-Max',
  'gelistirici': 'Alibaba Cloud',
  'aciklama': 'Çok dilli (özellikle Asya dilleri) yetkinliği yüksek, 1M token bağlamı ve güçlü doküman anlama kabiliyetine sahip amiral model.',
  'ikon': Icons.language,
  'renk': const Color(0xFFFF6A00),
  'logoYolu': 'assets/Qwen.png',
  'parametreler': 1600.0,
  'boyut': 1850.0,
  'zeka': 90,
  'ajan': 88,
  'kod': 86,
},
{
  'isim': 'Qwen2.5-Coder',
  'gelistirici': 'Alibaba Cloud',
  'aciklama': 'Kod üretimi ve teknik analizde uzmanlaşmış, 32K bağlam desteğiyle hızlı ve yerel çalışmaya uygun kompakt model.',
  'ikon': Icons.terminal,
  'renk': const Color(0xFFD94E00),
  'logoYolu': 'assets/Qwen.png',
  'parametreler': 32.0,
  'boyut': 18.0,
  'zeka': 78,
  'ajan': 65,
  'kod': 91,
},
{
  'isim': 'MiniMax-Text-01',
  'gelistirici': 'MiniMax',
  'aciklama': 'Son derece uzun bağlam işleme (4M token) ve yaratıcı içerik üretiminde öne çıkan yeni nesil doğrusal dikkat modeli.',
  'ikon': Icons.auto_stories,
  'renk': const Color(0xFF5B2D8E),
  'logoYolu': 'assets/MiniMax.png',
  'parametreler': 456.0,
  'boyut': 540.0,
  'zeka': 87,
  'ajan': 85,
  'kod': 79,
},
{
  'isim': 'GLM-5',
  'gelistirici': 'ZAI (Zhipu AI)',
  'aciklama': 'Çince-İngilizce iki dilde üstün anlama ve otomatik ajan görev yürütme (AutoGLM) kabiliyetleriyle donatılmıştır.',
  'ikon': Icons.smart_toy,
  'renk': const Color(0xFF0066CC),
  'logoYolu': 'assets/Zai.png',
  'parametreler': 400.0,
  'boyut': 480.0,
  'zeka': 89,
  'ajan': 91,
  'kod': 83,
},
{
  'isim': 'Mistral Large 3',
  'gelistirici': 'Mistral AI',
  'aciklama': 'Avrupa merkezli, çok dilli ve açık ağırlıklı olmasa da yüksek performanslı, işletme odaklı mantık yürütme modeli.',
  'ikon': Icons.balance,
  'renk': const Color(0xFFFF7A00),
  'logoYolu': 'assets/Mistral.png',
  'parametreler': 650.0,
  'boyut': 760.0,
  'zeka': 93,
  'ajan': 87,
  'kod': 89,
},
{
  'isim': 'Mistral NeMo 2',
  'gelistirici': 'Mistral AI',
  'aciklama': 'NVIDIA ile geliştirilmiş, ticari kullanıma uygun açık lisanslı, 128K bağlam desteği olan hızlı ve çevik model.',
  'ikon': Icons.rocket_launch,
  'renk': const Color(0xFFCC5500),
  'logoYolu': 'assets/Mistral.png',
  'parametreler': 25.0,
  'boyut': 14.0,
  'zeka': 82,
  'ajan': 78,
  'kod': 84,
},
  ];

  @override
  Widget build(BuildContext context) { //Scaffold ile yine temel bir  yapı oluşturuyoruz. AppBar'ı ve body'i tanımlıyoruz.
    return Scaffold(
      appBar: AppBar( //AppBar widget'ı, uygulamanın üst kısmında bir başlık çubuğu sağlar.
        title: const Text('Yapay Zeka Modelleri'),
      ),
      body: ListView.builder( //Listeleri oluşturmak için kullandım burda ayrıca itemCount ile kaç model alduğunu sayısını verdim.
        padding: const EdgeInsets.all(16),
        itemCount: modeller.length,
        itemBuilder: (context, index) {
          final model = modeller[index];
          final isExpanded = _expandedIndex == index;

          return GestureDetector(
            onTap: () { //kullanıcı bir modele tılayınca detayların gösterilmesi veya gizlenmesini yapar. Basit bir toggle mantığı.
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            child: AnimatedContainer( //Model kartlarının genleşme ve küçülme animasyonunu sağlar.
              duration: const Duration(milliseconds: 300), //Animasyon süresi
              curve: Curves.easeInOut,  //Animasyon eğrisi
              margin: const EdgeInsets.only(bottom: 12), //Kartlar arasına boşluk ekler
              decoration: BoxDecoration( //Kartların genel görünümünü belirler. Renk, köşe yuvarlama, gölge gibi özellikler içerir.
                color: Colors.white, //RENK
                borderRadius: BorderRadius.circular(16), //Köşe yuvarlama sertliği
                border: Border.all( //Kenar çizgisi ekler.
                  color: isExpanded
                      ? (model['renk'] as Color).withValues(alpha: 0.4)
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [ //Gölge ekler. Genleşme durumuna göre gölgenin yoğunluğunu ve bulanıklığını değiştirir.
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isExpanded ? 0.08 : 0.03),
                    blurRadius: isExpanded ? 16 : 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column( //Model kartının içeriğini tanımlar. İkon, isim, geliştirici, açıklama, performans endeksi gibi bilgileri içerir. Ayrıca genleşme durumuna göre detayların gösterilmesini sağlar.
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        _buildLogo(model), //Modelin logosunu gösteren özel bir widget. Logo yoksa ikon gösterir.
                        const SizedBox(width: 14), //Logo ile model ismi arasına boşluk ekler.
                        Expanded( //Isim uzunluğuna göre ismin sığması için kullanılır.
                          child: Text(
                            model['isim'] as String,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        AnimatedRotation( //Genleşme durumuna göre okun yönünü döndürür. Daha güzel bir görünüm sağlar.
                          turns: isExpanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: model['renk'] as Color,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedCrossFade( //Genleşme durumuna göre detayları gösterir veya gizler. İlk çocuk boş bir alan, ikinci çocuk detayları içeren widget. Geçiş animasyonu sağlar.
                    firstChild: const SizedBox(width: double.infinity),
                    secondChild: _buildExpandedContent(context, model),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                    sizeCurve: Curves.easeInOut,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo(Map<String, dynamic> model) { //Model logosunu gösteren özel bir widget. Logo yoksa ikon gösterir.
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: (model['renk'] as Color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          model['logoYolu'] as String,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              model['ikon'] as IconData,
              color: model['renk'] as Color,
              size: 24,
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpandedContent( //Genleşme durumda gösterilen detayları içeren widget.
      BuildContext context, Map<String, dynamic> model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: Color(0xFFE5E7EB)), //Model ismi ile detaylar arasına ince bir çizgi ekler.
          const SizedBox(height: 14), //Çizgi ile detaylar arasına boşluk ekler.

          Text( //Model geliştiricisini gösterir.
            model['gelistirici'] as String,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            model['aciklama'] as String, //Model açıklamasını gösterir.
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              _buildInfoChip( //Model parametre sayısını gösteren küçük bir etiket. İkon, metin ve renk alır.
                Icons.tune_rounded,
                '${(model['parametreler'] as double).toStringAsFixed(0)}B Parametre',
                const Color(0xFF6366F1),
              ),
              const SizedBox(width: 8),
              _buildInfoChip( //Aynı şekilde ama bu sefer model boyutunu gösterir.
                Icons.save_outlined,
                '${(model['boyut'] as double).toStringAsFixed(0)} GB',
                const Color(0xFFDB7C26),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Container( //Modelin performans endeksini gösteren kutu. İçinde zeka, ajan ve kod skorları için barlar var.
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text( //Performans endeksi başlığını gösterir.
                  'Performans Endeksi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                _buildScoreBar( //Modelin zeka skorunu gösteren bar. Isim, skor ve renk alır.
                    'Zeka', model['zeka'] as int, const Color(0xFF4A6FA5)),
                const SizedBox(height: 10),
                _buildScoreBar( //Ajan skoru değişkenni için aynı şekilde bar olarak ama farklı renk.
                    'Ajan', model['ajan'] as int, const Color(0xFF5B8C5A)),
                const SizedBox(height: 10),
                _buildScoreBar( //Bu sefer kod skoru için bar , renk yine farklı.
                    'Kod', model['kod'] as int, const Color(0xFFCB8C3E)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          SizedBox( //Tıklandığında modelin çalıştırılabilirliğini test etmek için tahmin sayfasına geçiş yapacak buton.
            width: double.infinity,
            child: OutlinedButton( //Hafif görünüşlü bir buton.
              onPressed: () {
                Navigator.push( //Tıklandığında ne yaptığını belirliyen fonksiyon.
                  context,
                  MaterialPageRoute(
                    builder: (context) => TahminSayfasi( //Tahmin sayfasına geçiş yapar ve seçilen modelin bilgilerini gönderir.
                      modelIsmi: model['isim'] as String, //ismi gönderir.
                      parametreler: model['parametreler'] as double, //parametre sayısını gönderir.
                      boyut: model['boyut'] as double, //boyutunu gönderir.
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom( //Butomnun görünümünü belirler.
                foregroundColor: const Color(0xFF4A6FA5), //Yazı rengi
                side: const BorderSide(color: Color(0xFF4A6FA5)), //Butonun kenar çizgisi rengi
                padding: const EdgeInsets.symmetric(vertical: 12), //Butonun içindeki yazı ve ikonun dikeyde ortalanması için padding ekler.
                shape: RoundedRectangleBorder( //Butonun köşe yuvarlama şeklini belirler.
                  borderRadius: BorderRadius.circular(10), //Köşe yuvarlama sertliği
                ),
              ),
              child: const Text( //Butonun içindeki metni ve stilini belirler.
                'Çalıştırabilir miyim?',
                style: TextStyle(fontWeight: FontWeight.w600), //Yazı kalınlığı
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) { //Model parametre sayısı ve boyutunu göstermek için kullanılan küçük etiketler. İkon, metin ve renk alır.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), //Etiketin içindeki metin ve ikonun etrafına boşluk ekler.
      decoration: BoxDecoration( //Etiketin görünümünü belirler. Renk, köşe yuvarlama gibi özellikler içerir.
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, //Row'un genişliğini içindeki elemanlara göre ayarlar, böylece etiketin boyutu metne ve ikona göre şekillenir.
        children: [
          Icon(icon, size: 15, color: color), //Etiketin içindeki ikonu gösterir. İkonun boyutu ve rengi parametre olarak alınır.
          const SizedBox(width: 5),
          Text( //Etiketin içindeki metni gösterir. Metin ve rengi parametre olarak alınır.
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, int score, Color color) { //Modelin zeka, ajan ve kod skorlarını göstermek için kullanılan barlar. İsim, skor ve renk alır.
    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded( //Barın ekranın geri kalanını kaplaması için kullanılır.
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox( //Skorun yüzdesine göre barın doluluk oranını belirler. Skor 100 üzerinden olduğu için 100'e bölüyoruz.
                widthFactor: score / 100.0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10), //Bar ile skor metni arasına boşluk ekler.
        SizedBox(
          width: 32,
          child: Text(
            '$score',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
