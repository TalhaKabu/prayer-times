export const PrayerTranslateMap: any = {
  Fajr: 'İmsak',
  Sunrise: 'Güneş',
  Dhuhr: 'Öğle',
  Asr: 'İkindi',
  Maghrib: 'Akşam',
  Isha: 'Yatsı',

  Sunday: 'Pazar',
  Monday: 'Pazartesi',
  Tuesday: 'Salı',
  Wednesday: 'Çarşamba',
  Thursday: 'Perşembe',
  Friday: 'Cuma',
  Saturday: 'Cumartesi',

  January: 'Ocak',
  February: 'Şubat',
  March: 'Mart',
  April: 'Nisan',
  May: 'Mayıs',
  June: 'Haziran',
  July: 'Temmuz',
  August: 'Ağustos',
  September: 'Eylül',
  October: 'Ekim',
  November: 'Kasım',
  December: 'Aralık',

  1: 'Muharrem',
  2: 'Safer',
  3: 'Rebiülevvel',
  4: 'Rebiülahir',
  5: 'Cemaziyelevvel',
  6: 'Cemaziyelahir',
  7: 'Recep',
  8: 'Şaban',
  9: 'Ramazan',
  10: 'Şevval',
  11: 'Zilkade',
  12: 'Zilhicce',
};

export interface PrayerTimesResponseDto {
  hijriDate: HijriDateDto;
  fajr: PrayerTimesDto;
  sunrise: PrayerTimesDto;
  dhuhr: PrayerTimesDto;
  asr: PrayerTimesDto;
  maghrib: PrayerTimesDto;
  isha: PrayerTimesDto;
}

export interface PrayerTimesDto {
  index: number;
  name: string;
  time: string;
}

export interface HijriDateDto {
  year: number;
  month: number;
  day: number;
  display: string;
}
