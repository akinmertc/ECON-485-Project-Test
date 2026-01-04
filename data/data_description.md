# Data Description
## ECON485 Project: Tourism Statistics Exports

**Team:** ECON485 Project Group  
**Last Updated:** 2026-01-03

---

## Overview

Bu klasör, TÜİK ve Kültür/Turizm kaynaklı Excel dosyalarından dönüştürülen üç veri setinin UTF-8, virgül ayraclı CSV sürümlerini içerir. Türkçe karakterler ve satır içi satır sonları korunmuştur.

---

## Data Files

| File Name | Rows | Description | Date Range |
|-----------|------|-------------|------------|
| `data/csv_income_and_expenses.csv` | 34 | Turizm geliri, turizm gideri, gelen/çıkan ziyaretçi sayıları ve ortalama harcama (1000 $ ve $). | 2004-2025 (Ocak-Eylül 2025) |
| `data/Number_of_trips_and_nights_by_age_group_of_travelers.csv` | 15 | Yurt içi ziyaretçilerin yaş gruplarına göre seyahat/geceleme sayıları ve ortalama geceleme (III. Çeyrek, 2017-2018). | 2017-2018 Q3 |
| `data/2022.csv` | 824 | Belgelendirilmiş konaklama tesislerinde geliş, geceleme, ortalama kalış süresi ve doluluk oranı (yabancı/yerli/toplam), il ve ilçe bazında. | 2022 |

---

## Data Characteristics

### `csv_income_and_expenses.csv`
- Birden çok başlık satırı açıklama ve birim bilgisi içerir; veri satırları yıllara göre gelir/gider ve ortalama harcama metriklerini taşır.
- Kolonlar: Yıl, gelen ziyaretçi, çıkan ziyaretçi, turizm geliri (1000 $), transfer yolcu geliri, ortalama harcama ($), turizm gideri (1000 $), vatandaş harcaması ($) ve açıklama hücreleri.
- Sondaki satırlar kaynak ve dipnot bilgisidir; boş hücreler ayırıcı olarak bırakılmıştır.

### `Number_of_trips_and_nights_by_age_group_of_travelers.csv`
- Yaş grupları: 0-14, 15-24, 25-44, 45-64, 65+, Toplam; iki yıl (2017, 2018) için kırılım.
- Her yıl için seyahat sayısı (bin), geceleme sayısı (bin) ve ortalama geceleme sayısı sütunları bulunur.
- İlk satırlar iki dilli (TR/EN) başlıklar ve açıklamalardır; veri satırları başlık satırlarından sonra gelir.

### `2022.csv`
- İller ve bağlı ilçeler satır bazında; her il için “Toplam” satırı vardır.
- Kolonlar: İl, İlçe, tesislere geliş (yabancı/yerli/toplam), geceleme (yabancı/yerli/toplam), ortalama kalış süresi (gün) ve doluluk oranı (%) — yabancı, yerli ve toplam ayrı sütunlardır.
- İlk satır veri seti açıklaması, ikinci satır kolon başlıklarıdır; sayısal alanlar nokta (`.`) ondalık ayırıcısı kullanır.

---

## Loading Guidance

- Kodlama: UTF-8, alan ayırıcı `,`, satır sonu `\n`; boş hücreler korunmuştur.
- Çoklu başlık satırı içeren dosyalarda veri alırken ilk veri satırına kadar (ör. yıl veya il/ilçe başlayan satırlar) satırları atlayın.
- Sayıları işlerken string olarak okuyup uygun tipe dönüştürmek daha güvenlidir; nokta (`.`) ondalık ayırıcısı kullanılır.
- Örnek Python okuma:
  ```python
  import pandas as pd
  df_income = pd.read_csv("data/csv_income_and_expenses.csv", header=None)
  df_age = pd.read_csv("data/Number_of_trips_and_nights_by_age_group_of_travelers.csv", header=None)
  df_2022 = pd.read_csv("data/2022.csv", header=None)
  ```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 2026-01-03 | Excel kaynaklarının CSV'ye dönüştürülmesi ve açıklamaların güncellenmesi |
