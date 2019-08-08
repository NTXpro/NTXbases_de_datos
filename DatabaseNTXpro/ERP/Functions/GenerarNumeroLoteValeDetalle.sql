CREATE FUNCTION [ERP].[GenerarNumeroLoteValeDetalle](
@IdEmpresa	INT,
@IdProducto INT,
@Fecha DATETIME
)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @NumeroLote VARCHAR(20);
	DECLARE @FechaLote VARCHAR(20)= (SELECT CONVERT(VARCHAR(10),@Fecha,112));

	DECLARE @UltimoNumeroLote VARCHAR(20) = (SELECT MAX(VD.NumeroLote)
										   FROM ERP.ValeDetalle VD
										   INNER JOIN ERP.Vale V
										   ON VD.IdVale = V.ID
										   WHERE CAST(VD.Fecha AS DATE) = CAST(@Fecha AS DATE) AND VD.IdProducto = @IdProducto AND V.IdEmpresa = @IdEmpresa AND VD.NumeroLote LIKE @FechaLote+'%');

	DECLARE @NumeroLoteRUC VARCHAR(11) = (SELECT Valor
										FROM ERP.Parametro
										WHERE Abreviatura = 'NL'
										AND IdEmpresa = @IdEmpresa)

	IF @UltimoNumeroLote IS NULL
	BEGIN	
		--SET @NumeroLote = @FechaLote + '0001';
		SET @NumeroLote = @NumeroLoteRUC;
	END
	ELSE
	BEGIN
		--DECLARE @Correlativo INT = 	(SELECT CONVERT(INT,(SELECT SUBSTRING(@UltimoNumeroLote,9,4))) + 1);
		--SET @NumeroLote = @FechaLote + RIGHT('0000' + LTRIM(RTRIM(@Correlativo)), 4)
		SET @NumeroLote = @NumeroLoteRUC
	END

	RETURN 	@NumeroLote

END