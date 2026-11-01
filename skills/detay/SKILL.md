---
name: detay
description: Önceki yanıtın yalnız istenen kısmını derinleştirir (neden, adım adım, örnek). Tek yanıtlık.
argument-hint: "[hangi kısım: madde no, başlık veya konu]"
disable-model-invocation: true
---

Kullanıcı önceki yanıtının bir kısmının daha ayrıntılı anlatılmasını istiyor.

Genişletilecek kısım: $ARGUMENTS

## Kurallar

1. **Yalnız bu kısmı genişlet.** Önceki yanıtın geri kalanını tekrar yazma, baştan özetleme.
2. Kısım belirtilmemişse yeni içerik yazma: son yanıttaki bölümleri numaralı listele
   (her biri tek satır) ve "Hangisini açayım?" diye sor.
3. Yapı, bölüm arşivinden ve gerekmeyeni atlayarak:
   1. `### 🧭 Genel bakış`: bir cümleyle ne olduğu ve neden böyle olduğu.
   2. `### 📋 Ayrıntılar`: nasıl, numaralı adımlar.
   3. `### 💡 Örnek`: kod, komut, sayı veya gerçek bir senaryo.
   4. `### 🧒 Basitçe`: konu ağırsa benzetmeyle 2-4 cümle.
   5. `### ⚠️ Dikkat`: sık hata ve sınırlar.
   6. `### 📌 Özet`: 2-3 cümle, anahtar kelimeler kalın.
4. Yeni terimi ilk geçtiği yerde parantez içinde kısa tanımla.
5. Temel kural geçerli: bilgi düşmez, ama dolgu da eklenmez. Ayrıntı ≠ uzatma.
6. ~60 satırı aşacaksa HTML sayfa kuralını uygula.
7. Bu mod tek yanıtlıktır. Sonraki yanıtta normal üsluba (veya açıksa `/kisa` moduna) dön.
