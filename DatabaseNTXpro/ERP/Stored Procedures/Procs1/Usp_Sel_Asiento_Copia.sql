CREATE PROC [ERP].[Usp_Sel_Asiento_Copia]
@IdEmpresa INT,
@IdPeriodo INT,
@IdOrigen INT,
@Glosa VARCHAR(255)
AS
BEGIN
	SELECT 
	     A.[ID]
		,A.[Nombre]
		,A.[Orden]
		,A.[Fecha]
		,A.[IdEmpresa]
		,A.[IdPeriodo]
		,A.[IdOrigen]
		,A.[IdMoneda]
		,A.[TipoCambio]
		,A.[UsuarioRegistro]
		,A.[FechaRegistro]
		,A.[UsuarioModifico]
		,A.[FechaModificado]
		,A.[UsuarioActivo]
		,A.[FechaActivacion]
		,A.[UsuarioElimino]
		,A.[FechaEliminado]
		,A.[FlagEditar]
		,A.[FlagBorrador]
		,A.[Flag]
		,AN.Nombre AS NombreAnio
		,M.Nombre AS NombreMes
		,AN.ID AS IdAnio
		,M.Valor AS ValorMes
		,M.ID AS IdMes
		,O.Nombre AS NombreOrigen
		,MO.Nombre AS NombreMoneda
		,O.FlagOrigenAutomatico
	FROM [ERP].[Asiento] A
	LEFT JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	LEFT JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	LEFT JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	LEFT JOIN Maestro.Moneda MO ON A.IdMoneda = MO.ID
    WHERE
	A.Flag = 1 AND
	A.FlagBorrador = 0 AND
	A.IdEmpresa = @IdEmpresa AND
	(O.FlagOrigenAutomatico IS NULL OR O.FlagOrigenAutomatico = 0) AND
	A.IdPeriodo = @IdPeriodo AND
	A.IdOrigen = @IdOrigen AND
	(@Glosa IS NULL OR @Glosa = '' OR A.Nombre LIKE '%' + @Glosa + '%')
END