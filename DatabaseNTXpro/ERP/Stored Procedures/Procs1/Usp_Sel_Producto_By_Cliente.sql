
CREATE PROC [ERP].[Usp_Sel_Producto_By_Cliente] 
@IdCliente INT
AS
BEGIN
		
	SELECT DISTINCT TOP 20	PRO.ID,
							PRO.Nombre,
							M.Nombre NombreMarca,
							UM.CodigoSunat CodigoSunatUnidadMedida,
							UM.Nombre NombreUnidadMedida,
							T5E.CodigoSunat,
							PRO.CodigoReferencia
	FROM [ERP].[Producto] PRO
	LEFT JOIN Maestro.Marca M
		ON M.ID = PRO.IdMarca
	LEFT JOIN [PLE].[T6UnidadMedida] UM
		ON UM.ID = PRO.IdUnidadMedida
	LEFT JOIN PLE.T5Existencia T5E
		ON PRO.IdExistencia=T5E.ID
	INNER JOIN ERP.ComprobanteDetalle CD
		ON PRO.ID = CD.IdProducto
	INNER JOIN ERP.Comprobante C
		ON CD.IdComprobante = C.ID
	WHERE C.IdCliente = @IdCliente AND C.FlagBorrador = 0 AND C.Flag = 1 AND PRO.FLAG = 1

END
