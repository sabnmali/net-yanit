# Test sonuçları (5 Ekim 2026)

**Kurulum:** Model Claude Sonnet 5, her koşulda tek çalıştırma. "Normal" koşulda stil yok. "net-yanit" koşulunda `output-styles/turkce-net.md` sistem talimatı olarak verildi.
Token sayısı yaklaşıktır (karakter / 3).

**DİKKAT:** Her koşul bir kez çalıştırıldı. Modelin kendi çeşitliliği de sonuca karışıyor. Sayıları yön göstergesi olarak oku, kesin ölçüm değil.

## Özet tablo

| Görev | Normal | net-yanit v1 | net-yanit v2 (gevşetilmiş) |
|---|---|---|---|
| 1. Kod değişikliği raporu (diff) | ~1130 token, 41 satır | ~975 (−14%) | ~1000 (−12%) |
| 2. Karar tavsiyesi (SSD mi NAS mı) | ~750, 26 satır | ~565 (−25%) | ~680 (−10%) |
| 3. Kavram açıklaması (prompt caching) | ~780, 32 satır | ~700 (−11%) | v1 ile aynı kural, tekrar edilmedi |

Asıl kazanç uzunlukta değil, **yapıda**:
- Sonuç ilk satırda.
- Karşılaştırma tabloya dönüşüyor.
- Riskler **UYARI** / **DİKKAT** etiketiyle göze çarpıyor.
- Rapor "Ne değişti → Neden → Etkisi → Sıradaki adım" sırasında.

## Bilgi kaybı kontrolü

Önce normal yanıttaki önemli olgular listelendi. Sonra her birinin net-yanit yanıtında olup olmadığına bakıldı.

| Görev | v1'de düşen bilgi | v2'de durum |
|---|---|---|
| 1 | Down (geri alma) migration yok · migration koddan **önce** çalışmalı · 10 sn varsayılan timeout'un yavaş uçları düşürme riski | İlk ikisi geri geldi. Timeout riski yine yok, ama "eski 30 sn'den uzun" bilgisi var. Normal yanıtta olmayan 3 yeni bilgi eklendi: `except Timeout` yakalayan kodun kırılması, tablo kilidi, geri dönüş yolu. |
| 2 | "NAS ne zaman mantıklı" · DRAM'siz/düşük sürekli yazmalı SSD'den kaçın · 3-2-1 yedek kuralı | İlk ikisi geri geldi. 3-2-1 kuralı ve "kaç saatlik görüntü sığar" hesabı düştü, ama yedek uyarısı **UYARI** olarak duruyor. |
| 3 | `/compact` ve `/clear` sonrası önbelleğin yeniden kurulduğu bilgisi öneri olarak verildi, bozulma nedeni olarak verilmedi | Önemli bilgi düşmedi. Normal yanıtta olmayan "en düşük cache boyutu" bilgisi eklendi. |

**Yapılan düzeltme (v1 → v2):** Stile şu kural eklendi: "Yazmadan önce olguları listele: riskler, sayılar, koşullar, kullanıcının yapması gerekenler, alternatifin ne zaman mantıklı olduğu. Bunları atma. Eksik yanıt, uzun yanıttan kötüdür." Rapor şablonuna da "sıra önemliyse sırayı yaz, geri dönüş yolunu belirt" eklendi.

## Sonuç

- Kısalma %10-14 civarında.
- Kalan küçük kayıplar ayrıntı düzeyinde: bir hesaplama, bir kural adı. Bunları `/detay` ile isteyebilirsin.
- Kritik uyarı, adım ya da komut düşmedi.
