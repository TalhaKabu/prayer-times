using PrayerTimes.Application.Helpers.HijriCalender;
using PrayerTimes.Shared.Dtos.PrayerTimes;

namespace PrayerTimes.Application.Helpers.PrayerTimesCalculater;

public static class PrayerTimeHelper
{
    private const double Deg2Rad = Math.PI / 180;
    private const double Rad2Deg = 180 / Math.PI;
    private const double FajrAngle = -18;
    private const double SunriseAngle = -0.833;
    private const double IshaAngle = -17;
    private const double TimeZone = 3;

    public static PrayerTimesResponseDto Calculate(double lat, double lng, DateTime date)
    {
        date = new DateTime(date.Year, date.Month, date.Day, 12, 0, 0);
        
        double jd = JulianDay(date);
        double n = jd - 2451545.0;

        double decl = SunDeclination(n);
        double eqTime = EquationOfTime(n);

        double dhuhr = 12
                     + TimeZone
                     - lng / 15
                     - eqTime;

        double fajr = dhuhr - HourAngle(lat, decl, FajrAngle) / 15;
        double sunrise = dhuhr - HourAngle(lat, decl, SunriseAngle) / 15;

        double asr = dhuhr + AsrAngle(lat, decl) / 15;

        double sunset = dhuhr + HourAngle(lat, decl, SunriseAngle) / 15;
        double isha = dhuhr + HourAngle(lat, decl, IshaAngle) / 15;

        return new PrayerTimesResponseDto
        {
            Fajr = new PrayerTimesDto { Index = 0, Name = "Sabah", Time = ToTimeString(date, fajr + 0.2 / 60) },
            Sunrise = new PrayerTimesDto { Index = 1, Name = "Güneş", Time = ToTimeString(date, sunrise - 7.0 / 60) },
            Dhuhr = new PrayerTimesDto { Index = 2, Name = "Öğlen", Time = ToTimeString(date, dhuhr + 5.0 / 60) },
            Asr = new PrayerTimesDto { Index = 3, Name = "İkindi", Time = ToTimeString(date, asr + 4.0 / 60) },
            Maghrib = new PrayerTimesDto { Index = 4, Name = "Akşam", Time = ToTimeString(date, sunset + 7.0 / 60) },
            Isha = new PrayerTimesDto { Index = 5, Name = "Yatsı", Time = ToTimeString(date, isha + 0.1 / 60) }
        };
    }

    private static double JulianDay(DateTime date)
    {
        int Y = date.Year;
        int M = date.Month;
        int D = date.Day;

        if (M <= 2)
        {
            Y -= 1;
            M += 12;
        }

        int A = Y / 100;
        int B = 2 - A + A / 4;

        return Math.Floor(365.25 * (Y + 4716))
             + Math.Floor(30.6001 * (M + 1))
             + D + B - 1524.5;
    }

    private static double SunDeclination(double day)
    {
        double g = Deg2Rad * (357.529 + 0.98560028 * day);

        double L = Deg2Rad * (280.459
            + 0.98564736 * day
            + 1.915 * Math.Sin(g)
            + 0.020 * Math.Sin(2 * g));

        return Rad2Deg * Math.Asin(
            Math.Sin(23.44 * Deg2Rad) * Math.Sin(L));
    }

    private static double EquationOfTime(double day)
    {
        double g = Deg2Rad * (357.529 + 0.98560028 * day);

        double q = 280.459 + 0.98564736 * day;

        double L = Deg2Rad * (q
            + 1.915 * Math.Sin(g)
            + 0.020 * Math.Sin(2 * g));

        double RA = Rad2Deg * Math.Atan2(
            Math.Cos(23.44 * Deg2Rad) * Math.Sin(L),
            Math.Cos(L));

        return (q / 15 - RA / 15) + 0.0008 * Math.Sin(2 * Math.PI * day / 365);
    }

    private static double HourAngle(double lat, double decl, double angle)
    {
        double latRad = lat * Deg2Rad;
        double declRad = decl * Deg2Rad;
        double angleRad = angle * Deg2Rad;

        double cosH =
            (Math.Sin(angleRad)
            - Math.Sin(latRad) * Math.Sin(declRad))
            /
            (Math.Cos(latRad) * Math.Cos(declRad));

        cosH = Math.Clamp(cosH, -1, 1);

        return Math.Acos(cosH) * Rad2Deg;
    }

    private static double AsrAngle(double lat, double decl)
    {
        double latRad = lat * Deg2Rad;
        double declRad = decl * Deg2Rad;

        double shadow = Math.Abs(Math.Tan(latRad - declRad));

        shadow += 1; // Hanafi Turkey standard

        double angle = Math.Atan(1.0 / shadow);

        double H = Math.Acos(
            (Math.Sin(angle) - Math.Sin(latRad) * Math.Sin(declRad)) /
            (Math.Cos(latRad) * Math.Cos(declRad))
        );

        return H * Rad2Deg;
    }

    private static string ToTimeString(DateTime baseDate, double hour)
    {
        hour = (hour % 24 + 24) % 24;

        var dt = baseDate.Date.AddHours(hour);

        int totalSeconds = (int)Math.Round(dt.TimeOfDay.TotalSeconds / 60.0) * 60;

        dt = dt.Date.AddSeconds(totalSeconds);

        return dt.ToString("HH:mm");
    }
}


