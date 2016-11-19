SELECT 
	[Event],
	RSSI, 
	Location_Lat, Location_Lng, Location_Unc, 
	SeenTime,
	Manufacturer, OS 
FROM [Messages] M
INNER JOIN [Observations] O ON O.Messageid = M.Id
WHERE ClientMac = '00:25:d3:61:4b:fd'
ORDER BY SeenTime DESC