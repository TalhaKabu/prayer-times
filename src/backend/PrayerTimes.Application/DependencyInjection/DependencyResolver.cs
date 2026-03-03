using Microsoft.Extensions.DependencyInjection;
using PrayerTimes.Application.Services.PrayerTimes;

namespace PrayerTimes.Application.DependencyInjection;

public static class DependencyResolver
{
    public static void Resolve(this IServiceCollection services)
    {

        services
            .AddMemoryCache()

            .AddSingleton<IPrayerTimeService, PrayerTimeManager>();
    }
}
