
CREATE PROC [ERP].[Usp_Upd_TipoCambio]
@IdTipoCambioDiario INT,
@VentaSunat DECIMAL(14,5),
@CompraSunat DECIMAL(14,5),
@VentaSBS DECIMAL(14,5),
@CompraSBS DECIMAL(14,5),
@VentaComercial DECIMAL(14,5),
@CompraComercial DECIMAL(14,5),
@UsuarioRegistro VARCHAR(250)
AS
BEGIN

	UPDATE ERP.TipoCambioDiario SET VentaSunat = @VentaSunat, 
									CompraSunat = @CompraSunat,
									VentaSBS = @VentaSBS,
									CompraSBS = @CompraSBS,
									VentaComercial = @VentaComercial,
									CompraComercial = @CompraComercial,
									UsuarioRegistro = @UsuarioRegistro,
									UsuarioModifico = @UsuarioRegistro,
									FechaModificado = DATEADD(HOUR, 3, GETDATE())
								WHERE ID = @IdTipoCambioDiario

END