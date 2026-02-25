using PrayerTimes.Application.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddOpenApi();

builder.Services.Resolve();

builder.Services.AddCors(options => options.AddPolicy(name: "PrayerTimes",
    policy =>
    {
        policy.WithOrigins("http://localhost:8100")
            .AllowAnyMethod()
            .AllowAnyHeader();
    }));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseCors("PrayerTimes");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
