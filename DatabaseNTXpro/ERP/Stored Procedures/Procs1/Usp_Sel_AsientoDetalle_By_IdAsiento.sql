CREATE PROCEDURE [ERP].[Usp_Sel_AsientoDetalle_By_IdAsiento] --1
@IdAsiento INT
AS
BEGIN
	SELECT
		 AD.[ID]
		,AD.[IdAsiento]
		,AD.[Orden]
		,AD.[IdPlanCuenta]
		,UPPER(AD.[Nombre]) AS Nombre
		,AD.[IdDebeHaber]
		,AD.[IdProyecto]
		,ISNULL(AD.[Fecha], A.[Fecha]) AS Fecha
		,AD.[ImporteSoles]
		,AD.[ImporteDolares]
		,AD.[IdEntidad]
		,AD.[IdTipoComprobante]
		,AD.[Serie]
		,AD.[Documento]
		,AD.[FechaRegistro]
		,AD.[FechaEliminado]
		,AD.[FlagBorrador]
		,AD.[Flag]
		,AD.[FlagAutomatico]
		,AD.[FechaModificado]
		,AD.[UsuarioRegistro]
		,AD.[UsuarioModifico]
		,AD.[UsuarioElimino]
		,AD.[UsuarioActivo]
		,AD.[FechaActivacion]
		,ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END, 0) AS Debe
        ,ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END, 0) AS Haber
		----------------------
		,PC.CuentaContable
		,PC.Nombre AS NombrePlanCuenta
		,PR.Numero AS CodigoProyecto
		,PR.Nombre AS NombreProyecto
		,TC.CodigoSunat
		,TC.Nombre AS NombreTipoComprobante
		,ISNULL(TCD.VentaSunat, A.TipoCambio) AS VentaSunat
		,ETD.NumeroDocumento AS NumeroDocumento
	FROM [ERP].[AsientoDetalle] AD
	INNER JOIN [ERP].[Asiento] A ON AD.IdAsiento = A.ID
	LEFT JOIN [ERP].[PlanCuenta] PC ON AD.IdPlanCuenta = PC.ID
	LEFT JOIN [ERP].[Proyecto] PR ON AD.IdProyecto = PR.ID
	LEFT JOIN [PLE].[T10TipoComprobante] TC ON AD.IdTipoComprobante = TC.ID
	LEFT JOIN [ERP].[TipoCambioDiario] TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
	LEFT JOIN [ERP].[Entidad] EN ON AD.IdEntidad = EN.ID
	LEFT JOIN [ERP].[EntidadTipoDocumento] ETD ON ETD.IdEntidad = EN.ID	
	WHERE AD.[IdAsiento] = @IdAsiento
	ORDER BY AD.Orden ASC
END
