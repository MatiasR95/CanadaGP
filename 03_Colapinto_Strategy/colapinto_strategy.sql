/* Task C1: Points Probability by Grid Position */
WITH TotalPoints AS (
    SELECT
        r.grid AS Starting_Position,
        COUNT(DISTINCT r.raceId) AS Total_Canadian_GP,
        SUM(r.points) AS Total_Points,
        SUM(CASE WHEN r.positionOrder <= 10 THEN 1 ELSE 0 END) AS Total_Points_Finishes
    FROM
        results r
    JOIN races ra ON ra.raceId = r.raceId
    WHERE ra.circuitId = 7 AND ra.year BETWEEN 2014 AND 2024 AND r.grid > 0
    GROUP BY r.grid
)
SELECT
    Starting_Position,
    Total_Points,
    ROUND((CAST(Total_Points_Finishes AS FLOAT) / Total_Canadian_GP) * 100, 2) AS Points_Probabilities
FROM TotalPoints
WHERE Starting_Position <= 10
ORDER BY Starting_Position ASC;

/* Task C2: Position Dynamics */
SELECT
    r.grid AS Starting_Position,
    ROUND(AVG(CAST(r.grid AS FLOAT) - CAST(r.positionOrder AS FLOAT)), 1) AS AVG_Position_Gain,
    ROUND(
        (SUM(CASE WHEN r.grid > r.positionOrder THEN 1 ELSE 0 END) / CAST(COUNT(DISTINCT r.raceId) AS FLOAT)) * 100, 2
    ) AS Gain_Probability,
    COUNT(DISTINCT r.raceId) AS Total_Canadian_GP
FROM
    results r
JOIN races ra ON ra.raceId = r.raceId
WHERE
    ra.circuitId = 7 AND ra.year BETWEEN 2014 AND 2024
    AND r.grid > 0 AND r.positionOrder > 0
GROUP BY r.grid
HAVING r.grid <= 10
ORDER BY Starting_Position ASC;
