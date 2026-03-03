import { Component, OnDestroy, OnInit } from '@angular/core';
import {
  HijriDateDto,
  PrayerTimesDto,
  PrayerTimesResponseDto,
  PrayerTranslateMap,
} from 'src/services/prayer-times/models';
import { PrayerTimesService } from 'src/services/prayer-times/prayer-times.service';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  standalone: false,
})
export class HomePage implements OnInit, OnDestroy {
  data!: PrayerTimesResponseDto;
  timings: any;
  prayerTimes!: PrayerTimesDto[];
  gregorianDate: any;
  hijriDate!: HijriDateDto;
  remainingTime: string = '';
  private timer: any;
  items = [1, 2, 3, 4, 5, 6];

  constructor(private prayerService: PrayerTimesService) {
    this.calculatePrayerTimes();
  }

  calculatePrayerTimes() {
    this.prayerService
      .calculatePrayerTimes(new Date().toISOString(), 40.2186, 29.1945)
      .subscribe((data) => {
        this.data = data;
        console.log(this.data);
        this.prayerTimes = [
          data.fajr,
          data.sunrise,
          data.dhuhr,
          data.asr,
          data.maghrib,
          data.isha,
        ];
        // this.gregorianDate = this.data.date.gregorian;
        this.hijriDate = this.data.hijriDate;
        setTimeout(() => {
          this.initializePrayerCycle();
        });
      });
  }

  ngOnInit() {}

  getCurrentPrayer() {
    const now = new Date();

    // Eğer saat Fajr’dan küçükse → hala Yatsı vakti
    if (now < this.timeStringToDate(this.prayerTimes[0].time)) {
      return {
        currentPrayer: this.prayerTimes[4], // Isha
        nextPrayer: this.prayerTimes[0], // Fajr
      };
    }

    for (let i = 0; i < this.prayerTimes.length - 1; i++) {
      if (
        now >= this.timeStringToDate(this.prayerTimes[i].time) &&
        now < this.timeStringToDate(this.prayerTimes[i + 1].time)
      ) {
        return {
          currentPrayer: this.prayerTimes[i],
          nextPrayer: this.prayerTimes[i + 1],
        };
      }
    }

    return {
      currentPrayer: this.prayerTimes[4],
      nextPrayer: this.prayerTimes[0],
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

    let target = this.timeStringToDate(result.nextPrayer.time);

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

  timeStringToDate(time: string): Date {
    const [hour, minute] = time.split(':').map(Number);

    const date = new Date();
    date.setHours(hour, minute, 0, 0);

    return date;
  }

  ngOnDestroy() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  }
}
