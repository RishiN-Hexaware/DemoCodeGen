FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["Code/Estimate.PlatformServices/Estimate.PlatformServices.csproj", "Code/Estimate.PlatformServices/"]
COPY ["Code/Estimate.PlatformServices.Contracts/Estimate.PlatformServices.Contracts.csproj", "Code/Estimate.PlatformServices.Contracts/"]
COPY ["Code/Estimate.BusinessEntities/Estimate.BusinessEntities.csproj", "Code/Estimate.BusinessEntities/"]
COPY ["Code/Estimate.BusinessServices/Estimate.BusinessServices.csproj", "Code/Estimate.BusinessServices/"]
COPY ["Code/Estimate.Data/Estimate.Data.csproj", "Code/Estimate.Data/"]
COPY ["Code/Estimate.ServiceGateway/Estimate.ServiceGateway.csproj", "Code/Estimate.ServiceGateway/"]
COPY ["Tests/Estimate.Test.Test.PlatformServices/Estimate.Test.Test.PlatformServices.csproj", "Tests/Estimate.Test.Test.PlatformServices/"]
COPY ["Tests/Estimate.Test.Test.BusinessServices/Estimate.Test.Test.BusinessServices.csproj", "Tests/Estimate.Test.Test.BusinessServices/"]
COPY ["Tests/Estimate.Test.Test.Data/Estimate.Test.Test.Data.csproj", "Tests/Estimate.Test.Test.Data/"]
COPY ["Tests/Estimate.Test.Test.ServiceGateway/Estimate.Test.Test.ServiceGateway.csproj", "Tests/Estimate.Test.Test.ServiceGateway/"]
COPY ["Tests/Estimate.Test.Test.Framework/Estimate.Test.Test.Framework.csproj", "Tests/Estimate.Test.Test.Framework/"]
RUN dotnet restore "Code/Estimate.PlatformServices/Estimate.PlatformServices.csproj"
COPY . .
WORKDIR "/src/Code/Estimate.PlatformServices"
RUN dotnet build "Estimate.PlatformServices.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Estimate.PlatformServices.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /App
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]
