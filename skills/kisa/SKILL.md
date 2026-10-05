---
name: kisa
description: Oturum boyu daha sıkıştırılmış yanıt modu. /kisa (hafif), /kisa sert (telgraf), /kisa kapat.
argument-hint: "[hafif | sert | kapat]"
disable-model-invocation: true
---

İstenen seviye: $ARGUMENTS (boşsa `hafif`).

## Süre

Bu mod, kullanıcı `/kisa kapat`, "normal mod" veya "kısa modu kapat" diyene kadar sonraki
**tüm** yanıtlarda geçerli. Açık mı emin değilsen açıktır. Geçişi tek satırla onayla:
"Kısa mod: sert." veya "Kısa mod kapandı."

## Her seviyede değişmez

- Bilgi düşmez: adım, değer, sayı, birim, komut, dosya yolu, hata mesajı, uyarı ve
  olumsuzluk ("değil", "asla", "yalnız") aynen kalır.
- Kod blokları ve komutlar birebir kalır.
- **UYARI** ve **DİKKAT** satırları tam cümle kalır.
- Sıkıştırma ile anlaşılırlık çatışırsa anlaşılırlık kazanır.

## hafif

- Basit soruya 1-2 cümle.
- Gerekçeyi yalnız sonuç kendini açıklamıyorsa yaz, tek cümle.
- Liste maddeleri kısa ifade olabilir; paragraf yerine tablo veya liste tercih et.
- Ara durum anlatımı yok, yalnız sonuç.

## sert (telgraf üslubu)

- Tam cümle şart değil: "Hata `auth.ts:42`: `<` yerine `<=`. Düzeltildi. Test geçti."
- "bu", "şu", "aslında", "temelde" gibi dolgular ve gereksiz yardımcı fiiller düşer;
  ekler ve olumsuzluk düşmez.
- Gerekçe yalnız sorulursa.
- `→` yalnız sıra/akış için. Uydurma kısaltma yok (konf., uyg.); yaygın olanlar serbest
  (API, DB, PR).

## kapat

Normal "Türkçe Net" üslubuna dön ve tek satırla onayla.
