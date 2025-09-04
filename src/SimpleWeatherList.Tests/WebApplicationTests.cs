namespace SimpleWeatherList.Tests;

[TestClass]
public class WebApplicationTests
{
    private WebApplicationFactory<Program> _factory = null!;
    private HttpClient _client = null!;

    [TestInitialize]
    public void Setup()
    {
        _factory = new WebApplicationFactory<Program>();
        _client = _factory.CreateClient();
    }

    [TestCleanup]
    public void Cleanup()
    {
        _client?.Dispose();
        _factory?.Dispose();
    }

    [TestMethod]
    public async Task Get_HomePage_ReturnsSuccessAndCorrectContentType()
    {
        // Act
        var response = await _client.GetAsync("/");

        // Assert
        response.EnsureSuccessStatusCode(); // Status Code 200-299
        Assert.IsTrue(response.Content.Headers.ContentType?.ToString()?.StartsWith("text/html") == true, 
            "Content type should be text/html");
    }

    [TestMethod]
    public async Task Get_WeatherForecast_ReturnsSuccessAndValidJson()
    {
        // Act
        var response = await _client.GetAsync("/weatherforecast");

        // Assert
        response.EnsureSuccessStatusCode(); // Status Code 200-299
        
        var content = await response.Content.ReadAsStringAsync();
        Assert.IsNotNull(content);
        Assert.IsTrue(content.Length > 0, "Response should not be empty");
        
        // Verify it's valid JSON by attempting to parse
        var forecasts = JsonSerializer.Deserialize<JsonElement[]>(content);
        Assert.IsNotNull(forecasts);
        Assert.IsTrue(forecasts.Length > 0, "Should return at least one forecast");
    }

    [TestMethod]
    public async Task Get_WeatherForecast_ReturnsExpectedNumberOfForecasts()
    {
        // Act
        var response = await _client.GetAsync("/weatherforecast");

        // Assert
        response.EnsureSuccessStatusCode();
        
        var content = await response.Content.ReadAsStringAsync();
        var forecasts = JsonSerializer.Deserialize<JsonElement[]>(content);
        
        Assert.AreEqual(5, forecasts!.Length, "Should return exactly 5 weather forecasts");
    }

    [TestMethod]
    public async Task Get_WeatherForecast_ForecastsHaveRequiredProperties()
    {
        // Act
        var response = await _client.GetAsync("/weatherforecast");

        // Assert
        response.EnsureSuccessStatusCode();
        
        var content = await response.Content.ReadAsStringAsync();
        var forecasts = JsonSerializer.Deserialize<JsonElement[]>(content);
        
        Assert.IsNotNull(forecasts);
        
        foreach (var forecast in forecasts)
        {
            Assert.IsTrue(forecast.TryGetProperty("date", out _), "Each forecast should have a 'date' property");
            Assert.IsTrue(forecast.TryGetProperty("temperatureC", out _), "Each forecast should have a 'temperatureC' property");
            Assert.IsTrue(forecast.TryGetProperty("temperatureF", out _), "Each forecast should have a 'temperatureF' property");
            Assert.IsTrue(forecast.TryGetProperty("summary", out _), "Each forecast should have a 'summary' property");
        }
    }
}
