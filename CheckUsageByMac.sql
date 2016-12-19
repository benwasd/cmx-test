SELECT SeenDate
	  ,MIN(SeenTime) AS FirstSeenToday
	  ,MAX(SeenTime) AS LastSeenToday
	  ,COUNT(*) AS SeenCount
FROM Observations2
WHERE ClientMac = '00:24:d7:53:2b:08'
GROUP BY SeenDate
ORDER BY SeenDate

SELECT SeenTime, ApproxD, RSSI FROM Observations2 OBS
INNER JOIN ObservationStatistics STAT ON STAT.ClientMac = OBS.ClientMac AND STAT.SeenDate = OBS.SeenDate AND STAT.Generation = 1
WHERE OBS.ClientMac like '00:24:d7:53:2b:08' AND OBS.SeenDate = '12.12.2016'
ORDER BY SeenTime ASC