# SimpleWeatherList.Web

A minimal ASP.NET Core 8 web app that displays a weather forecast using a JavaScript-powered table.

## Prerequisites
- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Docker](https://www.docker.com/get-started) (for containerization)

## Build and Run Locally

1. **Restore dependencies:**
   ```sh
   dotnet restore
   ```
2. **Build the project:**
   ```sh
   dotnet build
   ```
3. **Run the app:**
   ```sh
   dotnet run --project src/SimpleWeatherList.Web/SimpleWeatherList.Web.csproj
   ```
4. Open your browser to the URL shown in the console (e.g., `https://localhost:7209`).

## Build and Run with Docker (using .NET SDK built-in container support)

1. **Publish the container image:**
   ```sh
   dotnet publish src/SimpleWeatherList.Web/SimpleWeatherList.Web.csproj -c Release -p:PublishProfile=DefaultContainer -p:ContainerImageName=simpleweatherlist.web
   ```
2. **Run the Docker container:**
   ```sh
   docker run -p 8080:8080 -p 8081:8081 simpleweatherlist.web
   ```
3. Open your browser to `http://localhost:8080` or `https://localhost:8081`.

## Notes
- The app uses HTTPS redirection by default.
- No Dockerfile is needed; the .NET SDK generates the image using project settings.
