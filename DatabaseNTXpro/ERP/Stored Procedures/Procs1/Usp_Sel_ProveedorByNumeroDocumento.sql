CREATE PROC [ERP].[Usp_Sel_ProveedorByNumeroDocumento]  --1 , 4
@IdEmpresa INT,
@NombreDocumento VARCHAR(250)
AS
BEGIN
	SELECT  PRO.ID,
			EN.Nombre AS NombreCompleto,
			P.Nombre ,
			P.ApellidoPaterno,
			P.ApellidoMaterno,
			PRO.IdEmpresa,
			ETD.IdTipoDocumento,
			ETD.NumeroDocumento,
			TD.Abreviatura AS NombreTipoDocumento
	FROM ERP.Proveedor PRO
	INNER JOIN ERP.Entidad EN
	ON EN.ID = PRO.IdEntidad
	INNER JOIN ERP.EntidadTipoDocumento ETD
	ON ETD.IdEntidad=EN.ID
	INNER JOIN PLE.T2TipoDocumento TD
	ON TD.ID= ETD.IdTipoDocumento
	INNER JOIN ERP.Empresa EMP
	ON EMP.ID = PRO.IdEmpresa
	LEFT JOIN ERP.Persona P
	ON P.IdEntidad = EN.ID
	WHERE PRO.Flag = 1 AND PRO.FlagBorrador = 0 AND PRO.IdEmpresa = @IdEmpresa AND (@NombreDocumento = '' OR (EN.Nombre LIKE '%'+@NombreDocumento+'%' OR ETD.NumeroDocumento LIKE '%'+@NombreDocumento+'%'))
	END
