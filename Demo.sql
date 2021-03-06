SET DATEFORMAT DMY

-- Demo Query 1 Overview 17:30 - 17:50 (00:ee:bd:9f:b5:41)
SELECT * FROM [dbo].[Observations2] OBS
WHERE '12.12.2016 16:16' < OBS.[SeenTime] AND OBS.[SeenTime] < '12.12.2016 16:34'
ORDER BY ClientMac

-- Demo Query 2 Detailed observations at 12.12.
SELECT SeenTime, ApproxD FROM [dbo].[Observations2] OBS
WHERE SeenDate = '12.12.2016' AND ClientMac = '00:ee:bd:9f:b5:41'
ORDER BY ApproxD

-- Demo Query 3 Detailed observations at 12.12 (no upper outlier).
-- Demo Query 4 Detailed observations at 12.12 (no upper outlier, orderd by time).
SELECT OBS.SeenTime, OBS.ApproxD  FROM [dbo].[Observations2] OBS
INNER JOIN ObservationStatistics STAT ON STAT.ClientMac = OBS.ClientMac AND STAT.SeenDate = OBS.SeenDate AND STAT.Generation = 0 
WHERE OBS.SeenDate = '12.12.2016' AND OBS.ClientMac = '00:ee:bd:9f:b5:41'
    AND OBS.ApproxD < STAT.SlopeApproxD * OBS.ApproxDRank + STAT.InterceptApproxD + STAT.StdevApproxD
--ORDER BY OBS.ApproxD
ORDER BY OBS.SeenTime

-- Demo Query 5 MacAddresses with moving avarage above stdev for 10minutes between 16:16 and 16:34
SELECT DISTINCT
       OBS.[ClientMac]
      ,OBS.[Manufacturer]
      ,MIN(CONNECTED_OBS.SeenTime) AS MinSeenIn10Min
      ,OBS.SeenTime
      ,MAX(CONNECTED_OBS.SeenTime) AS MaxSeenIn10Min
      ,STDEV(CONNECTED_OBS.ApproxD) AS StdevApproxD
      ,AVG(CONNECTED_OBS.ApproxD) AS AvgApproxD
      ,COUNT(CONNECTED_OBS.ApproxD) AS CountApproxD
FROM [dbo].[Observations2] OBS
INNER JOIN (
    SELECT INNR.ClientMac, INNR.SeenTime, INNR.ApproxD FROM [Observations2] INNR 
    INNER JOIN ObservationStatistics STAT ON STAT.ClientMac = INNR.ClientMac AND STAT.SeenDate = INNR.SeenDate AND STAT.Generation = 1 
    WHERE INNR.ApproxD < STAT.AvgApproxD - STAT.StdevApproxD
) CONNECTED_OBS ON CONNECTED_OBS.ClientMac = OBS.ClientMac AND CONNECTED_OBS.SeenTime BETWEEN DATEADD(mi, -5, OBS.SeenTime) AND DATEADD(mi, +5, OBS.SeenTime)
-- WHERE '12.12.2016 16:16' < OBS.[SeenTime] AND OBS.[SeenTime] < '12.12.2016 16:34'
-- WHERE '12.12.2016 16:34' < OBS.[SeenTime] AND OBS.[SeenTime] < '12.12.2016 16:52'
-- WHERE '12.12.2016 16:52' < OBS.[SeenTime] AND OBS.[SeenTime] < '12.12.2016 17:10'
-- WHERE '12.12.2016 17:15' < OBS.[SeenTime] AND OBS.[SeenTime] < '12.12.2016 17:35'
WHERE '12.12.2016 17:40' < OBS.[SeenTime] AND OBS.[SeenTime] < '12.12.2016 17:50'
GROUP BY OBS.Id, OBS.[ClientMac], OBS.[Manufacturer], OBS.SeenTime HAVING COUNT(*) >= 3
ORDER BY OBS.[ClientMac]

SELECT CAST(DATEPART(hour, OBS.SeenTime) AS varchar(MAX)) + ':' + CAST(DATEPART(minute, OBS.SeenTime) AS varchar(MAX)), OBS.ApproxD * - 1 FROM [dbo].[Observations2] OBS
INNER JOIN ObservationStatistics STAT ON STAT.ClientMac = OBS.ClientMac AND STAT.SeenDate = OBS.SeenDate AND STAT.Generation = 0 
WHERE OBS.SeenDate = '12.12.2016' AND OBS.ClientMac = 'f8:84:f2:82:e3:3e'
    AND OBS.ApproxD < STAT.SlopeApproxD * OBS.ApproxDRank + STAT.InterceptApproxD + STAT.StdevApproxD
--ORDER BY OBS.ApproxD
ORDER BY OBS.SeenTime