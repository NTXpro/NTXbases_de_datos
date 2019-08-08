CREATE PROCEDURE [ERP].[Usp_IngresarHoyDesdeUltimoTipoCambio]
@IdEmpresa INT,
@Fecha DATETIME
AS
	INSERT INTO ERP.TipoCambioDiario(Fecha, VentaSunat, CompraSunat, VentaSBS, CompraSBS, VentaComercial, CompraComercial, FechaModificado, UsuarioRegistro, UsuarioModifico, FechaRegistro)
	SELECT TOP 1 CAST(@Fecha AS DATE), VentaSunat, CompraSunat, VentaSBS, CompraSBS, VentaComercial, CompraComercial, FechaModificado, 'NTXPRO', UsuarioModifico, GETDATE()
	FROM ERP.TipoCambioDiario
	WHERE Fecha = (SELECT TOP 1 Fecha 
					FROM ERP.TipoCambioDiario 
					WHERE CAST(Fecha AS DATE) < CAST(@Fecha AS DATE) 
					ORDER BY Fecha DESC)