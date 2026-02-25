import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ApiResponse } from './api-response';
import { environment } from 'src/environments/environment.prod';

@Injectable({
  providedIn: 'root',
})
export class HttpService {
  private readonly baseUrl = environment.baseUrl;

  constructor(private http: HttpClient) {}

  get<T>(url: string, params?: any) {
    return this.http.get<ApiResponse<T>>(`${this.baseUrl}/api/${url}`, { params });
  }

  post<T>(url: string, body: any) {
    return this.http.post<ApiResponse<T>>(`${this.baseUrl}/api/${url}`, body);
  }

  put<T>(url: string, body: any) {
    return this.http.put<ApiResponse<T>>(`${this.baseUrl}/api/${url}`, body);
  }
}
