-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Del_Puestos]
	@ID INT
AS
BEGIN
		DELETE FROM [Maestro].[Puesto] WHERE ID=@ID AND FlagSunat = 0
END