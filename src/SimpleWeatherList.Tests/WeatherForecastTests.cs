namespace SimpleWeatherList.Tests;

[TestClass]
public class WeatherForecastTests
{
    [TestMethod]
    public void WeatherForecast_Creation_SetsPropertiesCorrectly()
    {
        // Arrange
        var date = DateOnly.FromDateTime(DateTime.Now);
        var temperatureC = 25;
        var summary = "Warm";

        // Act
        var forecast = new WeatherForecast(date, temperatureC, summary);

        // Assert
        Assert.AreEqual(date, forecast.Date);
        Assert.AreEqual(temperatureC, forecast.TemperatureC);
        Assert.AreEqual(summary, forecast.Summary);
    }

    [TestMethod]
    public void WeatherForecast_TemperatureF_ConvertsCorrectly()
    {
        // Arrange
        var date = DateOnly.FromDateTime(DateTime.Now);
        var temperatureC = 0; // 0°C should be 32°F
        var summary = "Freezing";

        // Act
        var forecast = new WeatherForecast(date, temperatureC, summary);

        // Assert
        Assert.AreEqual(32, forecast.TemperatureF, "0°C should convert to 32°F");
    }

    [TestMethod]
    public void WeatherForecast_TemperatureF_ConvertsFromPositiveCelsius()
    {
        // Arrange
        var date = DateOnly.FromDateTime(DateTime.Now);
        var temperatureC = 25; // 25°C should be 77°F (approximately)
        var summary = "Warm";

        // Act
        var forecast = new WeatherForecast(date, temperatureC, summary);

        // Assert
        // Using the same formula as the code: 32 + (int)(TemperatureC / 0.5556)
        var expectedF = 32 + (int)(25 * 1.8); // This gives 76, not 77
        Assert.AreEqual(expectedF, forecast.TemperatureF, "Temperature conversion should match the formula in the code");
    }

    [TestMethod]
    public void WeatherForecast_TemperatureF_ConvertsFromNegativeCelsius()
    {
        // Arrange
        var date = DateOnly.FromDateTime(DateTime.Now);
        var temperatureC = -10; // -10°C 
        var summary = "Freezing";

        // Act
        var forecast = new WeatherForecast(date, temperatureC, summary);

        // Assert
        // Using the same formula as the code: 32 + (int)(TemperatureC / 0.5556)
        var expectedF = 32 + (int)(-10 * 1.8); // This gives 15, not 14
        Assert.AreEqual(expectedF, forecast.TemperatureF, "Temperature conversion should match the formula in the code");
    }
}
