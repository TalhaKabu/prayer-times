using System.Globalization;

namespace PrayerTimes.Shared.Dtos.PrayerTimes;

public class PrayerTimesResponseDto
{
    public PrayerTimesDto Fajr { get; set; }
    public PrayerTimesDto Sunrise { get; set; }
    public PrayerTimesDto Dhuhr { get; set; }
    public PrayerTimesDto Asr { get; set; }
    public PrayerTimesDto Maghrib { get; set; }
    public PrayerTimesDto Isha { get; set; }
}

public class PrayerTimesDto
{
    public int Index { get; set; }
    public string Name { get; set; }
    public string Time { get; set; }
}
