import { Injectable } from '@angular/core';
import { HttpService } from '../http.service';
import { map, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class PrayerTimesService {
  constructor(private http: HttpService) {}

  private baseUrl = 'PrayerTimes';

  getPrayerTimes(lat: number, lng: number): Observable<any> {
    return this.http
      .get<any>(`${this.baseUrl}`, { lat: lat, lng: lng })
      .pipe(map((res) => res.data));
  }
}
