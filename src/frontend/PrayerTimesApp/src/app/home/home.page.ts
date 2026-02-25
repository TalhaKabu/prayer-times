import { Component, OnInit } from '@angular/core';
import { PrayerTimesService } from 'src/services/prayer-times/prayer-times.service';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  standalone: false,
})
export class HomePage implements OnInit {
  prayerTimes: any;

  constructor(private prayerService: PrayerTimesService) {}

  ngOnInit() {
    // Örnek koordinat: Bursa
    this.prayerService.getPrayerTimes(40.1828, 29.0663).subscribe((data) => {
      this.prayerTimes = data.data.timings;
      console.log(this.prayerTimes);
    });
  }
}
