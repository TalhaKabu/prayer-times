
using Microsoft.Extensions.Caching.Memory;
using PrayerTimes.Application.Helpers.HijriCalender;
using PrayerTimes.Application.Helpers.PrayerTimesCalculater;
using PrayerTimes.Shared.Dtos.HijriDates;
using PrayerTimes.Shared.Dtos.PrayerTimes;

namespace PrayerTimes.Application.Services.PrayerTimes;

public class PrayerTimeManager(IMemoryCache cache) : IPrayerTimeService
{
    private readonly IMemoryCache _cache = cache;

    public async Task<PrayerTimesResponseDto> CalculatePrayerTimes(DateTime date, double lat, double lng)
    {
        date = date.ToLocalTime();

        var cacheKey = $"prayer-{date:yyyy-MM-dd}-{lat}-{lng}";

        if (_cache.TryGetValue(cacheKey, out PrayerTimesResponseDto? cached))
            return cached;

        var result = PrayerTimeHelper.Calculate(
            lat: lat,
            lng: lng,
            date: date);

        _cache.Set(cacheKey, result, TimeSpan.FromMinutes(30));

        return result;
    }

    public async Task<HijriDateDto> GetHijriDateAsync(DateTime date)
    {
        return HijriCalenderHelper.GetHijriDate(date);
    }
}
