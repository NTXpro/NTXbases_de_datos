CREATE PROCEDURE [ERP].[Usp_Paginate_AsientoDetalle]
@IdAsiento INT,
@IdPlanCuenta INT,
@Descripcion VARCHAR(500),
@IdProyecto INT,
@IdTipoComprobante INT,
---------------------------------
@RowsPerPage		INT,		  -- CANTIDAD A MOSTRAR PORPAGINA
@Page				INT,	      -- NUMERO DE PAGINA
@SortColumn			VARCHAR(100), -- COLUMNA
@SortDirection		VARCHAR(100), -- ORDENAMIENTO
@TotalRows			INT = 0 OUT	  -- TOTAL DE FILAS (PARAMETRO DE SALIDAS)
AS
BEGIN
	WITH TEMP AS (
		SELECT ROW_NUMBER() OVER (ORDER BY AD.Orden) AS RowNumber,
		AD.Orden,
        AD.ID,
        PC.CuentaContable,
        AD.Nombre,
        PR.Numero AS CodigoProyecto,
        CASE WHEN RTRIM(LTRIM(CONCAT(TD.Abreviatura, ': ',ETD.NumeroDocumento))) = ':' THEN '' 
		ELSE CONCAT(TD.Abreviatura, ': ',ETD.NumeroDocumento) END AS NumeroDocumento,
        TC.CodigoSunat,
        AD.Serie,
        AD.Documento,
        AD.Fecha,
        CASE WHEN A.IdOrigen = 2 THEN A.TipoCambio
		ELSE TCD.VentaSunat END AS VentaSunat,
        ISNULL(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END, 0) AS Debe,
        ISNULL(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END, 0) AS Haber
        FROM [ERP].[AsientoDetalle] AD
		INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
        LEFT JOIN [ERP].[PlanCuenta] PC ON AD.IdPlanCuenta = PC.ID
        LEFT JOIN [ERP].[Proyecto] PR ON AD.IdProyecto = PR.ID
        LEFT JOIN [PLE].[T10TipoComprobante] TC ON AD.IdTipoComprobante = TC.ID
        LEFT JOIN [ERP].[TipoCambioDiario] TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
        LEFT JOIN [ERP].[Entidad] EN ON AD.IdEntidad = EN.ID
        LEFT JOIN [ERP].[EntidadTipoDocumento] ETD ON ETD.IdEntidad = EN.ID
		LEFT JOIN [PLE].[T2TipoDocumento] TD ON ETD.IdTipoDocumento = TD.ID
        WHERE AD.[IdAsiento] = @IdAsiento AND
		(@IdPlanCuenta = 0 OR AD.IdPlanCuenta = @IdPlanCuenta) AND
		(@Descripcion = '' OR @Descripcion IS NULL OR AD.Nombre LIKE '%' + @Descripcion + '%') AND
		(@IdProyecto = 0 OR AD.IdProyecto = @IdProyecto) AND
		(@IdTipoComprobante = 0 OR AD.IdTipoComprobante = @IdTipoComprobante))
	SELECT 
	RowNumber,
	Orden,
	ID,
	CuentaContable,
	Nombre, 
	CodigoProyecto,
	NumeroDocumento,
	CodigoSunat,
	Serie,
	Documento,
	Fecha,
	VentaSunat,
	Debe,
	Haber
	FROM TEMP
	WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage

	SET @TotalRows = (SELECT COUNT(1)
					  FROM [ERP].[AsientoDetalle] AD
					  LEFT JOIN [ERP].[PlanCuenta] PC ON AD.IdPlanCuenta = PC.ID
					  LEFT JOIN [ERP].[Proyecto] PR ON AD.IdProyecto = PR.ID
					  LEFT JOIN [PLE].[T10TipoComprobante] TC ON AD.IdTipoComprobante = TC.ID
					  LEFT JOIN [ERP].[TipoCambioDiario] TCD ON CAST(AD.Fecha AS DATE) = CAST(TCD.Fecha AS DATE)
					  LEFT JOIN [ERP].[Entidad] EN ON AD.IdEntidad = EN.ID
					  LEFT JOIN [ERP].[EntidadTipoDocumento] ETD ON ETD.IdEntidad = EN.ID
					  LEFT JOIN [PLE].[T2TipoDocumento] TD ON ETD.IdTipoDocumento = TD.ID
					  WHERE AD.[IdAsiento] = @IdAsiento AND
					  (@IdPlanCuenta = 0 OR AD.IdPlanCuenta = @IdPlanCuenta) AND
					  (@Descripcion = '' OR @Descripcion IS NULL OR AD.Nombre LIKE '%' + @Descripcion + '%') AND
					  (@IdProyecto = 0 OR AD.IdProyecto = @IdProyecto) AND
				      (@IdTipoComprobante = 0 OR AD.IdTipoComprobante = @IdTipoComprobante))
END