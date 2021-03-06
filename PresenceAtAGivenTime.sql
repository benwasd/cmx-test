SET DATEFORMAT DMY

CREATE TABLE ObservationStatistics (
    ClientMac varchar(40),
    SeenDate date,
    MaxApproxD decimal, 
    MinApproxD decimal,
    [Count] decimal,
    AvgApproxD decimal(10, 5),
    VarApproxD decimal(10, 5),
    StdevApproxD decimal(10, 5),
    SlopeApproxD decimal(10, 5), 
    InterceptApproxD decimal(10, 5),
    SeenDayCount int,
    SeenCount int,
    FirstSeen datetime,
    LastSeen datetime,
    FirstSeenToday datetime,
    LastSeenToday datetime,
    Generation int
)

GO

DELETE ObservationStatistics WHERE Generation = 0
INSERT INTO ObservationStatistics
SELECT ClientMac,
       SeenDate,
       MAX(ApproxD), MIN(ApproxD), COUNT(*),
       AVG(ApproxD), VAR(ApproxD), STDEV(ApproxD),
       -- x = ApproxDRank, y = ApproxD
       CASE WHEN COUNT(*) = 1 THEN NULL
       ELSE (COUNT(*) * SUM(ApproxDRank * ApproxD) - SUM(ApproxD) * SUM(ApproxDRank)) / (COUNT(*) * SUM(ApproxDRank * ApproxDRank) - SUM(ApproxDRank) * SUM(ApproxDRank)) END,
       CASE WHEN COUNT(*) = 1 THEN NULL
       ELSE AVG(ApproxD) - ((COUNT(*) * SUM(ApproxDRank * ApproxD)) - (SUM(ApproxDRank) * SUM(ApproxD))) / ((COUNT(*) * SUM(POWER(ApproxDRank, 2))) - POWER(SUM(ApproxDRank), 2)) * AVG(ApproxDRank) END,
       (SELECT COUNT(DISTINCT SeenDate) FROM [dbo].[Observations2] WHERE ClientMac = OBS.ClientMac),
       (SELECT COUNT(*) FROM [dbo].[Observations2] WHERE ClientMac = OBS.ClientMac),
       (SELECT MIN(SeenTime) FROM [dbo].[Observations2] WHERE ClientMac = OBS.ClientMac),
       (SELECT MAX(SeenTime) FROM [dbo].[Observations2] WHERE ClientMac = OBS.ClientMac),
       MIN(SeenTime),
       MAX(SeenTime),
       0
FROM [dbo].[Observations2] OBS
GROUP BY ClientMac, SeenDate

DELETE ObservationStatistics WHERE Generation = 1
INSERT INTO ObservationStatistics
SELECT OBS.ClientMac,
       OBS.SeenDate,
       MAX(ApproxD), MIN(ApproxD), COUNT(*),
       AVG(ApproxD), VAR(ApproxD), STDEV(ApproxD),
       -- x = ApproxDRank, y = ApproxD
       CASE WHEN COUNT(*) = 1 THEN NULL
       ELSE (COUNT(*) * SUM(ApproxDRank * ApproxD) - SUM(ApproxD) * SUM(ApproxDRank)) / (COUNT(*) * SUM(ApproxDRank * ApproxDRank) - SUM(ApproxDRank) * SUM(ApproxDRank)) END,
       CASE WHEN COUNT(*) = 1 THEN NULL
       ELSE AVG(ApproxD) - ((COUNT(*) * SUM(ApproxDRank * ApproxD)) - (SUM(ApproxDRank) * SUM(ApproxD))) / ((COUNT(*) * SUM(POWER(ApproxDRank, 2))) - POWER(SUM(ApproxDRank), 2)) * AVG(ApproxDRank) END,
       STAT.SeenDayCount, STAT.SeenCount, STAT.FirstSeen, STAT.LastSeen, STAT.FirstSeenToday, STAT.LastSeenToday,
       1
FROM [dbo].[Observations2] OBS
INNER JOIN ObservationStatistics STAT ON OBS.ClientMac = STAT.ClientMac AND OBS.SeenDate = STAT.SeenDate
WHERE OBS.ApproxD < STAT.SlopeApproxD * OBS.ApproxDRank + STAT.InterceptApproxD + STAT.StdevApproxD OR STAT.SlopeApproxD IS NULL
GROUP BY OBS.ClientMac, OBS.SeenDate, STAT.SeenDayCount, STAT.SeenCount, STAT.FirstSeen, STAT.LastSeen, STAT.FirstSeenToday, STAT.LastSeenToday
