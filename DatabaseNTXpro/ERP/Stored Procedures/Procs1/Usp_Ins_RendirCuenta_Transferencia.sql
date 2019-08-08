CREATE PROC [ERP].[Usp_Ins_RendirCuenta_Transferencia]
@IdRendirCuenta	 INT,
@XMLRendirCuenta	 XML
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	SET NOCOUNT ON;

	DECLARE @OrdenCajaChica INT = (SELECT Orden FROM ERP.MovimientoRendirCuenta WHERE ID = @IdRendirCuenta);
	DECLARE @IdAsiento INT = 0;
	DECLARE @IdMovimientoTesoreriaReceptor INT = 0;
	DECLARE @IdMovimientoRendirCuentaDetalle INT = 0;
	DECLARE @IdTransferencia INT = 0;
	DECLARE @FlagTransferencia BIT = 0;
	DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.MovimientoRendirCuenta WHERE ID = @IdRendirCuenta);
	DECLARE @IdPeriodo INT = (SELECT IdPeriodo FROM ERP.MovimientoRendirCuenta WHERE ID = @IdRendirCuenta);
	DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(DISTINCT T.N.value('Indice[1]','INT')) FROM @XMLRendirCuenta.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N))
	DECLARE @Nombre VARCHAR(250) = 'RENDIR CUENTA N° ' +  CAST(@OrdenCajaChica AS VARCHAR(10));
	DECLARE @indice INT = 1;
	WHILE @indice <= @TOTAL_ITEMS
	BEGIN
		SET @FlagTransferencia = (SELECT T.N.value('FlagTransferencia[1]','BIT') FROM @XMLRendirCuenta.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N) WHERE T.N.value('Indice[1]','INT') = @indice)
		SET @IdMovimientoRendirCuentaDetalle = (SELECT T.N.value('IdMovimientoRendirCuentaDetalle[1]','INT') FROM @XMLRendirCuenta.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N) WHERE T.N.value('Indice[1]','INT') = @indice)
		IF @FlagTransferencia = 1
		BEGIN
			--INSERT MOVIMIENTO EMISOR(INGRESO)  
			EXEC ERP.Usp_Ins_CajaChica_Transferencia_MovimientoTesoreria @IdMovimientoTesoreriaReceptor OUT, @XMLRendirCuenta, @Nombre, @indice, @IdEmpresa, @IdPeriodo, 1, 2 --INGRESO,HABER

			UPDATE [ERP].[MovimientoRendirCuentaDetalle] SET IdMovimientoTesoreria = @IdMovimientoTesoreriaReceptor WHERE ID = @IdMovimientoRendirCuentaDetalle

		END
		SET @indice += 1;
	END
	SET NOCOUNT OFF;
END
