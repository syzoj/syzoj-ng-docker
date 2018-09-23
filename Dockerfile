FROM alpine/git:latest AS git
WORKDIR /root
RUN git clone https://github.com/syzoj/Syzoj.Api

FROM microsoft/dotnet:sdk AS build-env
WORKDIR /app/Syzoj.Api/
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash && apt-get install nodejs
COPY --from=git /root/Syzoj.Api/ ./
RUN dotnet restore
RUN dotnet publish -c Release -o out
RUN dotnet test Syzoj.Api.Test/

FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/Syzoj.Api/Syzoj.Api/out .
ENTRYPOINT ["dotnet", "Syzoj.Api.dll"]
