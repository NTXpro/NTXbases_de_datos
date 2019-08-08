-- =============================================
-- Author:		 OMAR RODRIGUEZ
-- Create date: 28-03-2019
-- Description:	SP PARA ACTUALIZAR LA FECHA Y MOTIVO DE CESE
-- =============================================
CREATE PROCEDURE [ERP].[Usp_ActualizarCese]
	@IdDatoLaboral int,
	@IdMotivoCese int NULL,
	@FechaCese datetime NULL 
AS
BEGIN
	UPDATE ERP.DatoLaboral
	SET
	    FechaCese = @FechaCese
	   ,IdMotivoCese = @IdMotivoCese WHERE Id =@IdDatoLaboral
END