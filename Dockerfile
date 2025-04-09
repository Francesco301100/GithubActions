# ===========================
# 1️⃣ Build-Stage mit Maven
# ===========================
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Arbeitsverzeichnis im Container
WORKDIR /app

# Nur pom.xml kopieren und Dependencies vorab cachen
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Jetzt den Rest des Codes kopieren
COPY . .

# App bauen, Tests überspringen
RUN mvn clean package -DskipTests

# ===============================
# 2️⃣ Laufzeit-Stage mit schlankem Java
# ===============================
FROM eclipse-temurin:17-jdk-alpine

# Arbeitsverzeichnis
WORKDIR /app

# Nur das gebaute .jar übernehmen
COPY --from=build /app/target/*.jar app.jar

# Startbefehl
ENTRYPOINT ["java", "-jar", "app.jar"]
