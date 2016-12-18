SET DATEFORMAT DMY

CREATE TABLE ObservationStatistics (
	ClientMac varchar(40),
	SeenDate date,
	MaxRSSI decimal, 
	MinRSSI decimal,
	CountRSSI decimal,
	AvgRSSI decimal(10, 5),
	VarRSSI decimal(10, 5),
	StdevRSSI decimal(10, 5),
	SlopeRSSI decimal(10, 5), 
	InterceptRSSI decimal(10, 5),
	Generation int
)

GO

DELETE ObservationStatistics WHERE Generation = 0
INSERT INTO ObservationStatistics
SELECT ClientMac,
       SeenDate,
       MAX(RSSI), MIN(RSSI), COUNT(*),
	   AVG(RSSI), VAR(RSSI), STDEV(RSSI),
	   -- x = RSSIRank, y = RSSI
	   CASE WHEN COUNT(*) = 1 THEN NULL
	   ELSE (COUNT(*) * SUM(RSSIRank * RSSI) - SUM(RSSI) * SUM(RSSIRank)) / (COUNT(*) * SUM(RSSIRank * RSSIRank) - SUM(RSSIRank) * SUM(RSSIRank)) END,
	   CASE WHEN COUNT(*) = 1 THEN NULL
	   ELSE AVG(RSSI) - ((COUNT(*) * SUM(RSSIRank * RSSI)) - (SUM(RSSIRank) * SUM(RSSI))) / ((COUNT(*) * SUM(POWER(RSSIRank, 2))) - POWER(SUM(RSSIRank), 2)) * AVG(RSSIRank) END,
	   0
FROM [dbo].[Observations2]
GROUP BY ClientMac, SeenDate

DELETE ObservationStatistics WHERE Generation = 1
INSERT INTO ObservationStatistics
SELECT OBS.ClientMac,
       OBS.SeenDate,
       MAX(RSSI), MIN(RSSI), COUNT(*),
	   AVG(RSSI), VAR(RSSI), STDEV(RSSI),
	   -- x = RSSIRank, y = RSSI
	   CASE WHEN COUNT(*) = 1 THEN NULL
	   ELSE (COUNT(*) * SUM(RSSIRank * RSSI) - SUM(RSSI) * SUM(RSSIRank)) / (COUNT(*) * SUM(RSSIRank * RSSIRank) - SUM(RSSIRank) * SUM(RSSIRank)) END,
	   CASE WHEN COUNT(*) = 1 THEN NULL
	   ELSE AVG(RSSI) - ((COUNT(*) * SUM(RSSIRank * RSSI)) - (SUM(RSSIRank) * SUM(RSSI))) / ((COUNT(*) * SUM(POWER(RSSIRank, 2))) - POWER(SUM(RSSIRank), 2)) * AVG(RSSIRank) END,
	   1
FROM [dbo].[Observations2] OBS
INNER JOIN ObservationStatistics STAT ON OBS.ClientMac = STAT.ClientMac AND OBS.SeenDate = STAT.SeenDate
WHERE STAT.SlopeRSSI * OBS.RSSIRank + STAT.InterceptRSSI - STAT.StdevRSSI < OBS.RSSI OR STAT.SlopeRSSI IS NULL
GROUP BY OBS.ClientMac, OBS.SeenDate

SELECT OBS.[ClientMac]
      ,OBS.[SeenTime]
      ,OBS.[RSSI]
      ,OBS.[SSID]
      ,OBS.[Manufacturer]
	  ,STAT.MaxRSSI
	  ,STAT.MinRSSI
	  ,STAT.AvgRSSI
	  ,STAT.StdevRSSI
	  ,STAT.VarRSSI
	  ,STAT.CountRSSI
FROM [dbo].[Observations2] OBS
INNER JOIN ObservationStatistics STAT ON STAT.ClientMac = OBS.ClientMac AND STAT.SeenDate = OBS.SeenDate AND STAT.Generation = 1
WHERE '12.12.2016 16:16' < [SeenTime] AND [SeenTime] < '12.12.2016 16:34' AND STAT.AvgRSSI + STAT.StdevRSSI * 2 < RSSI
ORDER BY [ClientMac]

SELECT SeenTime, RSSI, STAT.*, STAT.AvgRSSI - STAT.StdevRSSI FROM Observations2 OBS
INNER JOIN ObservationStatistics STAT ON STAT.ClientMac = OBS.ClientMac AND STAT.SeenDate = OBS.SeenDate AND STAT.Generation = 1
WHERE OBS.ClientMac like '1c:91:48:a6:11:b4' AND OBS.SeenDate = '12.12.2016'
ORDER BY SeenTime DESC

