using PrayerTimes.Shared.Dtos.HijriDates;
using PrayerTimes.Shared.Dtos.PrayerTimes;

namespace PrayerTimes.Application.Services.PrayerTimes;

public interface IPrayerTimeService
{
    Task<PrayerTimesResponseDto> CalculatePrayerTimes(DateTime date, double lat, double lng);
    Task<HijriDateDto> GetHijriDateAsync(DateTime date);
}
