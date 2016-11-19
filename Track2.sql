/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 	
	RSSI, 
	Location_Lat, Location_Lng, Location_Unc, 
	SeenTime,
	Manufacturer, OS 
FROM [Observations]
-- WHERE ClientMac like '84:3A%' -- Schmudi laptop
-- WHERE ClientMac like 'e4:a7%' -- Beni Laptop
WHERE ClientMac like 'ac:5f%' -- Schmudis Phone
--WHERE ClientMac like '00:25%' -- Beni Phone
ORDER BY SeenTime DESC
