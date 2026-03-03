namespace PrayerTimes.Shared.Dtos.HijriDates;

public class HijriDateJsonDto
{
    public int HijriDay { get; set; }
    public string HijriMonth { get; set; }
    public int HijriYear { get; set; }
    public DateTime MiladiDate { get; set; }
    public string Weekday { get; set; }
    public string Event { get; set; }
}
