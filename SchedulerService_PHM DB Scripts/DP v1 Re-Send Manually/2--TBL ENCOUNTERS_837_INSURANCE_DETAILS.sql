USE [SCDB]
GO
/****** Object:  Table [dbo].[ENCOUNTERS_837_INSURANCE_DETAILS]    Script Date: 11/19/2023 7:03:07 PM ******/
DROP TABLE IF EXISTS [dbo].[ENCOUNTERS_837_INSURANCE_DETAILS]
GO
/****** Object:  Table [dbo].[ENCOUNTERS_837_INSURANCE_DETAILS]    Script Date: 11/19/2023 7:03:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ENCOUNTERS_837_INSURANCE_DETAILS](
	[INSURANCE] [int] NOT NULL,
	[ApplicationSenderCode] [varchar](20) NULL,
	[ApplicationReceiverCode] [varchar](20) NULL,
	[SenderID] [varchar](20) NULL,
	[ReceiverID] [varchar](20) NULL,
	[ReceiverName] [varchar](50) NULL,
	[ReceiverIdentifier] [varchar](20) NULL,
	[PayerName] [varchar](50) NULL,
	[PayerID] [varchar](20) NULL,
	[PayerAddressLine1] [varchar](50) NULL,
	[PayerAddressLine2] [varchar](50) NULL,
	[PayerCityName] [varchar](20) NULL,
	[PayerState] [varchar](2) NULL,
	[PayerZipCode] [varchar](10) NULL,
 CONSTRAINT [PK_ENCOUNTERS_837_INSURANCE_DETAILS] PRIMARY KEY CLUSTERED 
(
	[INSURANCE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[ENCOUNTERS_837_INSURANCE_DETAILS] ([INSURANCE], [ApplicationSenderCode], [ApplicationReceiverCode], [SenderID], [ReceiverID], [ReceiverName], [ReceiverIdentifier], [PayerName], [PayerID], [PayerAddressLine1], [PayerAddressLine2], [PayerCityName], [PayerState], [PayerZipCode]) VALUES (3, N'660749775', N'973', N'660749775', N'973', N'SSS', N'973', N'SSS', N'973', N'PO Box 363628', N'', N'San Juan', N'PR', N'009223628')
INSERT [dbo].[ENCOUNTERS_837_INSURANCE_DETAILS] ([INSURANCE], [ApplicationSenderCode], [ApplicationReceiverCode], [SenderID], [ReceiverID], [ReceiverName], [ReceiverIdentifier], [PayerName], [PayerID], [PayerAddressLine1], [PayerAddressLine2], [PayerCityName], [PayerState], [PayerZipCode]) VALUES (5, N'660665622', N'007326879', N'660707485', N'16-SMART', N'PMC', N'660592131', N'PMC', N'660653763', N'PO Box 71114', N'', N'San Juan', N'PR', N'009369998')
INSERT [dbo].[ENCOUNTERS_837_INSURANCE_DETAILS] ([INSURANCE], [ApplicationSenderCode], [ApplicationReceiverCode], [SenderID], [ReceiverID], [ReceiverName], [ReceiverIdentifier], [PayerName], [PayerID], [PayerAddressLine1], [PayerAddressLine2], [PayerCityName], [PayerState], [PayerZipCode]) VALUES (12, N'660519243', N'GHP660537624', N'660519243', N'GHP660537624', N'First Medical', N'GHP660537624', N'First Medical', N'GHP660537624', N'PO Box 71307', N'', N'San Juan', N'PR', N'009369998')
INSERT [dbo].[ENCOUNTERS_837_INSURANCE_DETAILS] ([INSURANCE], [ApplicationSenderCode], [ApplicationReceiverCode], [SenderID], [ReceiverID], [ReceiverName], [ReceiverIdentifier], [PayerName], [PayerID], [PayerAddressLine1], [PayerAddressLine2], [PayerCityName], [PayerState], [PayerZipCode]) VALUES (16, N'660665622', N'660636242PSG', N'660707485', N'16-SMART', N'Plan de Salud Menonita', N'660636242PSG', N'Plan de Salud Menonita', N'660636242PSG', N'PO Box 364988', N'', N'San Juan', N'PR', N'009369998')
INSERT [dbo].[ENCOUNTERS_837_INSURANCE_DETAILS] ([INSURANCE], [ApplicationSenderCode], [ApplicationReceiverCode], [SenderID], [ReceiverID], [ReceiverName], [ReceiverIdentifier], [PayerName], [PayerID], [PayerAddressLine1], [PayerAddressLine2], [PayerCityName], [PayerState], [PayerZipCode]) VALUES (13, N'660665622', N'81794', N'660707485', N'16-SMART', N'Molina', N'81794', N'Molina', N'81794', N'PO Box 364988', N'', N'San Juan', N'PR', N'009369998')
GO
