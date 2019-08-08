CREATE PROC [ERP].[Usp_Del_Comparador_By_ID]
@ID INT
AS
BEGIN
	  DELETE FROM [ERP].[ComparadorReferencia]
	  WHERE IdComparador = @ID


	  DELETE FROM [ERP].[ComparadorDetalle]
	  WHERE IdComparador = @ID

	  DELETE FROM [ERP].[Comparador]
	  WHERE ID = @ID
END