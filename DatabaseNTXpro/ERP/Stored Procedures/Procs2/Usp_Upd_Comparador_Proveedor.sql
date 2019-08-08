
CREATE PROCEDURE [ERP].[Usp_Upd_Comparador_Proveedor]
@IdComparador	 INT,
@XMLComparador	 XML
AS
BEGIN
		SET QUERY_GOVERNOR_COST_LIMIT 36000
		SET NOCOUNT ON;
		
		UPDATE ERP.ComparadorDetalle
		SET Precio = T.N.value('Precio[1]','DECIMAL(14,5)')
		FROM @XMLComparador.nodes('/ListaComparadorDetalle/ComparadorDetalle') AS T(N)	
		WHERE ID = T.N.value('ID[1]','INT')

		SET NOCOUNT OFF;
END