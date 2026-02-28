import { Component, OnDestroy, OnInit } from '@angular/core';
import { PrayerTranslateMap } from 'src/services/prayer-times/models';
import { PrayerTimesService } from 'src/services/prayer-times/prayer-times.service';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  standalone: false,
})
export class HomePage implements OnInit, OnDestroy {
  data: any;
  prayerTimes: any;
  gregorianDate: any;
  hijriDate: any;
  remainingTime: string = '';
  private timer: any;

  constructor(private prayerService: PrayerTimesService) {}

  ngOnInit() {
    // Örnek koordinat: Bursa
    this.prayerService.getPrayerTimes(40.2186, 29.1945).subscribe((data) => {
      this.data = data.data;
      this.prayerTimes = this.data.timings;
      this.gregorianDate = this.data.date.gregorian;
      this.hijriDate = this.data.date.hijri;
      this.initializePrayerCycle();
    });
  }

  getCurrentPrayer() {
    const now = new Date();

    const prayers = [
      {
        name: 'Fajr',
        nameTr: 'Sabah',
        time: this.getTodayDateWithTime(this.prayerTimes.Fajr),
      },
      {
        name: 'Dhuhr',
        nameTr: 'Öğlen',
        time: this.getTodayDateWithTime(this.prayerTimes.Dhuhr),
      },
      {
        name: 'Asr',
        nameTr: 'İkindi',
        time: this.getTodayDateWithTime(this.prayerTimes.Asr),
      },
      {
        name: 'Maghrib',
        nameTr: 'Akşam',
        time: this.getTodayDateWithTime(this.prayerTimes.Maghrib),
      },
      {
        name: 'Isha',
        nameTr: 'Yatsı',
        time: this.getTodayDateWithTime(this.prayerTimes.Isha),
      },
    ];

    // Eğer saat Fajr’dan küçükse → hala Yatsı vakti
    if (now < prayers[0].time) {
      return {
        currentPrayer: prayers[4], // Isha
        nextPrayer: prayers[0], // Fajr
      };
    }

    for (let i = 0; i < prayers.length - 1; i++) {
      if (now >= prayers[i].time && now < prayers[i + 1].time) {
        return {
          currentPrayer: prayers[i],
          nextPrayer: prayers[i + 1],
        };
      }
    }

    return {
      currentPrayer: prayers[4],
      nextPrayer: prayers[0],
    };
  }

  getTodayDateWithTime(time: string): Date {
    const [hours, minutes] = time.split(':').map(Number);

    const now = new Date();
    return new Date(
      now.getFullYear(),
      now.getMonth(),
      now.getDate(),
      hours,
      minutes,
      0,
    );
  }

  initializePrayerCycle() {
    const result = this.getCurrentPrayer();

    let target = result.nextPrayer.time;

    if (target < new Date()) {
      target.setDate(target.getDate() + 1);
    }

    this.startCountdown(target);
  }

  startCountdown(targetDate: Date) {
    if (this.timer) {
      clearInterval(this.timer);
    }

    this.timer = setInterval(() => {
      const now = new Date().getTime();
      const target = targetDate.getTime();

      let diff = target - now;

      if (diff <= 0) {
        clearInterval(this.timer);

        // 🔥 Otomatik yeni vakti başlat
        this.initializePrayerCycle();
        return;
      }

      const hours = Math.floor(diff / (1000 * 60 * 60));
      diff %= 1000 * 60 * 60;

      const minutes = Math.floor(diff / (1000 * 60));
      diff %= 1000 * 60;

      const seconds = Math.floor(diff / 1000);

      this.remainingTime =
        `${hours.toString().padStart(2, '0')}:` +
        `${minutes.toString().padStart(2, '0')}:` +
        `${seconds.toString().padStart(2, '0')}`;
    }, 1000);
  }

  getPrayerName(enName: string) {
    return PrayerTranslateMap[enName] || enName;
  }

  ngOnDestroy() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  }
}
