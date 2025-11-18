FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Install dpkg tools and fakeroot
RUN apt-get update && apt-get install -y \
    dpkg-dev \
    fakeroot \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .


# Build .deb using your script
RUN chmod +x build-deb.sh 
RUN ./build-deb.sh
