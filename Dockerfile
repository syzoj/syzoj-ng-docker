FROM alpine/git:latest AS git
WORKDIR /root
RUN git clone https://github.com/syzoj/syzoj-ng.git

FROM microsoft/dotnet:sdk AS build-env
WORKDIR /app/syzoj-ng/
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash && apt-get install nodejs
COPY --from=git /root/syzoj-ng/ ./
RUN dotnet restore
RUN dotnet publish -c Release -o out
RUN dotnet test Syzoj.Api.Test/

FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/syzoj-ng/Syzoj.Api/out .
ENTRYPOINT ["dotnet", "Syzoj.Api.dll"]
