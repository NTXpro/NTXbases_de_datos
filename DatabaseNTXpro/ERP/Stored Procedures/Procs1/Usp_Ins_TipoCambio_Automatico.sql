CREATE PROC [ERP].[Usp_Ins_TipoCambio_Automatico]
@IdTipoCambioDiario INT OUT, 
@Fecha              DATETIME, 
@VentaSunat         DECIMAL(14, 5), 
@CompraSunat        DECIMAL(14, 5), 
@VentaSBS           DECIMAL(14, 5), 
@CompraSBS          DECIMAL(14, 5), 
@VentaComercial     DECIMAL(14, 5), 
@CompraComercial    DECIMAL(14, 5), 
@UsuarioRegistro    VARCHAR(250)
AS
     BEGIN

         MERGE INTO [ERP].[TipoCambioDiario] TCD1
         USING
         (
             SELECT @Fecha AS Fecha, 
                    @VentaSunat AS VentaSunat, 
                    @CompraSunat AS CompraSunat, 
                    @VentaSBS AS VentaSBS, 
                    @CompraSBS AS CompraSBS, 
                    @VentaComercial AS VentaComercial, 
                    @CompraComercial AS CompraComercial, 
                    @UsuarioRegistro AS UsuarioRegistro
         ) AS TCD2
         ON TCD1.Fecha = TCD2.Fecha
             WHEN MATCHED
             THEN UPDATE SET 
                             TCD1.Fecha = TCD2.Fecha, 
                             TCD1.VentaSunat = TCD2.VentaSunat, 
                             TCD1.CompraSunat = TCD2.CompraSunat, 
                             TCD1.VentaSBS = TCD2.VentaSBS, 
                             TCD1.CompraSBS = TCD2.CompraSBS, 
                             TCD1.VentaComercial = TCD2.VentaComercial, 
                             TCD1.CompraComercial = TCD2.CompraComercial, 
                             TCD1.UsuarioRegistro = TCD2.UsuarioRegistro, 
                             TCD1.FechaRegistro = DATEADD(HOUR, 3, GETDATE()), 
                             TCD1.UsuarioModifico = TCD2.UsuarioRegistro, 
                             TCD1.FechaModificado = DATEADD(HOUR, 3, GETDATE())
             WHEN NOT MATCHED
             THEN
               INSERT(Fecha, 
                      VentaSunat, 
                      CompraSunat, 
                      VentaSBS, 
                      CompraSBS, 
                      VentaComercial, 
                      CompraComercial, 
                      UsuarioRegistro, 
                      FechaRegistro, 
                      UsuarioModifico, 
                      FechaModificado)
               VALUES
         (@Fecha, 
          @VentaSunat, 
          @CompraSunat, 
          @VentaSBS, 
          @CompraSBS, 
          @VentaComercial, 
          @CompraComercial, 
          @UsuarioRegistro, 
          DATEADD(HOUR, 3, GETDATE()), 
          @UsuarioRegistro, 
          DATEADD(HOUR, 3, GETDATE())
         );
		 SET @IdTipoCambioDiario = (SELECT CAST(SCOPE_IDENTITY() AS int));
     END;