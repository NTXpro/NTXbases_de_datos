
CREATE PROC [ERP].[Usp_Sel_Compra_By_Serie_Documento]
@IdProveedor INT,
@IdTipoComprobante INT,
@IdEmpresa INT,
@Serie VARCHAR(4),
@Documento VARCHAR(10)
AS
BEGIN

	DECLARE @IdEntidad INT = (SELECT IdEntidad FROM ERP.Proveedor PRO WHERE PRO.IdEmpresa = @IdEmpresa AND PRO.ID = @IdProveedor)

	SELECT C.ID,
		   C.IdTipoComprobante,
		   TC.Nombre NombreTipoComprobante,
		   C.Serie,
		   C.Numero,
		   RO.ID		IdOrigen
	FROM ERP.Compra C
	INNER JOIN PLE.T10TipoComprobante TC
	ON TC.ID = C.IdTipoComprobante
	LEFT JOIN Maestro.ReferenciaOrigen RO
	ON RO.Codigo = 'COM'
	WHERE C.IdTipoComprobante = @IdTipoComprobante AND C.Serie= @Serie AND C.Numero = @Documento
	AND C.FlagBorrador = 0 AND C.Flag = 1 AND C.IdProveedor = @IdProveedor
	
	UNION ALL

	SELECT VA.ID,
		   VA.IdTipoComprobante,
		   TC.Nombre NombreTipoComprobante,
		   VA.Serie,
		   VA.Documento Numero,
		   RO.ID		IdOrigen
	FROM ERP.Vale VA
	INNER JOIN PLE.T10TipoComprobante TC
	ON TC.ID = VA.IdTipoComprobante
	LEFT JOIN Maestro.ReferenciaOrigen RO
	ON RO.Codigo = 'LOGVAL'
	WHERE VA.IdTipoComprobante = @IdTipoComprobante AND VA.Serie = @Serie AND VA.Documento = @Documento 
	AND VA.FlagBorrador = 0 AND VA.Flag = 1 AND VA.IdEntidad = @IdEntidad

	UNION ALL

	SELECT SA.ID,
		   SA.IdTipoComprobante,
		   TC.Nombre  NombreTipoComprobante,
		   SA.Serie,
		   SA.Documento Numero,
		   RO.ID  IdOrigen
	FROM ERP.SaldoInicial SA
	INNER JOIN PLE.T10TipoComprobante TC
	ON TC.ID = SA.IdTipoComprobante
	LEFT JOIN Maestro.ReferenciaOrigen RO
	ON RO.Codigo = 'COMSI'
	WHERE SA.IdTipoComprobante = @IdTipoComprobante AND SA.Serie = @Serie AND SA.Documento = @Documento 
	AND SA.FlagBorrador = 0 AND SA.Flag = 1 AND SA.IdProveedor = @IdProveedor

END
