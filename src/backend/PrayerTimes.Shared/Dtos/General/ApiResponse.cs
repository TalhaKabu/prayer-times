namespace PrayerTimes.Shared.Dtos.General;

public class ApiResponse<T>
{
    public bool Success { get; set; }
    public T Data { get; set; }
    public string? Message { get; set; }
}
