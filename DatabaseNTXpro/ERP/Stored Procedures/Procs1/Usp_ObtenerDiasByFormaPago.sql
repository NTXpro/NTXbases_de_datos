CREATE PROC [ERP].[Usp_ObtenerDiasByFormaPago] --1
@IdFormaPago INT
AS
BEGIN
	DECLARE @Dias  INT = (	
	SELECT	FP.Dias
	FROM [ERP].[FormaPago] FP
	WHERE FP.ID = @IdFormaPago)

	SELECT @Dias
END
