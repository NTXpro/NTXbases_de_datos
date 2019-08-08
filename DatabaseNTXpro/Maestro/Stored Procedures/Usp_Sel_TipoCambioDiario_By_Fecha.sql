CREATE PROC [Maestro].[Usp_Sel_TipoCambioDiario_By_Fecha]
@Fecha DATETIME
AS
BEGIN
	
	SELECT ID,
			Fecha,
			VentaSunat,
			CompraSunat,
			VentaSBS,
			CompraSBS,
			VentaComercial,
			CompraComercial,
			UsuarioRegistro,
			FechaRegistro,
			UsuarioModifico,
			FechaModificado
	FROM ERP.TipoCambioDiario
	WHERE CAST(Fecha AS DATE) = CAST(@Fecha AS DATE)

END