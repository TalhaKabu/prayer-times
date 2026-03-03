import { Injectable } from '@angular/core';
import { HttpService } from '../http.service';
import { map, Observable } from 'rxjs';
import { ApiResponse } from '../api-response';
import { PrayerTimesDto, PrayerTimesResponseDto } from './models';

@Injectable({
  providedIn: 'root',
})
export class PrayerTimesService {
  constructor(private http: HttpService) {}

  private baseUrl = 'PrayerTimes';

  calculatePrayerTimes(
    date: string,
    lat: number,
    lng: number,
  ): Observable<PrayerTimesResponseDto> {
    return this.http
      .get<PrayerTimesResponseDto>(`${this.baseUrl}` + '/calculate', {
        date: date,
        lat: lat,
        lng: lng,
      })
      .pipe(map((res) => res.data));
  }
}
