/* Task P2: Drivers with Podiums */
SELECT TOP 5
    d.forename + ' ' + d.surname AS Driver,
    SUM(CASE WHEN r.positionOrder <= 3 THEN 1 ELSE 0 END) AS Total_Podiums
FROM results r
JOIN races ra ON ra.raceId = r.raceId
JOIN drivers d ON d.driverId = r.driverId
WHERE ra.circuitId = 7
GROUP BY d.forename, d.surname
ORDER BY Total_Podiums DESC;

/* Task P3: Average Finish Position by Constructor (2014–2024) */
SELECT
    c.name AS Constructor,
    AVG(CAST(r.positionOrder AS FLOAT)) AS AVG_Finish_Position
FROM results r
JOIN races ra ON ra.raceId = r.raceId
JOIN constructors c ON c.constructorId = r.constructorId
WHERE ra.circuitId = 7 AND ra.year >= 2014 AND r.positionOrder > 0
GROUP BY c.name
ORDER BY AVG_Finish_Position ASC;

/* Task P5: Grid vs. Qualifying Position Discrepancies */
SELECT
    d.forename + ' ' + d.surname AS Driver,
    q.position AS Qualy_Position,
    r.grid AS Grid_Position,
    CAST(r.grid AS FLOAT) - CAST(q.position AS FLOAT) AS Difference_In_Positions,
    ra.year AS Season
FROM results r
JOIN qualifying q ON q.raceId = r.raceId AND q.driverId = r.driverId
JOIN drivers d ON d.driverId = r.driverId
JOIN races ra ON ra.raceId = r.raceId
WHERE ra.circuitId = 7 AND ra.year BETWEEN 2014 AND 2024 AND q.position <> r.grid
ORDER BY Season ASC;

/* Task P7: Pole Positions by Constructor */
SELECT TOP 3
    SUM(CASE WHEN r.grid = 1 THEN 1 ELSE 0 END) AS Total_Poles,
    c.name AS Constructor
FROM results r
JOIN races ra ON ra.raceId = r.raceId
JOIN constructors c ON c.constructorId = r.constructorId
WHERE ra.circuitId = 7 AND ra.year >= 2014
GROUP BY c.name
ORDER BY Total_Poles DESC;

/* Task P8: Average Pit Stop Duration */
WITH Milliseconds AS (
    SELECT
        AVG(CAST(ps.milliseconds AS FLOAT)) AS AVG_Milliseconds,
        ra.name AS GP,
        ra.year AS Season
    FROM pit_stops ps
    JOIN races ra ON ra.raceId = ps.raceId
    WHERE ra.circuitId = 7 AND ra.year BETWEEN 2014 AND 2024
    GROUP BY ra.name, ra.year
)
SELECT
    Season,
    ROUND(AVG_Milliseconds / 1000, 2) AS AVG_Pit_Stop_In_Seconds
FROM Milliseconds
ORDER BY Season ASC;

/* Task P11: Points Finish Consistency */
SELECT
    d.forename + ' ' + d.surname AS Driver,
    SUM(CASE WHEN r.positionOrder <= 10 THEN 1 ELSE 0 END) AS Total_Points_Finishes
FROM results r
JOIN races ra ON ra.raceId = r.raceId
JOIN drivers d ON d.driverId = r.driverId
WHERE ra.circuitId = 7 AND ra.year BETWEEN 2014 AND 2024
GROUP BY d.forename, d.surname
ORDER BY Total_Points_Finishes DESC;
