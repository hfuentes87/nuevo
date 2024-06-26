#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine AS base
WORKDIR /app
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build
WORKDIR /src
COPY ["WeatherApi/WeatherApi.csproj", "WeatherApi/"]
RUN dotnet restore -v d --interactive "WeatherApi/WeatherApi.csproj"
COPY . .
WORKDIR "/src/WeatherApi"
RUN dotnet build "WeatherApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WeatherApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WeatherApi.dll"]
