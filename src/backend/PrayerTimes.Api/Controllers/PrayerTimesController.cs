using Microsoft.AspNetCore.Mvc;
using PrayerTimes.Application.Services.PrayerTimes;
using PrayerTimes.Shared.Dtos.General;
using PrayerTimes.Shared.Dtos.PrayerTimes;

namespace PrayerTimes.Api.Controllers;


[ApiController]
[Route("api/[controller]")]
public class PrayerTimesController(IPrayerTimeService prayerTimeService) : ControllerBase
{
    private readonly IPrayerTimeService _prayerTimeService = prayerTimeService;

    [HttpGet]
    public async Task<IActionResult> Get(double lat, double lng)
    {
        var result = await _prayerTimeService.GetPrayerTimes(lat, lng);
        return Ok(new ApiResponse<object> { Success = true, Data = result });
    }
}
