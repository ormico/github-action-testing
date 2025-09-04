var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

var app = builder.Build();

// Configure the HTTP request pipeline.

app.UseHttpsRedirection();

var summaries = new[]
{
    "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
};

app.MapGet("/", () =>
{
    var html = @"<!DOCTYPE html>
<html lang=""en"">
<head>
    <meta charset=""UTF-8"">
    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
    <title>Weather Forecast</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
    </style>
</head>
<body>
    <h1>Weather Forecast</h1>
    <table id=""forecastTable"">
        <thead>
            <tr>
                <th>Date</th>
                <th>Temp (C)</th>
                <th>Temp (F)</th>
                <th>Summary</th>
            </tr>
        </thead>
        <tbody></tbody>
    </table>
    <script>
        fetch('/weatherforecast')
            .then(response => response.json())
            .then(data => {
                const tbody = document.querySelector('#forecastTable tbody');
                data.forEach(item => {
                    const row = document.createElement('tr');
                    row.innerHTML = '<td>' + item.date + '</td><td>' + item.temperatureC + '</td><td>' + item.temperatureF + '</td><td>' + (item.summary || '') + '</td>';
                    tbody.appendChild(row);
                });
            })
            .catch(function(err) {
                document.body.innerHTML += '<p style=""color:red"">Failed to load weather data.</p>';
            });
    </script>
</body>
</html>";
    return Results.Content(html, "text/html");
});

app.MapGet("/weatherforecast", () =>
{
    var forecast = Enumerable.Range(1, 5).Select(index =>
        new WeatherForecast
        (
            DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Random.Shared.Next(-20, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();
    return forecast;
});

app.Run();

public partial class Program { }

public record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}
