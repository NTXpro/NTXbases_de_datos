-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 20/08/2018
-- Description:	RETORNA FORMATO XML PARA EL INGRESO DE UNA LINEA DEL DETALLE TRANSFORMACIONES TRANSFORMACIONES
-- =============================================
CREATE FUNCTION [ERP].[Obtener_FormatoXML_TransformacionOrigenDetalle] 
(
	@VALOR_IdProducto AS nvarchar(250),
	@VALOR_NumeroLote AS nvarchar(250),
	@VALOR_Afecto AS  nvarchar(250),
	@VALOR_Cantidad AS  nvarchar(250),
	@VALOR_PrecioUnitario AS nvarchar(250),
	@VALOR_IGV AS nvarchar(250),
	@VALOR_SubTotal AS nvarchar(250),
	@VALOR_Total AS nvarchar(250),
	@VALOR_Nombre AS nvarchar(250)
)
RETURNS nvarchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @RESULTADO nvarchar(max)

	SET @RESULTADO='<TransformacionOrigenDetalle>
    <ID>0</ID>
    <IdTransformacion>0</IdTransformacion>
    <IdProducto>'+@VALOR_IdProducto+'</IdProducto>
    <Lote>'+@VALOR_NumeroLote+'</Lote>
    <FlagAfecto>'+@VALOR_Afecto+'</FlagAfecto>
    <Cantidad>'+@VALOR_Cantidad+'</Cantidad>
    <PrecioUnitario>'+@VALOR_PrecioUnitario+'</PrecioUnitario>
    <IGV>'+@VALOR_IGV+'</IGV>
    <SubTotal>'+@VALOR_SubTotal+'</SubTotal>
    <Total>'+@VALOR_Total+'</Total>
    <Producto>
        <IdEntidad>0</IdEntidad>
        <ID>0</ID>
        <Nombre>'+@VALOR_Nombre+'</Nombre>
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
</TransformacionOrigenDetalle>'

	-- Return the result of the function
	RETURN @RESULTADO

END