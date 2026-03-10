using PrayerTimes.Shared.Dtos.HijriDates;
using PrayerTimes.Shared.Dtos.PrayerTimes;
using System.Text.Json.Serialization;

namespace PrayerTimes.Application.Helpers.HijriCalender;

public static class HijriCalenderHelper
{
    public static HijriDateDto GetHijriDate(DateTime date)
    {
        var path = Path.Combine(Directory.GetCurrentDirectory(), "ImportantHijriDatesJsons", $"hijriDates{date.Year}.json");

        if (!File.Exists(path))
            throw new FileNotFoundException();

        var json = File.ReadAllText(path);

        var list = (Newtonsoft.Json.JsonConvert.DeserializeObject<List<HijriDateJsonDto>>(json))!.OrderBy(x => x.MiladiDate).ToList();

        var hijriDate = list.Find(x => x.MiladiDate.Equals(date.Date));

        if (hijriDate is not null)
        {
            return new HijriDateDto
            {
                Year = hijriDate.HijriYear,
                Month = 0,
                Day = hijriDate.HijriDay,
                Display = $"{hijriDate.HijriDay} {hijriDate.HijriMonth} {hijriDate.HijriYear}"
            };
        }
        else
        {
            //var ls = list.FindAll(x => x.Miladi Date.Month.Equals(date.Month));


        }

        var hijri = new System.Globalization.HijriCalendar();
        int year = hijri.GetYear(date);
        int month = hijri.GetMonth(date);
        int day = hijri.GetDayOfMonth(date);
        return new HijriDateDto
        {
            Year = year,
            Month = month,
            Day = day,
            Display = $"{day} {GetMonthName(month)} {year}"
        };
    }

    private static readonly string[] TurkishHijriMonths =
    {
         "",
         "Muharrem",
         "Safer",
         "Rebiülevvel",
         "Rebiülahir",
         "Cemaziyelevvel",
         "Cemaziyelahir",
         "Recep",
         "Şaban",
         "Ramazan",
         "Şevval",
         "Zilkade",
         "Zilhicce"
     };

    private static string GetMonthName(int month)
    {
        if (month < 1 || month > 12)
            return "";

        return TurkishHijriMonths[month];
    }
}
