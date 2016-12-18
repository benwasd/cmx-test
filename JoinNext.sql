  SELECT OBS.Id, OBS.SeenTime, OBSNext.Id, OBSNext.SeenTime, OBS.RSSI FROM Observations2 OBS
  LEFT JOIN Observations2 OBSNext ON OBSNext.ClientMac = OBS.ClientMac AND OBSNext.Id <> OBS.Id AND OBSNext.SeenTime BETWEEN OBS.SeenTime AND DATEADD(minute, 50, OBS.SeenTime)
  WHERE OBS.ClientMac = '98:5f:d3:3b:88:a7' AND OBSNext.Id IS NULL