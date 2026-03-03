using Microsoft.AspNetCore.Mvc;
using PrayerTimes.Application.Services.PrayerTimes;
using PrayerTimes.Shared.Dtos.General;
using PrayerTimes.Shared.Dtos.HijriDates;
using PrayerTimes.Shared.Dtos.PrayerTimes;

namespace PrayerTimes.Api.Controllers;


[ApiController]
[Route("api/[controller]")]
public class PrayerTimesController(IPrayerTimeService prayerTimeService) : ControllerBase
{
    private readonly IPrayerTimeService _prayerTimeService = prayerTimeService;

    [HttpGet("calculate")]
    public async Task<IActionResult> CalculateAsync(DateTime date, double lat, double lng)
    {
        var result = await _prayerTimeService.CalculatePrayerTimes(date, lat, lng);
        return Ok(new ApiResponse<PrayerTimesResponseDto> { Success = true, Data = result });
    }

    [HttpGet("hijri-date")]
    public async Task<IActionResult> GetHijriDateAsync(DateTime date)
    {
        var result = await _prayerTimeService.GetHijriDateAsync(date);
        return Ok(new ApiResponse<HijriDateDto> { Success = true, Data = result });
    }

}
