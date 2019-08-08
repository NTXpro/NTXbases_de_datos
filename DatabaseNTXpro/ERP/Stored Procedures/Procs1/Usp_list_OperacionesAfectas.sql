
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ERP].[Usp_list_OperacionesAfectas]
	
AS
BEGIN
	SELECT PLE.T12TipoOperacion.Nombre FROM ple.T12TipoOperacion WHERE PLE.T12TipoOperacion.FlagCostear=1
END