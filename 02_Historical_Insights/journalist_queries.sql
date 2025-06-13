/* Task J1: Overtaking Frequency by Season */
SELECT
    ra.year AS Season,
    AVG(ABS(CAST(r.grid AS FLOAT) - CAST(r.positionOrder AS FLOAT))) AS Avg_Position_Changes
FROM
    results r
JOIN races ra ON ra.raceId = r.raceId
WHERE ra.circuitId = 7 AND ra.year BETWEEN 2014 AND 2024
    AND r.grid > 0 AND r.positionOrder > 0
GROUP BY ra.year
ORDER BY Season ASC;

/* Task J2: Pole-to-Win Rate */
WITH P1_Wins AS (
    SELECT
        COUNT(DISTINCT r.raceId) AS Total_Races,
        SUM(CASE WHEN r.grid = 1 AND r.positionOrder = 1 THEN 1 ELSE 0 END) AS Total_P1_Wins
    FROM
        results r
    JOIN races ra ON ra.raceId = r.raceId
    WHERE ra.circuitId = 7 AND ra.year BETWEEN 2014 AND 2024
        AND r.grid > 0 AND r.positionOrder > 0
)
SELECT
    Total_Races,
    Total_P1_Wins,
    ROUND((Total_P1_Wins / CAST(Total_Races AS FLOAT)) * 100, 2) AS Pole_To_Win_Rate
FROM P1_Wins;
