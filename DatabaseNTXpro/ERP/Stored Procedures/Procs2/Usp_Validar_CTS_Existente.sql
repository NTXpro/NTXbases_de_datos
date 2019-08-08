
create PROC [ERP].[Usp_Validar_CTS_Existente]
@IdEmpresa INT,
@IdAnio INT,
@IdFecha INT
AS
BEGIN
	DECLARE @IdCTS INT = (SELECT ID FROM ERP.CTS 
									WHERE IdEmpresa = @IdEmpresa AND IdAnio = @IdAnio AND IdFecha = @IdFecha)

	SELECT ISNULL(@IdCTS, 0)
END
