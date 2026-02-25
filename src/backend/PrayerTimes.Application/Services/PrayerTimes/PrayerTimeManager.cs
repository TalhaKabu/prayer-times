
using Microsoft.Extensions.Caching.Memory;
using System.Net.Http.Json;

namespace PrayerTimes.Application.Services.PrayerTimes;

public class PrayerTimeManager(HttpClient httpClient, IMemoryCache cache) : IPrayerTimeService
{
    private readonly HttpClient _httpClient = httpClient;
    private readonly IMemoryCache _cache = cache;

    public async Task<object?> GetPrayerTimes(double lat, double lng)
    {
        var cacheKey = $"prayer-{lat}-{lng}";

        if (_cache.TryGetValue(cacheKey, out object? cached))
            return cached;

        var url = string.Format(
            "https://api.aladhan.com/v1/timings?latitude={0}&longitude={1}&method=13",
            lat.ToString(System.Globalization.CultureInfo.InvariantCulture),
            lng.ToString(System.Globalization.CultureInfo.InvariantCulture)
        );

        var result = await _httpClient.GetFromJsonAsync<object>(url);

        _cache.Set(cacheKey, result, TimeSpan.FromMinutes(30));

        return await _httpClient.GetFromJsonAsync<object>(url);
    }
}
