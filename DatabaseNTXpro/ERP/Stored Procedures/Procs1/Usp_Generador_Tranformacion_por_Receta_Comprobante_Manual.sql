

-- =============================================
-- Author:        OMAR RODRIGUEZ
-- Create date: 23/08/2018
-- Description:    GENERADOR DE TRANSFORMACIONES POR PRODUCTO LINKEADO A RECETA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Generador_Tranformacion_por_Receta_Comprobante_Manual]
@PARAM_IDPRODUCTOFINAL INT,
@PARAM_CANTPRODUCTOFINAL INT,
@PARAM_REFERENCIAVENTA NVARCHAR(250),
@PARAM_USUARIO VARCHAR(250),
@PARAM_HORATRABAJO DATETIME,
@PARAM_IDPROYECTO INT,
@PARAM_IGV DECIMAL(14,5),
@PARAM_IDMONEDA INT,
@PARAM_SerieDocumentoComprobante VARCHAR(50)
AS
BEGIN
-- VARIABLES DE TRABAJO
DECLARE @TRAB_IGV DECIMAL(14,5);
DECLARE @TRAB_ALMACENDESTINO INT;
DECLARE @TRAB_IDTRANSFERENCIA INT;
DECLARE @TRAB_IDRECETA INT;
DECLARE @TRAB_IDMONEDA INT;
DECLARE @TRAB_HORADIFERENCIA INT;
DECLARE @TRAB_OBSERVACIONES VARCHAR(250);
DECLARE @XMLListaTransformacionOrigenDetalle NVARCHAR(MAX);
DECLARE @p12text NVARCHAR(MAX);
DECLARE @p12_01text NVARCHAR(MAX);
DECLARE @p12 XML;
DECLARE @p13 XML;
DECLARE @p14 XML;
DECLARE @p15 XML;
DECLARE @p15text NVARCHAR(MAX);
DECLARE @p16 XML;
DECLARE @p17 XML;

-----   VARIABLES DEL MAESTRO RECETA 
DECLARE @FILAc_ID INT;
DECLARE @FILAc_idEmpresa INT;
DECLARE @FILAc_Nombre VARCHAR(250);
DECLARE @FILAc_ProductoTerminado VARCHAR(250);
DECLARE @FILAc_CantidadProdTerminado INT;
DECLARE @FILAc_Fecha DATETIME;
DECLARE @FILAc_FechaIngreso DATETIME;
DECLARE @FILAc_FechaSalida DATETIME;
DECLARE @FILAc_UsuarioRegistro VARCHAR(250);
DECLARE @FILAc_FechaRegistro DATETIME;
DECLARE @FILAc_UsuarioModifico VARCHAR(250);
DECLARE @FILAc_FechaModificado DATETIME;
DECLARE @FILAc_UsuarioActivo VARCHAR(250);
DECLARE @FILAc_FechaActivacion DATETIME;
DECLARE @FILAc_UsuarioElimino VARCHAR(250);
DECLARE @FILAc_FechaEliminado DATETIME;
DECLARE @FILAc_FlagBorrador INT;
DECLARE @FILAc_Flag INT;
DECLARE @FILAc_idAlmacen INT;
DECLARE @FILAc_idProductoFinal INT;
DECLARE @FILAc_NombreProductoFinal VARCHAR(250);
DECLARE @FILAc_Afecto BIT;

-----   VARIABLES DEL DETALLE RECETA PRODUCTO
DECLARE @FILAd_IDdetalle INT;
DECLARE @FILAd_IdProducto INT;
DECLARE @FILAd_Cantidad DECIMAL(14, 5);
DECLARE @FILAd_Afecto BIT;
DECLARE @FILAd_IdValeEntrada BIT;
DECLARE @FILAd_NumeroLote VARCHAR(50);
DECLARE @FILAd_IGV INT;

DECLARE @FILAd_PrecioUnitario DECIMAL(14, 5);
DECLARE @FILAd_Nombre VARCHAR(250);
DECLARE @FILAd_SubTotal DECIMAL(14, 5)= 0;
DECLARE @FILAd_Total DECIMAL(14, 5)= 0;
DECLARE @FILAd_CantidadCALC DECIMAL(14, 5);

-----   VARIABLES DEL VALE
DECLARE @FILAv_DOCUMENTO_INGRESO VARCHAR(8);
DECLARE @FILAv_DOCUMENTO_SALIDA VARCHAR(8);
DECLARE @FILAv_SubTotal DECIMAL(14, 5)= 0;
DECLARE @FILAv_Total DECIMAL(14, 5)= 0;
DECLARE @FILAv_TotalIGV DECIMAL(14, 5)= 0;
DECLARE @FILAv_TipoCambio DECIMAL(14, 5)=0;
DECLARE @FILAv_ALMACEN_ORIGEN INT=(
    SELECT TOP 1 a.ID
    FROM ERP.Almacen a
    WHERE a.FlagPrincipal = 1
);
DECLARE @DETALLE_VALE_EGRESO NVARCHAR(MAX)= '';
DECLARE @DETALLE_IGV_PFINAL DECIMAL(14, 5)= 0;

-----------------------------------------------------------------------------------------
-- 1 CARGA INICIAL
-----------------------------------------------------------------------------------------
--SET @PARAM_IDMONEDA= 1
SET @TRAB_IDRECETA = 0;
SET @TRAB_IDRECETA = (SELECT TOP 1 r.ID FROM ERP.Receta r WHERE r.IdProducto = @PARAM_IDPRODUCTOFINAL)
--SET @PARAM_IGV= 18
SET @TRAB_IGV = (SELECT @PARAM_IGV/100.0)


IF(@TRAB_IDRECETA <> 0)
    BEGIN
        -- ALMACEN POR DEFECTO
        SET @TRAB_ALMACENDESTINO = ISNULL(
        (
            SELECT TOP 1 a.ID
            FROM ERP.ALMACEN a
            WHERE a.FlagPrincipal = 1
                  AND a.Flag = 1
                  AND a.FlagBorrador = 0
        ),
        (
            SELECT TOP 1 a.ID
            FROM ERP.ALMACEN a
            WHERE a.FlagPrincipal = 1
                  AND a.Flag = 1
                  AND a.FlagBorrador = 0
        ));

        ---- MONEDA
        SET @TRAB_IDMONEDA =(SELECT TOP 1 m.ID FROM Maestro.Moneda m);
        SELECT @FILAc_ID = r.ID, 
               @FILAc_idEmpresa = r.idEmpresa, 
               @FILAc_Nombre = r.Nombre, 
               @FILAc_ProductoTerminado = r.ProductoTerminado, 
               @FILAc_CantidadProdTerminado = r.CantidadProdTerminado, 
               @FILAc_Fecha = r.Fecha, 
               @FILAc_FechaIngreso = r.FechaIngreso, 
               @FILAc_FechaSalida = r.FechaSalida, 
               @FILAc_UsuarioRegistro = r.UsuarioRegistro, 
               @FILAc_FechaRegistro = r.FechaRegistro, 
               @FILAc_UsuarioModifico = r.UsuarioModifico, 
               @FILAc_FechaModificado = r.FechaModificado, 
               @FILAc_UsuarioActivo = r.UsuarioActivo, 
               @FILAc_FechaActivacion = r.FechaActivacion, 
               @FILAc_UsuarioElimino = r.UsuarioElimino, 
               @FILAc_FechaEliminado = r.FechaEliminado, 
               @FILAc_FlagBorrador = r.FlagBorrador, 
               @FILAc_Flag = r.Flag, 
               @FILAc_idAlmacen = r.idAlmacen, 
               @FILAc_idProductoFinal = r.IdProducto, 
               @FILAc_NombreProductoFinal = p.Nombre, 
               @FILAc_Afecto = p.FlagIGVAfecto
        FROM ERP.Receta r
             INNER JOIN ERP.Producto p ON r.IdProducto = p.ID
        WHERE r.ID = @TRAB_IDRECETA;

        -------------------------------------------------------------------------------------------
        -- 2 CARGAR LOS DETALLES todos los productos de la receta a el producto final de la receta
        -------------------------------------------------------------------------------------------
       
        -------------------- OrigenDetalle -----------------------------------------------------------------

        SET @p12text = '';
        SET @p12TEXT = '';
        DECLARE ProdInfo CURSOR
        FOR SELECT rpd.ID, 
                   rpd.IdProducto, 
                   rpd.Cantidad, 
                   p.Nombre, 
                   p.FlagIGVAfecto
            FROM ERP.RecetaProductoDetalle rpd
                 INNER JOIN ERP.Producto p ON rpd.IdProducto = p.ID
            WHERE rpd.IdReceta = @TRAB_IDRECETA;
        OPEN ProdInfo;
        FETCH NEXT FROM ProdInfo INTO @FILAd_IDdetalle, @FILAd_IdProducto, @FILAd_Cantidad, @FILAd_Nombre, @FILAd_Afecto;
        WHILE @@fetch_status = 0
            BEGIN
                ------------------------------------------------------------------------------------------------------------------
                -- BUSCAR LOTE MAS ANTIGUO 
                -- Esto se tiene que redefinir para el costo unitario y el numero de lote
                ------------------------------------------------------------------------------------------------------------------
                SET @FILAd_NumeroLote = '';
                SET @FILAd_IGV = 0;
                SET @FILAd_PrecioUnitario = 1;
                SET @FILAd_SubTotal = 0
                SET @FILAd_Total =0
                SET @FILAv_TotalIGV = 0
                SELECT @FILAd_Afecto = vd.FlagAfecto, 
                       @FILAd_NumeroLote = vd.NumeroLote, 
                     --  @FILAd_IGV = vd.IGV, 
                       @FILAd_PrecioUnitario = vd.PrecioUnitario
                FROM ERP.ValeDetalle vd
                     INNER JOIN ERP.Vale v ON vd.IdVale = v.ID
                WHERE vd.IdProducto = @FILAd_IdProducto
                      AND V.FlagBorrador = 0
                      AND V.Flag = 1
                ORDER BY v.Fecha ASC;
                IF(@FILAd_Afecto IS NULL)
                    BEGIN
                        SET @FILAd_Afecto = 0;
                        SET @FILAd_PrecioUnitario = 1;
                        SET @FILAd_NumeroLote =
                        (
                            SELECT TOP 1 p.Valor
                            FROM ERP.Parametro p
                            WHERE p.Abreviatura = 'NL'
                        );
                        SET @FILAd_IGV =
                        (
                            SELECT TOP 1 p.Valor
                            FROM ERP.Parametro p
                            WHERE p.Abreviatura = 'IGV'
                        );
                    END;

                ------------------------------------------------------------------------------------------------------------------
                --TOTALES CALCULOS POR LINEA 
                ------------------------------------------------------------------------------------------------------------------
                SET @FILAd_SubTotal = (@FILAd_PrecioUnitario * @FILAd_Cantidad)*@PARAM_CANTPRODUCTOFINAL
                SET @FILAd_Total = @FILAd_SubTotal + (@FILAd_SubTotal * @TRAB_IGV);
                SET @FILAv_TotalIGV = (@FILAd_SubTotal * @TRAB_IGV);
				SET @FILAd_CantidadCALC = @FILAd_Cantidad*@PARAM_CANTPRODUCTOFINAL
                ----------------------------------------------------------------------------------------------------------------
                --TOTALES CALCULOS POR RECETA
                ------------------------------------------------------------------------------------------------------------------
                SET @FILAv_SubTotal = @FILAv_SubTotal + @FILAd_SubTotal;
                SET @FILAv_Total = @FILAv_Total + @FILAd_Total;
                SET @DETALLE_IGV_PFINAL = @DETALLE_IGV_PFINAL + @FILAv_TotalIGV;

                ------------------------------------------------------------------------------------------------------------------
                -- CREAR EL DETALLE DEL VALE DE EGRESO
                ------------------------------------------------------------------------------------------------------------------
                SET @DETALLE_VALE_EGRESO = @DETALLE_VALE_EGRESO+'<ArchivoPlanoValeDetalle>
                                                <ID>0</ID>
                                                <Item>1</Item>
                                                <IdProducto>'+CAST(@FILAd_IdProducto AS NVARCHAR(250))+'</IdProducto>
                                                <Nombre>'+@FILAd_Nombre+'</Nombre>
                                                <FlagAfecto>'+CAST(@FILAd_Afecto AS NVARCHAR(250))+'</FlagAfecto>
                                                <Cantidad>'+CAST(@FILAd_CantidadCALC AS NVARCHAR(250))+'</Cantidad>
                                                <PrecioUnitario>'+CAST(@FILAd_PrecioUnitario AS NVARCHAR(250))+'</PrecioUnitario>
                                                <SubTotal>'+CAST(@FILAd_SubTotal AS NVARCHAR(250))+'</SubTotal>
                                                <IGV>'+CAST(@FILAv_TotalIGV AS NVARCHAR(250))+'</IGV>
                                                <Total>'+CAST(@FILAd_Total AS NVARCHAR(250))+'</Total>
                                                <Fecha>'+CONVERT(NVARCHAR(50), @PARAM_HORATRABAJO, 120)+'</Fecha>
                                                <NumeroLote>'+CAST(@FILAd_NumeroLote AS NVARCHAR(250))+'</NumeroLote>
                                                <IdVale>0</IdVale>
                                            </ArchivoPlanoValeDetalle>';

                ---------------------OrigenDetalle --------------------------------------------------------------
                -- 18/10/2018 cambio   @FILAd_CantidadCALC por @FILAd_Cantidad
                SET @p12_01text =(SELECT [ERP].[Obtener_FormatoXML_TransformacionOrigenDetalle](@FILAd_IdProducto, @FILAd_NumeroLote, @FILAd_Afecto, @FILAd_CantidadCALC, @FILAd_PrecioUnitario, @FILAv_TotalIGV, @FILAd_SubTotal, @FILAd_Total, @FILAd_Total));
                SET @p12TEXT = @p12TEXT + @p12_01text;
                  
                FETCH NEXT FROM ProdInfo INTO @FILAd_IDdetalle, @FILAd_IdProducto, @FILAd_Cantidad, @FILAd_Nombre, @FILAd_Afecto;
            END;
        CLOSE ProdInfo;
        DEALLOCATE ProdInfo;
        SET @TRAB_OBSERVACIONES = ('TRANSFORMACION AUTOMATICA REF VENTA: '+@PARAM_REFERENCIAVENTA);
        SET @FILAv_TipoCambio =
        (
            SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT', @PARAM_HORATRABAJO)
        );
        DECLARE @T TABLE(NuevoID INT);
        INSERT INTO @T
        EXEC [ERP].[Usp_Ins_Transformacion] 
             @IdEmpresa = @FILAc_idEmpresa, 
             @IdAlmacenOrigen = @FILAc_idAlmacen, 
             @IdAlmacenDestino = @TRAB_ALMACENDESTINO, 
             @IdMoneda = @TRAB_IDMONEDA, 
             @IdProyecto = @PARAM_IDPROYECTO, 
             @Observaciones = @TRAB_OBSERVACIONES, 
             @Fecha = @PARAM_HORATRABAJO, 
             @FechaIngreso = @PARAM_HORATRABAJO, 
             @FechaSalida = @PARAM_HORATRABAJO, 
             @IdValeIngreso = NULL, 
             @IdValeSalida = NULL, 
             @UsuarioRegistro = @PARAM_USUARIO, 
             @FechaRegistro = @PARAM_HORATRABAJO, 
             @FlagBorrador = 1, 
             @Flag = 1, 
             @PorcentajeIGV = @PARAM_IGV, -- 
             @XMLListaTransformacionOrigenDetalle = '', 
             @XMLListaTransformacionMermaDetalle = '', 
             @XMLListaTransformacionServicioDetalle = '', 
             @XMLListaTransformacionDestinoDetalle = '', 
             @XMLValeIngreso = '', 
             @XMLValeSalida = '';
       SET  @TRAB_IDTRANSFERENCIA =( SELECT TOP 1 [@T].NuevoID
        FROM @T)

        ---------------------OrigenDetalle -------------------------------------------------------------
        SET @p12 = CONVERT(XML, @p12text);

        ---------------------MermaDetalle --------------------------------------------------------------
        SET @p13 = CONVERT(XML, N'');

        ---------------------ServicioDetalle -----------------------------------------------------------
        SET @p14 = CONVERT(XML, N'');

        ---------------------TransformacionDestinoDetalle  @XMLListaTransformacionDestinoDetalle ---------------------------------------------
        SET @p15text = '
                    <TransformacionDestinoDetalle>
                        <ID>0</ID>
                        <IdTransformacion>'+CAST(@TRAB_IDTRANSFERENCIA AS NVARCHAR(250))+'</IdTransformacion>
                        <IdProducto>'+CAST(@FILAc_idProductoFinal AS NVARCHAR(250))+'</IdProducto>
                        <Fecha>'+CONVERT(NVARCHAR(50), @PARAM_HORATRABAJO, 120)+'</Fecha>
                        <FlagAfecto>true</FlagAfecto>
                        <Cantidad>'+CAST(@PARAM_CANTPRODUCTOFINAL AS NVARCHAR(250))+'</Cantidad>
                        <PrecioUnitario>'+CAST(@FILAv_SubTotal AS NVARCHAR(250))+'</PrecioUnitario>
                        <IGV>'+CAST(@DETALLE_IGV_PFINAL AS NVARCHAR(250))+'</IGV>
                        <SubTotal>'+CAST(@FILAv_SubTotal AS NVARCHAR(250))+'</SubTotal>
                        <Total>'+CAST(@FILAv_Total AS NVARCHAR(250))+'</Total>
                        <Producto>
                            <IdEntidad>0</IdEntidad>
                            <ID>0</ID>
                            <Nombre>'+@FILAc_NombreProductoFinal+'</Nombre>
                            <CodigoReferencia>00104006</CodigoReferencia>
                            <IdFamilia>0</IdFamilia>
                            <Cantidad>0</Cantidad>
                            <PorcentajeDescuento>0</PorcentajeDescuento>
                            <PorcentajeISC>0</PorcentajeISC>
                            <PrecioUnitarioLista>0</PrecioUnitarioLista>
                            <PrecioUnitarioListaSinIGV>0</PrecioUnitarioListaSinIGV>
                            <PrecioUnitarioDescuento>0</PrecioUnitarioDescuento>
                            <PrecioUnitarioSubTotal>0</PrecioUnitarioSubTotal>
                            <PrecioUnitarioIGV>0</PrecioUnitarioIGV>
                            <PrecioUnitarioValorISC>0</PrecioUnitarioValorISC>
                            <PrecioUnitarioISC>0</PrecioUnitarioISC>
                            <PrecioUnitarioTotal>0</PrecioUnitarioTotal>
                            <PrecioLista>0</PrecioLista>
                            <PrecioDescuento>0</PrecioDescuento>
                            <PrecioSubTotal>0</PrecioSubTotal>
                            <PrecioIGV>0</PrecioIGV>
                            <PrecioUnitario>0</PrecioUnitario>
                            <PrecioISC>0</PrecioISC>
                            <PrecioTotal>0</PrecioTotal>
                            <Peso>0</Peso>
                            <IdEmpresa>0</IdEmpresa>
                            <IdUnidadMedida>0</IdUnidadMedida>
                            <IdMarca>0</IdMarca>
                            <IdTipoProducto>0</IdTipoProducto>
                            <IdExistencia>0</IdExistencia>
                            <IdListaPrecio>0</IdListaPrecio>
                            <FlagBorrador>false</FlagBorrador>
                            <Flag>false</Flag>
                            <FlagGratuito>false</FlagGratuito>
                            <FlagAfectoIGV>false</FlagAfectoIGV>
                            <FlagISC>false</FlagISC>
                            <Item>0</Item>
                            <FlagConciliado>false</FlagConciliado>
                            <isSelect>false</isSelect>
                            <FechaModificado>0001-01-01T00:00:00</FechaModificado>
                            <Fecha>0001-01-01T00:00:00</Fecha>
                            <Stock>0</Stock>
                            <PrecioPromedio>0</PrecioPromedio>
                            <FechaRegistro>0001-01-01T00:00:00</FechaRegistro>
                            <FechaEliminado>0001-01-01T00:00:00</FechaEliminado>
                            <FechaActivacion>0001-01-01T00:00:00</FechaActivacion>
                            <PrecioUnitarioVale>0</PrecioUnitarioVale>
                        </Producto>
                        <FechaStr>16/08/2018</FechaStr>
                    </TransformacionDestinoDetalle>';
        SET @p15 = CONVERT(XML, @p15text);

        ---------------------ValeIngreso un solo item el producto final ---------------------------------------------------------------
        
        -- construir el autonumerico de documento --1
        SET @FILAv_DOCUMENTO_INGRESO = (SELECT ERP.GenerarNroDocumentoVale(1));

		-------------------
		------------------
		set @p16=convert(xml,N'
							<ArchivoPlanoVale>
								<ID>0</ID>
								<IdTipoMovimiento>1</IdTipoMovimiento>
								<IdTipoComprobante>192</IdTipoComprobante>
								<IdAlmacen>'+CAST(@FILAc_idAlmacen AS NVARCHAR(250))+'</IdAlmacen>
								<IdMoneda>'+CAST(@TRAB_IDMONEDA AS NVARCHAR(250))+'</IdMoneda>
								<IdEntidad>0</IdEntidad>
								<IdEmpresa>'+CAST(@FILAc_idEmpresa AS NVARCHAR(250))+'</IdEmpresa>
								<IdProyecto>0</IdProyecto>
								<IdConcepto>19</IdConcepto>
								<Fecha>'+CONVERT(NVARCHAR(50), @PARAM_HORATRABAJO, 120)+'</Fecha>
								<IdValeEstado>1</IdValeEstado>
								<Serie>0001</Serie>
								<Observacion>AUTO GEN. BOLETA '+ @PARAM_SerieDocumentoComprobante+'</Observacion>
								<TipoCambio>'+CAST(@FILAv_TipoCambio AS NVARCHAR(250))+'</TipoCambio>
								<PorcentajeIGV>'+CAST(@PARAM_IGV AS NVARCHAR(250))+'</PorcentajeIGV>
								<SubTotal>'+CAST(@FILAv_SubTotal AS NVARCHAR(250))+'</SubTotal>
								<IGV>'+CAST(@DETALLE_IGV_PFINAL AS NVARCHAR(250))+'</IGV>
								<Total>'+CAST(@FILAv_Total AS NVARCHAR(250))+'</Total>
								<Peso>0</Peso>
								<UsuarioRegistro>NTX PRO </UsuarioRegistro>
								<FechaRegistro>'+CONVERT(NVARCHAR(50), @PARAM_HORATRABAJO, 120)+'</FechaRegistro>
								<UsuarioModifico>NTX PRO </UsuarioModifico>
								<FechaModificado>0001-01-01T00:00:00</FechaModificado>
								<FechaEliminado>0001-01-01T00:00:00</FechaEliminado>
								<FechaActivacion>0001-01-01T00:00:00</FechaActivacion>
								<FlagBorrador>false</FlagBorrador>
								<FlagTransferencia>false</FlagTransferencia>
								<FlagComprobante>false</FlagComprobante>
								<FlagGuiaRemision>false</FlagGuiaRemision>
								<FlagTransformacion>true</FlagTransformacion>
								<FlagImportacion>false</FlagImportacion>
								<Flag>false</Flag>
							</ArchivoPlanoVale>
							<ListaArchivoPlanoValeDetalle>
								<ArchivoPlanoValeDetalle>
									<ID>0</ID>
									<Item>1</Item>
									<IdProducto>'+CAST(@FILAc_idProductoFinal AS NVARCHAR(250))+'</IdProducto>
									<Nombre>'+CAST(@FILAc_NombreProductoFinal AS NVARCHAR(250))+'</Nombre>
									<FlagAfecto>true</FlagAfecto>
									<Cantidad>'+CAST(@PARAM_CANTPRODUCTOFINAL AS NVARCHAR(250))+'</Cantidad>
									<PrecioUnitario>'+CAST(@FILAv_SubTotal AS NVARCHAR(250))+'</PrecioUnitario>
									<SubTotal>'+CAST(@FILAv_SubTotal AS NVARCHAR(250))+'</SubTotal>
									 <IGV>'+CAST(@DETALLE_IGV_PFINAL AS NVARCHAR(250))+'</IGV>
                                    <Total>'+CAST(@FILAv_Total AS NVARCHAR(250))+'</Total>
                                    <Fecha>'+CONVERT(NVARCHAR(50), @PARAM_HORATRABAJO, 120)+'</Fecha>
									<IdVale>0</IdVale>
								</ArchivoPlanoValeDetalle>
							</ListaArchivoPlanoValeDetalle>')

		-------------------
		------------------



        
        ---------------------ValeSalida  ---------------------------------------------------------------
        
        -- construir el autonumerico de documento  -- antes <IdTipoMovimiento>1</IdTipoMovimiento>  2
        SET @FILAv_DOCUMENTO_SALIDA =(SELECT ERP.GenerarNroDocumentoVale(2));
        SET @p17 = CONVERT(XML, N'<ArchivoPlanoVale>
                                <ID>0</ID>
                                <IdTipoMovimiento>2</IdTipoMovimiento>
                                <IdTipoComprobante>193</IdTipoComprobante>
                                <IdAlmacen>'+CAST(@FILAc_idAlmacen AS NVARCHAR(250))+'</IdAlmacen>
                                <IdMoneda>1</IdMoneda>
                                <IdEntidad>0</IdEntidad>
                                <IdEmpresa>'+CAST(@FILAc_idEmpresa AS NVARCHAR(250))+'</IdEmpresa>
                                <IdProyecto>0</IdProyecto>
                                <IdConcepto>10</IdConcepto>
                                <Fecha>'+CONVERT(NVARCHAR(50), @PARAM_HORATRABAJO, 120)+'</Fecha>
                                <IdValeEstado>1</IdValeEstado>
                                <Serie>0001</Serie>
                                <Observacion>AUTO GEN. BOLETA '+ @PARAM_SerieDocumentoComprobante+'</Observacion>
                                <TipoCambio>'+CAST(@FILAv_TipoCambio AS NVARCHAR(250))+'</TipoCambio>
                                <PorcentajeIGV>'+CAST(@PARAM_IGV AS NVARCHAR(250))+'</PorcentajeIGV>
                                <SubTotal>'+CAST(@FILAv_SubTotal AS NVARCHAR(250))+'</SubTotal>
                                <IGV>'+CAST(@FILAv_TotalIGV AS NVARCHAR(250))+'</IGV>
                                <Total>'+CAST(@FILAv_Total AS NVARCHAR(250))+'</Total>
                                <Peso>0</Peso>
								<UsuarioRegistro>NTX PRO </UsuarioRegistro>
                                <FechaRegistro>0001-01-01T00:00:00</FechaRegistro>
                                <FechaModificado>0001-01-01T00:00:00</FechaModificado>
                                <FechaEliminado>0001-01-01T00:00:00</FechaEliminado>
                                <FechaActivacion>0001-01-01T00:00:00</FechaActivacion>
                                <FlagBorrador>false</FlagBorrador>
                                <FlagTransferencia>false</FlagTransferencia>
                                <FlagComprobante>false</FlagComprobante>
                                <FlagGuiaRemision>false</FlagGuiaRemision>
                                <FlagTransformacion>true</FlagTransformacion>
                                <FlagImportacion>false</FlagImportacion>
                                <Flag>false</Flag>
                            </ArchivoPlanoVale>
                            <ListaArchivoPlanoValeDetalle>
                            '+@DETALLE_VALE_EGRESO+'
                            </ListaArchivoPlanoValeDetalle>');
        
      

        ---------------- PASOS FINALES ---------------


        declare @p18 nvarchar(1024)
        set @p18=N''
        EXEC [ERP].[Usp_Upd_Transformacion] 
            @ID = @TRAB_IDTRANSFERENCIA, 
            @IdEmpresa = @FILAc_idEmpresa, 
            @IdMoneda = @PARAM_IDMONEDA, 
            @IdProyecto = @PARAM_IDPROYECTO, 
            @Observaciones = @PARAM_SerieDocumentoComprobante, 
            @Fecha = @PARAM_HORATRABAJO, 
            @FechaIngreso = @PARAM_HORATRABAJO, 
            @FechaSalida = @PARAM_HORATRABAJO, 
            @UsuarioModifico = NULL, 
            @FechaModificado = @PARAM_HORATRABAJO, 
            @PorcentajeIGV = @PARAM_IGV, 
            @XMLListaTransformacionOrigenDetalle = @p12, 
            @XMLListaTransformacionMermaDetalle = @p13, 
            @XMLListaTransformacionServicioDetalle = @p14, 
            @XMLListaTransformacionDestinoDetalle = @p15, 
            @XMLValeIngreso = @p16, 
            @XMLValeSalida = @p17,

            @DataResult = @p18 OUTPUT;


     ------ GRABAR EN LA OBSERVACION DE LOS VALES LA SECUENCIA AUTOMATICA
     ------ EN REALIDA VA EN LA TABLA VALE REFERENCIA PERO NO SE COMO SE 
     ------ VA A CONSTRUIR
	 --- INSERTAR CODIGO DE 
     
  --   DECLARE @IDVALEINGRESO INT =(SELECT TOP 1 t.IdValeIngreso FROM ERP.Transformacion t WHERE T.ID=@TRAB_IDTRANSFERENCIA)
   --  DECLARE @IDVALESALIDA INT =(SELECT TOP 1 t.IdValeSalida FROM ERP.Transformacion t WHERE T.ID=@TRAB_IDTRANSFERENCIA)

	 --DECLARE @IDVALEINGRESO INT =(SELECT TOP 1 v.ID from ERP.Vale v WHERE v.Documento =@FILAv_DOCUMENTO_INGRESO AND v.IdTipoMovimiento= 1)
  --   DECLARE @IDVALESALIDA INT =(SELECT TOP 1 v.ID  from ERP.Vale v WHERE v.Documento =@FILAv_DOCUMENTO_SALIDA AND v.IdTipoMovimiento = 2)

	 --UPDATE ERP.Vale
	 --SET
	 --    ERP.Vale.IdTipoMovimiento = 1,
	 --    ERP.Vale.IdConcepto =19 
	 --    where id = @IDVALEINGRESO 

 --   UPDATE ERP.Vale
	--SET
	--	ERP.Vale.Observacion = @TRAB_OBSERVACIONES
	--	WHERE ID IN (@IDVALEINGRESO,@IDVALESALIDA) 
    
	--UPDATE erp.Transformacion
	--SET
	--    ERP.Transformacion.IdValeIngreso = @IDVALEINGRESO ,
	--	ERP.Transformacion.IdValeSalida = @IDVALESALIDA,
	--	ERP.Transformacion.Observaciones = 'AUTOGEN. BOLETA: '+ @PARAM_SerieDocumentoComprobante
	--	WHERE  erp.Transformacion.ID =@TRAB_IDTRANSFERENCIA
    END;
END