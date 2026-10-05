# net-yanit

**Claude için Türkçe "net yanıt" sistemi.** Önce sonucu yazar, bilgi düşürmeden kısa tutar. Uzun içeriği HTML sayfaya taşır.
Claude Code (plugin) ve claude.ai (web, mobil, masaüstü) için.

> İngilizce için [caveman](https://github.com/JuliusBrussee/caveman) ne ise, Türkçe için o.
> Farkı şu: amaç token kısmak değil, **anlaşılırlık**. Kısaltma kelimeden yapılır, bilgiden yapılmaz.

## Önce / sonra

Soru: *"8000 TL'ye 2 TB harici NVMe SSD mi, 2 yuvalı NAS mı? (4K kurgu, tek kişi, Thunderbolt 4, gigabit ağ)"*

| Normal | net-yanit |
|---|---|
| Sonuç cümlesinden sonra 5 başlık altında paragraflar. Her bilgi var, ama karşılaştırma metnin içine dağılmış. | İlk satırda karar ("2 TB harici NVMe SSD al"), ardından 5 satırlık karşılaştırma tablosu. Yedek riski **UYARI**, satın alma kriterleri **DİKKAT** etiketiyle. "NAS ne zaman mantıklı" tek satırda. Sonda **Sıradaki adım** var. |
| ~750 token | ~680 token |

Üç görevlik test ve bilgi kaybı kontrolü: [docs/test-sonuclari.md](docs/test-sonuclari.md)

## Ne yapar

| Kural | Açıklama |
|---|---|
| Sonuç önce | İlk cümle cevaptır. Girizgâh, soruyu tekrar etme, sonda özet bloğu yok. |
| Bilgi düşmez | Adım, değer, sayı, birim, komut, risk, koşul ve olumsuzluk ("değil", "asla") her zaman kalır. |
| Doğru biçim | Karşılaştırma tablo, sıralı iş numaralı liste, akış diyagram olur. ~40 satırı aşan içerik HTML sayfaya gider. |
| Rapor şablonu | Ne değişti → Neden → Etkisi → Sıradaki adım |
| Kapalı uçlu sorular | Senden bilgi isterken numaralı ve seçenekli sorar, en fazla 4 soru. |
| Etiketler | **UYARI** (veri kaybı/zarar), **DİKKAT** (hata riski), **NOT** (ek bilgi) |
| Sade Türkçe | Yaygın karşılığı olan terim Türkçe yazılır, olmayan İngilizce kalır. Karşılık uydurulmaz. |

## Komutlar

| Komut | Ne yapar | Süre |
|---|---|---|
| *(her zaman açık)* | Yukarıdaki kurallar | Oturum boyu |
| `/detay <kısım>` | Önceki yanıtın **yalnız** o kısmını açar: neden, adımlar, örnek. Kısım verilmezse hangisini açacağını sorar. | Tek yanıt |
| `/kisa` | Hafif sıkıştırma | Kapatana kadar |
| `/kisa sert` | Telgraf üslubu. Bilgi yine düşmez. | Kapatana kadar |
| `/kisa kapat` | Normal üsluba döner | — |

claude.ai'de slash komutu yok. Aynı şeyi düz yazıyla istersin: `detay: 3. madde`, `kısa mod`, `sert kısa`, `normal mod`.

## Kurulum

### Claude Code (her bilgisayarda)

```bash
claude plugin marketplace add sabnmali/net-yanit
```

```bash
claude plugin install net-yanit@net-yanit
```

Claude Code'u yeniden başlat. Stil kendiliğinden açılır (`force-for-plugin`). Kapatmak istersen:

```bash
claude plugin disable net-yanit@net-yanit
```

### claude.ai (web, mobil, masaüstü)

1. [Releases](https://github.com/sabnmali/net-yanit/releases) sayfasından `net-yanit.zip` dosyasını indir. İstersen kendin de üretebilirsin: `scripts/zip-olustur.ps1`.
2. claude.ai → **Settings → Capabilities** altında *Code execution* açık olmalı.
3. claude.ai → **Customize → Skills** → **+** → **Upload a skill** → zip'i seç.
4. [claudeai/profil-metni.md](claudeai/profil-metni.md) içindeki metni **Settings → Profile** altındaki kişisel tercihler alanına yapıştır.

**NOT:** claude.ai'ye yüklenen skill'ler aynı hesapla açılan Claude Code oturumlarına ve bulut oturumlarına (claude.ai/code) da kendiliğinden gelir.

### Claude Code bulut oturumları (claude.ai/code)

Bulut oturumları kişisel plugin ve stilleri yüklemez ([doküman](https://code.claude.com/docs/en/cloud-environments#what-carries-over-from-your-setup)). Önerilen iki yol:

- claude.ai'ye zip'i yükle. Skill bulut oturumuna kendiliğinden gelir.
- Her zaman açık stil istediğin repoda `output-styles/turkce-net.md` dosyasını `.claude/output-styles/` altına kopyala. Ardından o reponun `.claude/settings.json` dosyasına `"outputStyle": "Türkçe Net"` ekle ve commit'le.

## Dosya düzeni

```text
.claude-plugin/        plugin.json + marketplace.json
output-styles/         turkce-net.md  → her zaman açık kurallar (Claude Code)
skills/detay/          /detay
skills/kisa/           /kisa
claudeai/net-yanit/    claude.ai'ye yüklenen tek skill (detay + kısa mod + kurallar)
claudeai/profil-metni.md  claude.ai Profile'a yapıştırılacak metin
scripts/zip-olustur.ps1   claude.ai zip'ini üretir
docs/                  test sonuçları, token maliyeti
```

## Neden böyle tasarlandı

- **Katı kural bilgi kaybettirir.** Bir deneyde Claude'a resmi ASD-STE100 standardı dayatıldı. Sonuç: kodla ilgili bilgilerin %46,8'i düştü. Gevşek "sade teknik dil" isteğinde kayıp %8,5'te kaldı ([daily.dev](https://daily.dev/posts/explain-to-me-in-simple-technical-english-jcs3quoze)). Bu yüzden net-yanit'te kelime sözlüğü ya da madde sınırı yok. Sınır yalnız bilgiyi korumak için var.
- **caveman'dan alınanlar:** önce sonuç; olumsuzluk, sayı ve kod birebir kalır; oturum boyu açık kalan kısa mod. Türkçede artikel olmadığı için "artikel at" kuralı yerine dolgu kelimeleri atılıyor.
- **Uzun içerik HTML'e:** Anthropic'ten Thariq Shihipar'ın "The unreasonable effectiveness of HTML" yazısındaki gözleme dayanıyor: uzun Markdown pek okunmuyor, HTML'de sekme, içindekiler ve katlanır bölüm kullanılabiliyor.
- **Neden output style:** Claude Code'da her yanıtın biçimini belirlemenin resmi yolu bu. Her istekte gider ve önbelleğe alınır. Ayrıntı: [output styles](https://code.claude.com/docs/en/output-styles).

## Token maliyeti

[docs/token-maliyeti.md](docs/token-maliyeti.md)

## Güvenlik

Repoda hiçbir anahtar, token, `.env` ya da kişisel veri yok. Plugin yalnız Markdown talimatları içerir. Hook, MCP sunucusu ya da çalıştırılabilir dosya yok.

## English

`net-yanit` is a Turkish answer-style plugin for Claude Code, plus a skill pack for claude.ai. It works like caveman, but it optimizes for clarity rather than for token count. Answers lead with the result and never drop steps, values or warnings. Long output goes to an HTML page. `/detay` expands one part of the last answer. `/kisa` compresses the answers that follow.

## Lisans

MIT
