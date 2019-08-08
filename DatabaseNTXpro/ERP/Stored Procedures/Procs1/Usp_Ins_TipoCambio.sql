
CREATE PROC [ERP].[Usp_Ins_TipoCambio]
@IdTipoCambioDiario INT OUT,
@Fecha  DATETIME  ,
@VentaSunat DECIMAL(14,5) ,
@CompraSunat DECIMAL(14,5)  ,
@VentaSBS DECIMAL(14,5)  ,
@CompraSBS DECIMAL(14,5),
@VentaComercial DECIMAL(14,5),
@CompraComercial  DECIMAL(14,5),
@UsuarioRegistro VARCHAR(250)
AS 
BEGIN
--BEGIN TRAN
--	BEGIN TRY;

			INSERT INTO [ERP].[TipoCambioDiario] (Fecha,VentaSunat,CompraSunat,VentaSBS,CompraSBS,VentaComercial,CompraComercial,UsuarioRegistro,FechaRegistro,UsuarioModifico,FechaModificado)
										  VALUES (@Fecha,@VentaSunat,@CompraSunat,@VentaSBS,@CompraSBS,@VentaComercial,@CompraComercial,@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()),@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()));
			SET @IdTipoCambioDiario = (SELECT CAST(SCOPE_IDENTITY() AS int));
	--	COMMIT TRAN
	--END TRY
	--BEGIN CATCH 
	--		ROLLBACK TRAN
	--END CATCH
END
