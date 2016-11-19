 SELECT
	B.*, 
	LASTSEEN.RSSI AS LastSeenRSSI, LASTSEEN.SeenTime AS LastSeen,
	FIRSTSEEN.RSSI AS FirstSeenRSSI, FIRSTSEEN.SeenTime AS FirstSeen,
	WEAKRSSI.RSSI AS WeakRSSI, WEAKRSSI.SeenTime AS WeakRSSISeen,
	STRONGRSSI.RSSI AS StrongRSSI, STRONGRSSI.SeenTime AS StrongRSSISeen
FROM (
  SELECT ClientMac, OS, Manufacturer
  FROM [Observations]
  GROUP BY ClientMac, OS, Manufacturer
) AS B
INNER JOIN [Observations] LASTSEEN ON LASTSEEN.ClientMac = B.ClientMac
	AND LASTSEEN.SeenTime = (SELECT TOP 1 SeenTime FROM [Observations] WHERE ClientMac = B.ClientMac ORDER BY SeenTime DESC)
INNER JOIN [Observations] FIRSTSEEN ON FIRSTSEEN.ClientMac = B.ClientMac
	AND FIRSTSEEN.SeenTime = (SELECT TOP 1 SeenTime FROM [Observations] WHERE ClientMac = B.ClientMac ORDER BY SeenTime ASC)
INNER JOIN [Observations] WEAKRSSI ON WEAKRSSI.ClientMac = B.ClientMac
	AND WEAKRSSI.SeenTime = (SELECT TOP 1 SeenTime FROM [Observations] WHERE ClientMac = B.ClientMac ORDER BY RSSI ASC)
INNER JOIN [Observations] STRONGRSSI ON STRONGRSSI.ClientMac = B.ClientMac
	AND STRONGRSSI.SeenTime = (SELECT TOP 1 SeenTime FROM [Observations] WHERE ClientMac = B.ClientMac ORDER BY RSSI DESC)