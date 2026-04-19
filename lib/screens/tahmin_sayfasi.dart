import 'package:flutter/material.dart'; //Flutter'ın temel kütüphanesi

class GpuModel { //GPU modellerini temsil eden sınıf. İsim, VRAM miktarı ve hız çarpanı gibi değişkenlere sahip.
  final String isim;
  final double vram;
  final double hizCarpani;

  const GpuModel({ //Bu değerlerin zorunlu olduğunu belirtir.
    required this.isim,
    required this.vram,
    required this.hizCarpani,
  });
}

const List<GpuModel> gpuListesi = [ //GPU listesi , isimleri , vram miktarları ve hız çarpanları.
  GpuModel(isim: 'NVIDIA RTX PRO 6000 Blackwell Server Edition', vram: 96, hizCarpani: 3.0),
  GpuModel(isim: 'RTX 3060 12GB', vram: 12, hizCarpani: 0.65),
  GpuModel(isim: 'RTX 3070 8GB', vram: 8, hizCarpani: 0.75),
  GpuModel(isim: 'RTX 3080 10GB', vram: 10, hizCarpani: 0.9),
  GpuModel(isim: 'RTX 3090 24GB', vram: 24, hizCarpani: 1.05),
  GpuModel(isim: 'RTX 4060 8GB', vram: 8, hizCarpani: 0.8),
  GpuModel(isim: 'RTX 4060 Ti 16GB', vram: 16, hizCarpani: 0.9),
  GpuModel(isim: 'RTX 4070 12GB', vram: 12, hizCarpani: 0.95),
  GpuModel(isim: 'RTX 4070 Ti Super 16GB', vram: 16, hizCarpani: 1.1),
  GpuModel(isim: 'RTX 4080 16GB', vram: 16, hizCarpani: 1.25),
  GpuModel(isim: 'RTX 4090 24GB', vram: 24, hizCarpani: 1.85),
  GpuModel(isim: 'RTX 5070 12GB', vram: 12, hizCarpani: 1.15),
  GpuModel(isim: 'RTX 5080 16GB', vram: 16, hizCarpani: 1.55),
  GpuModel(isim: 'RTX 5090 32GB', vram: 32, hizCarpani: 2.25),
  GpuModel(isim: 'RX 7600 8GB', vram: 8, hizCarpani: 0.55),
  GpuModel(isim: 'RX 7800 XT 16GB', vram: 16, hizCarpani: 0.75),
  GpuModel(isim: 'RX 7900 XTX 24GB', vram: 24, hizCarpani: 0.95),
];

class TahminSayfasi extends StatefulWidget { //Modelin çalıştırılabilirliğini tahmin eden sayfa.
  final String modelIsmi; //model ismi değişkeni.
  final double parametreler; //model parametre sayısı değişkeni.
  final double boyut; //model boyutu değişkeni.

  const TahminSayfasi({ //yukarıdaki değişkenlerin zorunlu olduğunu belirtir.
    super.key,
    required this.modelIsmi,
    required this.parametreler,
    required this.boyut,
  });

  @override
  State<TahminSayfasi> createState() => _TahminSayfasiState();
}

class _TahminSayfasiState extends State<TahminSayfasi> { //TahminSayfasi'nın durumunu yöneten sınıf. Kullanıcı etkileşimleri ve hesaplamalar burada yapılır.
  final TextEditingController _ramController = TextEditingController(); //RAM miktarını girmek için.
  GpuModel? _secilenGpu; //Seçilen GPU modelini tutar. Başlangıçta null, kullanıcı bir GPU seçene kadar.
  int _gpuSayisi = 1; //Kullanıcının kaç GPU kullanacağını belirtir. Başlangıçta 1, kullanıcı artırabilir veya azaltabilir.
  String _secilenQuantization = 'Full (FP16)'; //Kullanıcının seçtiği quantization seviyesini tutar. Başlangıçta 'Full (FP16)', kullanıcı dropdown'dan seçim yapabilir.
  bool _sonucGosterilsin = false; //Hesaplama yapıldıktan sonra sonuçların gösterilip gösterilmeyeceğini kontrol eder. Başlangıçta false, hesaplama yapıldıktan sonra true yapılır.
  String _durumMetni = ''; //Modelin çalıştırılabilirlik durumunu tutar. Hesaplama yapıldıktan sonra 'Çalıştırılabilir' veya 'Çalıştırılamaz' gibi değerler alır.
  String _hizMetni = ''; //Modelin tahmini hızını tutar. Hesaplama yapıldıktan sonra 'X Token/s' formatında bir değer alır.
  String _detayMetni = ''; //Modelin çalıştırılabilirliği hakkında detaylı bilgi tutar. Hesaplama yapıldıktan sonra RAM ve VRAM durumunu açıklayan bir metin alır.
  bool _calistirabilir = false; //Modelin çalıştırılabilir olup olmadığını tutar. Hesaplama yapıldıktan sonra true veya false olur ve sonuçların renklerini belirlemek için kullanılır.
  bool _vramTasiyor = false; //Modelin VRAM'e sığıp sığmadığını tutar. Hesaplama yapıldıktan sonra true veya false olur ve sonuç detay metninde kullanılır.

  final Map<String, double> _quantizationCarplari = { //Quantization seviyeleri değişkenleri.
    'Q2': 0.17,
    'Q4': 0.30,
    'Q5': 0.45,
    'Q6': 0.50,
    'Q8': 0.60,
    'Full (FP16)': 1.0,
  };

  void _hesapla() { //Hesaplama fonksiyonu.
    if (_secilenGpu == null) { //Eğer kullanıcı bir GPU seçmemişse hata mesajı gösterir ve fonksiyondan çıkar.
      _gosterHata('Lütfen bir GPU seçin.');
      return;
    }

    final ramText = _ramController.text.trim(); //Kullanıcının RAM miktarını girdiği metin alanından değeri alır ve boşlukları temizler. Trim kodu burda sol ve sağ boşlukları siler.
    if (ramText.isEmpty) { //Eğer RAM miktarı girilmemişse hata mesajı gösterir ve fonksiyondan çıkar.
      _gosterHata('Lütfen RAM miktarını girin.');
      return;
    }

    final ram = double.tryParse(ramText); //Girilen RAM değerini ondalık sayıya çevirmeye çalışır. Eğer çevrilemezse null döner.
    if (ram == null || ram <= 0) { //Eğer RAM değeri geçerli bir sayı değilse veya sıfırdan küçükse hata mesajı gösterir ve fonksiyondan çıkar.
      _gosterHata('Lütfen geçerli bir RAM değeri girin.');
      return;
    }

    final quantCarpan = _quantizationCarplari[_secilenQuantization]!; //Seçilen quantizationa göre modeli kaçla çarpacağımızı belirler.
    final efektifBoyut = widget.boyut * quantCarpan; //Modelin quantizationa göre efektif boyutunu hesaplar.
    final toplamVram = _secilenGpu!.vram * _gpuSayisi; //Kaç GPU kullanıldığına göre toplam VRAM miktarını hesaplar.

    final ramYeterli = ram + toplamVram >= efektifBoyut; //Modelin çalıştırılabilmesi için RAM ve VRAM toplamının efektif model boyutuna eşit veya büyük olması gerekir. Bu değişken modelin çalıştırılabilir olup olmadığını belirler.

    if (!ramYeterli) { //RAM yeterli değilse modelin çalıştıralamayacağını belirtir , burda ramYeterlinin başındaki ünlem işareti , ramYeterli'nin false olduğu durumları kontrol eder.
      setState(() {
        _calistirabilir = false;
        _vramTasiyor = false;
        _durumMetni = 'Çalıştırılamaz';
        _hizMetni = '-';
        _detayMetni =
            'Yetersiz RAM. Model boyutu: ${efektifBoyut.toStringAsFixed(1)} GB ($_secilenQuantization), '
            'RAM: ${ram.toStringAsFixed(0)} GB.';
        _sonucGosterilsin = true;
      });
      return;
    }

    final vramYeterli = toplamVram >= efektifBoyut; //Modelin VRAM'e sığıp sığmadığını kontrol eder. Eğer toplam VRAM, efektif model boyutuna eşit veya büyükse VRAM yeterlidir.
    double tps = _secilenGpu!.hizCarpani * _gpuSayisi * (15000 / widget.parametreler);

    if (!vramYeterli) { //VRAM yeterli değilse model RAM'e taşınır ve hız yarıya düşer. Bu durumda tps'yi yarıya bölüyoruz.
      tps = tps / 2;
    }

    setState(() { //Hesaplama sonuçlarını ekrana yansıtmak için setState kullanılır. Bu, widget'ın yeniden çizilmesini sağlar ve kullanıcıya sonuçları gösterir.
      _calistirabilir = true; //Modelün çalıştırılabilir olduğunu belirtir.
      _vramTasiyor = !vramYeterli; //Model VRAM'e sığmıyorsa RAM'e taşınıyor demektir, bu yüzden vramYeterli'nin tersini alıyoruz.
      _durumMetni = 'Çalıştırılabilir'; //Modelün çalıştırılabilir olduğunu belirtir.
      _hizMetni = '${tps.toStringAsFixed(1)} Token/s'; //Hesaplanan hız metni formatlanır ve ekrana yansıtılır.
      if (_vramTasiyor) { //Model VRAM'e sığmıyorsa RAM'e taşınıyor ve hız yarıya düşüyor. Detay metni buna göre hazırlanır.
        _detayMetni =
            'Model VRAM\'e sığmıyor (${efektifBoyut.toStringAsFixed(1)} GB > ${toplamVram.toStringAsFixed(0)} GB VRAM). '
            'RAM\'e taşıyor, hız yarıya düşürüldü.';
      } else { //Model VRAM'e sığıyor, tam hızda çalışır. Detay metni buna göre hazırlanır.
        _detayMetni =
            'Model tamamen VRAM\'e sığıyor (${efektifBoyut.toStringAsFixed(1)} GB ≤ ${toplamVram.toStringAsFixed(0)} GB VRAM). '
            'Tam hız.';
      }
      _sonucGosterilsin = true; //Hesaplama yapıldıktan sonra sonuçların gösterilmesini sağlar. Bu değişken, sonuç kutusunun ekranda görünmesini kontrol eder.
    });
  }

  void _gosterHata(String mesaj) { //Hata mesajlarını göstermek için kullanılan fonksiyon. ScaffoldMessenger kullanarak ekranda geçici bir mesaj gösterir.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mesaj),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() { //Widget yok edilirken yapılacak işlemler. Burada RAM miktarını girdiğimiz TextEditingController'ı temizliyoruz.
    _ramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quantCarpan = _quantizationCarplari[_secilenQuantization]!; //Seçilen quantization seviyesine göre modeli kaçla çarpacağımızı belirler. Bu, modelin efektif boyutunu hesaplamak için kullanılır.
    final efektifBoyut = widget.boyut * quantCarpan; //Modelin quantizationa göre efektif boyutunu hesaplar. Bu, modelin çalıştırılabilirliğini değerlendirmek için kullanılır. Quantization seviyesi arttıkça model boyutu küçülür, bu yüzden quantCarpan'ı model boyutuyla çarparız.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Çalıştırabilir miyim?'), //AppBar, sayfanın üst kısmında başlık ve geri butonu gibi öğeleri barındırır. Burada sadece başlık var.
      ),
      body: SingleChildScrollView( //Sayfanın içeriği ekranı aşarsa kaydırma yapabilmek için kullanılır. Bu, özellikle mobil cihazlarda önemlidir.
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //Column içindeki elemanların sola hizalanmasını sağlar. Başlık ve diğer metinlerin sol tarafta hizalanması için kullanılır.
          children: [
            Container( //Model bilgilerini gösteren kutu. Model ismi, parametre sayısı ve boyutu gibi bilgileri içerir.
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4A6FA5).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column( //Model bilgilerini dikey olarak sıralamak için kullanılır. Model ismi, parametre sayısı ve boyutu gibi bilgileri içerir.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row( //Model ismi ve bilgi butonunu yatay olarak sıralamak için kullanılır. Model ismi solda, bilgi butonu sağda yer alır.
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF4A6FA5),
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded( //Model isminin uzunluğuna göre butonun sağa itilmesini sağlar. Model ismi uzun olsa bile buton her zaman sağda kalır.
                        child: Text(
                          '${widget.modelIsmi} için donanım uyumluluğunu kontrol edin.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A6FA5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildModelBilgiChip( //Model parametre sayısını ve boyutunu göstermek için kullanılan küçük etiketler. İkon, metin ve renk alır.
                        '${widget.parametreler.toStringAsFixed(0)}B Parametre',
                        const Color(0xFF6366F1),
                      ),
                      const SizedBox(width: 8),
                      _buildModelBilgiChip(
                        '${widget.boyut.toStringAsFixed(0)} GB (Orijinal)',
                        const Color(0xFFDB7C26),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text( //Donanım bilgileri başlığını gösterir.
              'Donanım Bilgileri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionLabel('Ekran Kartı (GPU)'), //GPU seçimi bölümünün başlığını gösterir.
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline( //DropdownButton'ın altındaki çizgiyi gizler, böylece daha temiz bir görünüm elde edilir.
                child: DropdownButton<GpuModel>( //GPU modellerini seçmek için kullanılan açılır menü. GpuModel tipinde değerler içerir.
                  isExpanded: true,
                  value: _secilenGpu,
                  hint: const Text(
                    'GPU seçin...',
                    style: TextStyle(color: Color(0xFFBFC5CE)),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF9CA3AF)),
                  items: gpuListesi.map((gpu) {
                    return DropdownMenuItem<GpuModel>( //GPU listesindeki her bir modeli açılır menü öğesine dönüştürür. GPU ismi ve ikonu gösterilir.
                      value: gpu,
                      child: Row(
                        children: [
                          const Icon(Icons.memory_outlined,
                              size: 18, color: Color(0xFF6B7280)),
                          const SizedBox(width: 10),
                          Text(
                            gpu.isim,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(), //GPU listesini açılır menü öğelerine dönüştürür ve liste olarak döner.
                  onChanged: (val) { //Kullanıcı bir GPU seçtiğinde ne yapılacağını belirler. Seçilen GPU'yu _secilenGpu değişkenine atar ve ekranı günceller.
                    setState(() {
                      _secilenGpu = val;
                    });
                  },
                ),
              ),
            ),
            if (_secilenGpu != null) ...[ //Eğer kullanıcı bir GPU seçmişse, seçilen GPU'nun VRAM miktarı ve hız çarpanı gibi bilgileri gösterir. Bu bilgiler, GPU'nun model çalıştırma performansını etkileyen önemli parametrelerdir.
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildGpuBilgiChip( //Seçilen GPU'nun VRAM miktarını göstermek için kullanılan küçük etiketler. İkon, metin ve renk alır.
                    '${_secilenGpu!.vram.toStringAsFixed(0)} GB VRAM',
                    const Color(0xFF4A6FA5),
                  ),
                  const SizedBox(width: 8),
                  _buildGpuBilgiChip( //Seçilen GPU'nun hız çarpanını göstermek için kullanılan küçük etiketler. İkon, metin ve renk alır.
                    '${_secilenGpu!.hizCarpani}x Hız',
                    const Color(0xFF5B8C5A),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),

            _buildSectionLabel('GPU Sayısı'), //GPU sayısı bölümünün başlığını gösterir.
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              child: Row(
                children: [
                  IconButton( //GPU sayısını azaltmak için kullanılan buton. GPU sayısı 1'den fazla ise çalışır, aksi halde devre dışı kalır.
                    onPressed: _gpuSayisi > 1 //GPU sayısı 1'den büyükse azaltma işlemi yapılır, değilse buton devre dışı kalır.
                        ? () => setState(() => _gpuSayisi--)
                        : null,
                    icon: const Icon(Icons.remove_rounded),
                    color: const Color(0xFF4A6FA5),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '$_gpuSayisi',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _gpuSayisi < 8
                        ? () => setState(() => _gpuSayisi++)
                        : null,
                    icon: const Icon(Icons.add_rounded),
                    color: const Color(0xFF4A6FA5),
                  ),
                ],
              ),
            ),
            if (_secilenGpu != null) ...[
              const SizedBox(height: 6),
              Text(
                'Toplam VRAM: ${(_secilenGpu!.vram * _gpuSayisi).toStringAsFixed(0)} GB',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 18),

            _buildSectionLabel('Quantization'), //Quantization seçimi bölümünün başlığını gösterir.
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1D5DB)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline( //DropdownButton'ın altındaki çizgiyi gizler, böylece daha temiz bir görünüm elde edilir.
                child: DropdownButton<String>( //Quantization seviyesini seçmek için kullanılan açılır menü. String tipinde değerler içerir.
                  isExpanded: true,
                  value: _secilenQuantization,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF9CA3AF)),
                  items: _quantizationCarplari.entries.map((entry) {
                    final boyutYuzde = (entry.value * 100).toStringAsFixed(0);
                    return DropdownMenuItem<String>( //Quantization seviyelerini açılır menü öğelerine dönüştürür. Quantization seviyesi ismi ve model boyutuna etkisi gösterilir.
                      value: entry.key,
                      child: Text(
                        '${entry.key}  —  %$boyutYuzde boyut',
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _secilenQuantization = val!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Efektif model boyutu: ${efektifBoyut.toStringAsFixed(1)} GB',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),

            _buildSectionLabel('RAM Miktarı (GB)'), //RAM miktarı giriş bölümünün başlığını gösterir.
            const SizedBox(height: 8),
            TextField(
              controller: _ramController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration( //RAM miktarını girmek için kullanılan metin alanı. Sadece sayısal giriş kabul eder ve ipucu metni içerir.
                hintText: 'Örn: 16, 32, 64',
                hintStyle: TextStyle(color: Color(0xFFBFC5CE)),
                prefixIcon:
                    Icon(Icons.storage_outlined, color: Color(0xFF9CA3AF)),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox( //Hesapla butonu. Kullanıcı bu butona tıkladığında modelin çalıştırılabilirliğini değerlendirmek için _hesapla fonksiyonu çağrılır.
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _hesapla, //Tıklandığında hesapla fonksiyonunu çağırır.
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Hesapla'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_sonucGosterilsin) //Sonuçların gösterilip gösterilmeyeceğini kontrol eder.
              Container( //Modelin çalıştırılabilirlik durumunu, tahmini hızını ve detaylı bilgileri gösteren kutu. Renkler ve ikonlar, modelin durumuna göre dinamik olarak değişir.
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Sonuçlar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSonucKutusu( //Modelün çalıştırılabilir durumunu göstermek için kullanılan kutu. İkon, metin ve renk alır.
                            'Model Durumu',
                            _durumMetni,
                            _calistirabilir
                                ? Icons.check_circle_outline_rounded
                                : Icons.cancel_outlined,
                            _calistirabilir
                                ? const Color(0xFF5B8C5A)
                                : const Color(0xFFDC6B6B),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSonucKutusu( //Modelün tahmini hızını göstermek için kullanılan kutu. İkon, metin ve renk alır.
                            'Tahmini Hız',
                            _hizMetni,
                            Icons.speed_rounded,
                            _calistirabilir
                                ? const Color(0xFF4A6FA5)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                    if (_vramTasiyor && _calistirabilir) ...[ //Model VRAM'e sığmıyor ve RAM'e taşınıyor durumunu göstermek için kullanılan kutu. İkon, metin ve renk alır. Bu durum, modelin çalıştırılabilir olduğunu ancak tam hızda çalışamayacağını belirtir.
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFD97706),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _detayMetni,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFD97706),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (_calistirabilir && !_vramTasiyor) ...[ //Model VRAM'e sığıyor ve tam hızda çalışıyor durumunu göstermek için kullanılan kutu. İkon, metin ve renk alır. Bu durum, modelin optimal performansla çalışabileceğini belirtir.
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Color(0xFF16A34A),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _detayMetni,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF16A34A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (!_calistirabilir) ...[ //Modelün çalıştırılamaz olduğunu göstermek için kullanılan kutu. İkon, metin ve renk alır. Bu durum, modelin mevcut donanım ve RAM konfigürasyonuyla çalıştırılamayacağını belirtir.
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF2F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.cancel_outlined,
                              color: Color(0xFFDC6B6B),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _detayMetni,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFDC6B6B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) { //Bölüm başlıklarını göstermek için kullanılan küçük widget. Metin alır ve belirli bir stil ile gösterir.
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6B7280),
      ),
    );
  }

  Widget _buildModelBilgiChip(String label, Color color) { //Model bilgilerini göstermek için kullanılan küçük etiketler. Metin ve renk alır, arka plan rengi metin rengine göre daha açık bir ton olarak ayarlanır.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildGpuBilgiChip(String label, Color color) { //GPU bilgilerini göstermek için kullanılan küçük etiketler. Metin ve renk alır, arka plan rengi metin rengine göre daha açık bir ton olarak ayarlanır.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSonucKutusu( //Sonuç kutularını göstermek için kullanılan küçük widget. Başlık, değer, ikon ve renk alır. Renk, modelin çalıştırılabilir durumuna göre dinamik olarak belirlenir.
    String baslik,
    String deger,
    IconData ikon,
    Color renk,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(ikon, color: renk, size: 28),
          const SizedBox(height: 10),
          Text(
            baslik,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            deger,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: renk,
            ),
          ),
        ],
      ),
    );
  }
}
