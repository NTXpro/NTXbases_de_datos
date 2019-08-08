-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 21/08/2018
-- Description:	GENERADOR CORRELATIVO DOCUMENTO EN VALES
-- =============================================
CREATE FUNCTION ERP.GenerarNroDocumentoVale
(
	@IdTipoMovimiento int
)
RETURNS VARCHAR(8)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar VARCHAR(8)

	DECLARE @BASE VARCHAR(8) = '00000000'
	DECLARE @ULT_NUMERO INT = 0
	SELECT TOP 1 @ULT_NUMERO=CAST( v.Documento AS INT) FROM ERP.Vale v WHERE  v.IdTipoMovimiento = @IdTipoMovimiento	 ORDER BY v.ID DESC
	SELECT @ResultVar = SUBSTRING(@BASE,1,LEN(@BASE)-LEN(CAST(@ULT_NUMERO AS NVARCHAR(8)))) + CAST(@ULT_NUMERO AS NVARCHAR(8))
	-- Return the result of the function
	RETURN @ResultVar

END