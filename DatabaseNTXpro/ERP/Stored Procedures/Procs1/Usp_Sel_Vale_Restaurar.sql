CREATE PROC [ERP].[Usp_Sel_Vale_Restaurar]
@IdEmpresa INT
AS
BEGIN
	SELECT 
		V.ID,
		V.IdTipoMovimiento,
		V.IdTipoOperacion,
		V.IdAlmacen,
		V.IdProyecto,
		V.IdMoneda,
		V.IdProveedor,
		V.Fecha,
		V.UsuarioRegistro,
		V.FechaRegistro,
		V.UsuarioModifico,
		V.FechaModificado,
		V.UsuarioElimino,
		V.FechaEliminado,
		V.UsuarioActivo,
		V.FechaActivacion,
		V.FlagBorrador,
		V.Flag,
		V.IdsDocumentoReferencia,
		TM.Nombre AS NombreTipoMovimiento,
		TOPE.Nombre AS NombreTipoOperacion,
		A.Nombre AS NombreAlmacen,
		P.Nombre AS NombreProyecto,
		MO.Nombre AS NombreMoneda,
		PRO.IdEntidad,
		EN.Nombre AS NombreEntidad
	FROM [ERP].[Vale] V
	INNER JOIN [Maestro].[TipoMovimiento] TM ON V.IdTipoMovimiento = TM.ID
	INNER JOIN [PLE].[T12TipoOperacion] TOPE ON V.IdTipoOperacion = TOPE.ID
	INNER JOIN [ERP].[Almacen] A ON V.IdAlmacen = A.ID
	INNER JOIN [ERP].[Proyecto] P ON V.IdProyecto = P.ID
	INNER JOIN [Maestro].[Moneda] MO ON V.IdMoneda = MO.ID
	INNER JOIN [ERP].[Proveedor] PRO ON V.IdProveedor = PRO.ID
	INNER JOIN [ERP].[Entidad] EN ON PRO.IdEntidad = EN.ID
	WHERE
	V.Flag = 0 AND
	A.ID IN (SELECT DISTINCT A.ID
			 FROM ERP.Almacen A
			 INNER JOIN ERP.Establecimiento E ON E.ID = A.IdEstablecimiento
			 WHERE A.IdEmpresa = @IdEmpresa AND A.FlagBorrador = 0 AND A.Flag = 1)
END