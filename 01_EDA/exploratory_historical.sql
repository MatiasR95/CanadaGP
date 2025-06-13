/* Exploratory/Historical: Total Canadian GPs */
SELECT
    COUNT(*) AS Total_Races
FROM
    races
WHERE
    circuitId = 7;

/* Task H1: Top 5 Drivers by Wins */
SELECT TOP 5
    SUM(CASE WHEN r.positionOrder = 1 THEN 1 ELSE 0 END) AS Total_Wins,
    d.forename + ' ' + d.surname AS Driver
FROM
    results r
JOIN races ra ON ra.raceId = r.raceId
JOIN drivers d ON d.driverId = r.driverId
WHERE ra.circuitId = 7
GROUP BY d.forename, d.surname
ORDER BY Total_Wins DESC;

/* Task H2: Top 5 Constructors by Points */
SELECT TOP 5
    SUM(r.points) AS Total_Points,
    c.name AS Constructor
FROM
    results r
JOIN races ra ON ra.raceId = r.raceId
JOIN constructors c ON c.constructorId = r.constructorId
WHERE ra.circuitId = 7
GROUP BY c.name
ORDER BY Total_Points DESC;

/* Task H3: Fastest Lap Frequency by Driver */
SELECT TOP 5
    COUNT(*) AS Fastest_Lap_Count,
    d.forename + ' ' + d.surname AS Driver
FROM
    lap_times lt
JOIN races ra ON ra.raceId = lt.raceId
JOIN drivers d ON lt.driverId = d.driverId
WHERE ra.circuitId = 7 AND ra.year >= 2004
GROUP BY d.forename, d.surname
HAVING MIN(lt.milliseconds) = (
    SELECT MIN(lt2.milliseconds)
    FROM lap_times lt2
    WHERE lt2.raceId = lt.raceId
)
ORDER BY Fastest_Lap_Count DESC;

/* Top 5 Pole Positions in the Last 20 Years (2004–2024) */
SELECT TOP 5
    d.forename + ' ' + d.surname AS Driver,
    SUM(CASE WHEN q.position = 1 THEN 1 ELSE 0 END) AS Total_Poles
FROM
    qualifying q
JOIN races ra ON ra.raceId = q.raceId
JOIN drivers d ON q.driverId = d.driverId
WHERE ra.circuitId = 7 AND ra.year BETWEEN 2004 AND 2024
GROUP BY d.forename, d.surname
ORDER BY Total_Poles DESC;
