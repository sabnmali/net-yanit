# Token maliyeti

**NOT:** Rakamlar yaklaşıktır, karakter / 3 ile hesaplandı. Hesap şu fiyat oranlarına göre yapıldı:

| Kalem | Fiyat (tam girdi = 1) |
|---|---|
| Çıktı token'ı | 5 |
| Önbellekten (cache) okunan girdi | 0,1 |
| Önbelleğe ilk yazılan girdi | 1,25 |

Pro/Max abonelikte para yerine kullanım limiti harcanır, ama oranların yönü aynıdır.

## Sistemin sabit maliyeti

| Parça | Boyut | Ne zaman yüklenir |
|---|---|---|
| Output style (`turkce-net.md`) | ~1.200 token | Claude Code'da her istekte. Önbellekte olduğu için ilk istekten sonra ~120 birim/istek. |
| `/detay`, `/kisa` | ~370 / ~480 token | Yalnız çağırınca. `disable-model-invocation` sayesinde kullanılmadığında **0**. Çağrıldıktan sonra oturumda kalır. |
| claude.ai skill açıklaması | ~150 token | Her sohbette (skill listesi) |
| claude.ai skill gövdesi | ~1.100 token | Yalnız "detay" ya da "kısa mod" gibi tetikleyicide |
| claude.ai Profile metni | ~340 token | claude.ai'de her mesajda |

## Senaryo karşılaştırması

**Varsayım:** Claude Code'da soru anındaki bağlam ~20.000 token (sistem talimatı, araçlar, geçmiş). Diğer değerler:
- Detaylı yanıt: 1.500 token
- Kısa yanıt: 600 token
- Bir kısmın detayı: 500 token
- Tamamın detayı: 1.500 token

| Senaryo | Çıktı | Ek girdi (2. tur) | Toplam birim (önbellek sıcak) | Toplam birim (önbellek soğuk) |
|---|---|---|---|---|
| **A:** Doğrudan detaylı yanıt | 1.500 | — | **~7.500** | ~7.500 |
| **B:** Kısa yanıt + `/detay` ile bir kısım | 600 + 500 | ~21.000 | **~8.000** | ~31.000 |
| **C:** Kısa yanıt + `/detay` ile tamamı | 600 + 1.500 | ~21.000 | **~13.000** | ~36.500 |
| **D:** Yalnız kısa yanıt (yetti) | 600 | — | **~3.000** | ~3.000 |

"Soğuk" önbellek şu demek: iki mesaj arasında önbellek süresi (5 dk ya da 1 saat) dolmuş. Bu durumda bağlamın tamamı yeniden yazılır.

## Ne zaman hangisi ucuz

- **B, A'dan pahalı olur:**
  - İkinci tur bütün bağlamı yeniden okutur. Claude Code'da bu, önbellek sıcakken bile ~2.000-2.500 birim tutar.
  - Önbellek soğuksa ~25.000 birim tutar.
  - Bu yüzden Claude Code'da B, A'ya ancak başa baş gelir.
- **B'nin asıl kazancı D senaryosunda.** Çoğu soruda kısa yanıt yeter ve `/detay`'a hiç gerek kalmaz. Yanıtların yarısında kısa yetiyorsa ortalama maliyet A'nın altına düşer.
- **C her zaman A'dan pahalıdır.** Bütün yanıtın ayrıntısını istiyorsan baştan "detaylı anlat" de.
- **claude.ai'de** bağlam genelde çok daha küçüktür (birkaç bin token). Orada B'nin ikinci tur maliyeti düşük kalır.

## Pratik kural

1. Ayrıntı isteyeceğini biliyorsan soruyu baştan "detaylı" diye sor (A).
2. Bilmiyorsan kısa yanıt al (D). Gerekirse `/detay` ile **yalnız bir kısmı** aç (B).
3. İki mesaj arasında uzun ara verme. Önbellek soğursa ikinci tur pahalanır.
