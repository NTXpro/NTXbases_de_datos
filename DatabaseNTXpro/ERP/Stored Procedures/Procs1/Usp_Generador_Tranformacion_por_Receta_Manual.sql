-- =============================================
-- Author:        OMAR RODRIGUEZ
-- Create date: 06/09/2018
-- Description:    GENERADOR DE TRANSFORMACIONES POR LA SELECCION DE RECETAS EN LA PAGINA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Generador_Tranformacion_por_Receta_Manual]
@PARAM_IDTRANSFORMACION INT,
@PARAM_IDRECETA INT
AS
BEGIN
-- VARIABLES DE TRABAJO
DECLARE @PARAM_IDPRODUCTOFINAL INT
DECLARE @PARAM_CANTPRODUCTOFINAL INT= 1
DECLARE @PARAM_REFERENCIAVENTA NVARCHAR(250)
DECLARE @PARAM_USUARIO VARCHAR(250)
DECLARE @PARAM_HORATRABAJO DATETIME
DECLARE @PARAM_IDPROYECTO INT
DECLARE @PARAM_IGV DECIMAL(14,5)
DECLARE @PARAM_IDMONEDA INT
DECLARE @TRAB_IGV DECIMAL(14,5);
DECLARE @TRAB_ALMACENDESTINO INT;
DECLARE @TRAB_IDTRANSFERENCIA INT;
DECLARE @TRAB_IDRECETA INT;
DECLARE @TRAB_IDMONEDA INT;
DECLARE @TRAB_HORADIFERENCIA INT;
DECLARE @TRAB_OBSERVACIONES VARCHAR(250)
DECLARE @TRAB_FechaIngreso DATETIME
DECLARE @TRAB_FechaSalida DATETIME

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

            SET @TRAB_IGV =
            (
                SELECT CAST(VALOR AS DECIMAL(14, 5)) / 100
                FROM ERP.PARAMETRO P
                WHERE P.ABREVIATURA = 'IGV'
            );
            

            set @PARAM_HORATRABAJO= getdate()

          
             

         
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
            WHERE rpd.IdReceta = @PARAM_IDRECETA;
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
                                                <Cantidad>'+CAST(@FILAd_Cantidad AS NVARCHAR(250))+'</Cantidad>
                                                <PrecioUnitario>'+CAST(@FILAd_PrecioUnitario AS NVARCHAR(250))+'</PrecioUnitario>
                                                <SubTotal>'+CAST(@FILAd_SubTotal AS NVARCHAR(250))+'</SubTotal>
                                                <IGV>'+CAST(@FILAv_TotalIGV AS NVARCHAR(250))+'</IGV>
                                                <Total>'+CAST(@FILAd_Total AS NVARCHAR(250))+'</Total>
                                                <Fecha>'+CONVERT(NVARCHAR(50), @PARAM_HORATRABAJO, 120)+'</Fecha>
                                                <NumeroLote>'+CAST(@FILAd_NumeroLote AS NVARCHAR(250))+'</NumeroLote>
                                                <IdVale>0</IdVale>
                                            </ArchivoPlanoValeDetalle>';

                ---------------------OrigenDetalle --------------------------------------------------------------
                  
                SET @p12_01text =(SELECT [ERP].[Obtener_FormatoXML_TransformacionOrigenDetalle](@FILAd_IdProducto, @FILAd_NumeroLote, @FILAd_Afecto, @FILAd_Cantidad, @FILAd_PrecioUnitario, @FILAv_TotalIGV, @FILAd_SubTotal, @FILAd_Total, @FILAd_Total));
                SET @p12TEXT = @p12TEXT + @p12_01text;
                  
                FETCH NEXT FROM ProdInfo INTO @FILAd_IDdetalle, @FILAd_IdProducto, @FILAd_Cantidad, @FILAd_Nombre, @FILAd_Afecto;
            END;
        CLOSE ProdInfo;
        DEALLOCATE ProdInfo;


        SET @TRAB_OBSERVACIONES = ('');
        SET @FILAv_TipoCambio =
        (
            SELECT [ERP].[ObtenerTipoCambioVenta_By_Sistema_Fecha]('SUNAT', @PARAM_HORATRABAJO)
        );
       

        ---------------------OrigenDetalle -------------------------------------------------------------
        SET @p12 = CONVERT(XML, @p12text);

        ---------------------MermaDetalle --------------------------------------------------------------
        SET @p13 = CONVERT(XML, N'');

        ---------------------ServicioDetalle -----------------------------------------------------------
        SET @p14 = CONVERT(XML, N'');

        ---------------------TransformacionDestinoDetalle  @XMLListaTransformacionDestinoDetalle ---------------------------------------------
        SELECT @FILAc_idProductoFinal =r.IdProducto, @FILAc_NombreProductoFinal=p.Nombre FROM ERP.Receta r INNER JOIN ERP.Producto p ON r.IdProducto = p.ID
        WHERE r.ID = @PARAM_IDRECETA
        SET @p15text = '
                    <TransformacionDestinoDetalle>
                        <ID>0</ID>
                        <IdTransformacion>'+CAST(@PARAM_IDTRANSFORMACION AS NVARCHAR(250))+'</IdTransformacion>
                        <IdProducto>'+CAST(@FILAc_idProductoFinal AS NVARCHAR(250))+'</IdProducto>
                        <Fecha>'+CONVERT(NVARCHAR(50), @PARAM_HORATRABAJO, 120)+'</Fecha>
                        <FlagAfecto>true</FlagAfecto>
                        <Cantidad>1</Cantidad>
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

        SET @p16 = CONVERT(XML, N'');
        SET @p17 = CONVERT(XML, N'');


        SELECT @FILAv_ALMACEN_ORIGEN = t.IdAlmacenOrigen, 
               @TRAB_ALMACENDESTINO = t.IdAlmacenDestino, 
               @TRAB_IDMONEDA = t.IdMoneda, 
               @PARAM_IDPROYECTO = t.IdProyecto, 
               @PARAM_IDPROYECTO = t.Observaciones, 
               @PARAM_IGV = t.PorcentajeIGV
        FROM ERP.Transformacion t
        WHERE t.ID = @PARAM_IDTRANSFORMACION;
        
        EXEC [ERP].[Usp_Upd_TransformacionBorrador] 
             @ID = @PARAM_IDTRANSFORMACION, 
             @IdAlmacenOrigen = @FILAv_ALMACEN_ORIGEN, 
             @IdAlmacenDestino = @TRAB_ALMACENDESTINO, 
             @IdMoneda = @TRAB_IDMONEDA, 
             @IdProyecto = @PARAM_IDPROYECTO, 
             @Observaciones = @TRAB_OBSERVACIONES, 
             @Fecha = @PARAM_HORATRABAJO, 
             @FechaIngreso = @PARAM_HORATRABAJO, 
             @FechaSalida = @PARAM_HORATRABAJO, 
             @PorcentajeIGV = @PARAM_IGV, -- 
             @XMLListaTransformacionOrigenDetalle = @p12, 
             @XMLListaTransformacionMermaDetalle = @p13, 
             @XMLListaTransformacionServicioDetalle = @p14, 
             @XMLListaTransformacionDestinoDetalle = @p15, 
             @XMLValeIngreso = @p16, 
             @XMLValeSalida = @p17;


                 
    END