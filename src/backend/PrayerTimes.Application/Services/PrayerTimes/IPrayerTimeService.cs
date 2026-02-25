namespace PrayerTimes.Application.Services.PrayerTimes;

public interface IPrayerTimeService
{
    Task<object?> GetPrayerTimes(double lat, double lng);
}
