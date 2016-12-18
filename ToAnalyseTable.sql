/****** Object:  Table [dbo].[Observations2]    Script Date: 18.12.2016 13:01:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Observations2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MessageId] [uniqueidentifier] NOT NULL,
	[ClientMac] [nvarchar](max) NULL,
	[IpV4] [nvarchar](max) NULL,
	[IpV6] [nvarchar](max) NULL,
	[SeenTime] [datetime] NOT NULL,
	[SeenDate] [date] NOT NULL,
	[SeenEpoch] [int] NOT NULL,
	[RSSI] decimal(20, 5) NOT NULL,
	[RSSIRank] decimal(20, 5) NOT NULL,
	[SSID] [nvarchar](max) NULL,
	[Manufacturer] [nvarchar](max) NULL,
	[OS] [nvarchar](max) NULL,
	[Location_Lat] [decimal](18, 2) NOT NULL,
	[Location_Lng] [decimal](18, 2) NOT NULL,
	[Location_Unc] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_dbo.Observations2] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO

INSERT INTO [dbo].[Observations2] ([MessageId]
      ,[ClientMac]
      ,[IpV4]
      ,[IpV6]
      ,[SeenTime]
	  ,[SeenDate]
      ,[SeenEpoch]
      ,[RSSI]
	  ,[RSSIRank]
      ,[SSID]
      ,[Manufacturer]
      ,[OS]
      ,[Location_Lat]
      ,[Location_Lng]
      ,[Location_Unc])
SELECT [MessageId]
      ,[ClientMac]
      ,[IpV4]
      ,[IpV6]
      ,CAST([SeenTime] as datetime) AS [SeenTime]
	  ,CAST([SeenTime] as date) AS [SeenDate]
      ,[SeenEpoch]
      ,[RSSI]
	  ,ROW_NUMBER() OVER(PARTITION BY ClientMac, CAST([SeenTime] as date) ORDER BY RSSI DESC)
      ,[SSID]
      ,[Manufacturer]
      ,[OS]
      ,[Location_Lat]
      ,[Location_Lng]
      ,[Location_Unc]
  FROM [dbo].[Observations]
  ORDER BY CAST([SeenTime] as datetime) ASC