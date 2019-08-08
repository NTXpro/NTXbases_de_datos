

CREATE PROC [ERP].[Usp_Ins_CajaChica_Transferencia]
@IdCajaChica	 INT,
@XMLCajaChica	 XML
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	SET NOCOUNT ON;

	DECLARE @OrdenCajaChica INT = (SELECT Orden FROM ERP.MovimientoCajaChica WHERE ID = @IdCajaChica);
	DECLARE @IdAsiento INT = 0;
	DECLARE @IdMovimientoTesoreriaReceptor INT = 0;
	DECLARE @IdMovimientoCajaChicaDetalle INT = 0;
	DECLARE @IdTransferencia INT = 0;
	DECLARE @FlagTransferencia BIT = 0;
	DECLARE @IdEmpresa INT = (SELECT IdEmpresa FROM ERP.MovimientoCajaChica WHERE ID = @IdCajaChica);
	DECLARE @IdPeriodo INT = (SELECT IdPeriodo FROM ERP.MovimientoCajaChica WHERE ID = @IdCajaChica);
	DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(DISTINCT T.N.value('Indice[1]','INT')) FROM @XMLCajaChica.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N))
	DECLARE @Nombre VARCHAR(250) = 'CAJA CHICA N° ' +  CAST(@OrdenCajaChica AS VARCHAR(10));
	DECLARE @indice INT = 1;
	WHILE @indice <= @TOTAL_ITEMS
	BEGIN
		SET @FlagTransferencia = (SELECT T.N.value('FlagTransferencia[1]','BIT') FROM @XMLCajaChica.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N) WHERE T.N.value('Indice[1]','INT') = @indice)
		SET @IdMovimientoCajaChicaDetalle = (SELECT T.N.value('IdMovimientoCajaChicaDetalle[1]','INT') FROM @XMLCajaChica.nodes('/ListaArchivoPlanoMovimientoTesoreria/ArchivoPlanoMovimientoTesoreria') AS T(N) WHERE T.N.value('Indice[1]','INT') = @indice)
		IF @FlagTransferencia = 1
		BEGIN
			--INSERT MOVIMIENTO EMISOR(INGRESO)  
			EXEC ERP.Usp_Ins_CajaChica_Transferencia_MovimientoTesoreria @IdMovimientoTesoreriaReceptor OUT, @XMLCajaChica, @Nombre, @indice, @IdEmpresa, @IdPeriodo, 1, 2 --INGRESO,HABER

			UPDATE [ERP].[MovimientoCajaChicaDetalle] SET IdMovimientoTesoreria = @IdMovimientoTesoreriaReceptor WHERE ID = @IdMovimientoCajaChicaDetalle

		END
		SET @indice += 1;
	END
	SET NOCOUNT OFF;
END
