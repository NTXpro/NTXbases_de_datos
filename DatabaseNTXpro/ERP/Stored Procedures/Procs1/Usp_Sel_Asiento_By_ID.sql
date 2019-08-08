CREATE PROCEDURE [ERP].[Usp_Sel_Asiento_By_ID]
@ID INT
AS
BEGIN
	SELECT 
	     A.[ID]
		,UPPER(A.[Nombre]) AS Nombre
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
		,CONCAT(O.Abreviatura, RIGHT('000000000' + LTRIM(RTRIM(A.Orden)),9)) AS Comprobante
		,CONCAT(O.Abreviatura, ' - ', UPPER(O.Nombre)) AS NombreOrigen
		,CONCAT(MO.CodigoSunat, ' - ', UPPER(MO.Nombre)) AS NombreMoneda
		,O.FlagOrigenAutomatico,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END), 0) AS TotalDebe,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END), 0) AS TotalHaber,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN (CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END), 0) -
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN (CASE WHEN A.IdMoneda = 1 THEN AD.ImporteSoles ELSE AD.ImporteDolares END) END), 0) AS Diferencia
	FROM [ERP].[Asiento] A
	LEFT JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	LEFT JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	LEFT JOIN Maestro.Mes M ON P.IdMes = M.ID
	LEFT JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	LEFT JOIN Maestro.Moneda MO ON A.IdMoneda = MO.ID
	LEFT JOIN ERP.AsientoDetalle AD ON A.ID = AD.IdAsiento
    WHERE  A.ID = @ID
	GROUP BY
	A.[ID],
	A.[Nombre],
	A.[Orden],
	A.[Fecha],
	A.[IdEmpresa],
	A.[IdPeriodo],
	A.[IdOrigen],
	A.[IdMoneda],
	A.[TipoCambio],
	A.[UsuarioRegistro],
	A.[FechaRegistro],
	A.[UsuarioModifico],
	A.[FechaModificado],
	A.[UsuarioActivo],
	A.[FechaActivacion],
	A.[UsuarioElimino],
	A.[FechaEliminado],
	A.[FlagEditar],
	A.[FlagBorrador],
	A.[Flag],
	AN.Nombre,
	M.Nombre,
	AN.ID,
	M.Valor,
	M.ID,
	O.Abreviatura,
	O.Nombre,
	MO.CodigoSunat,
	MO.Nombre,
	O.FlagOrigenAutomatico
END
