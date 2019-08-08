CREATE PROC [ERP].[Usp_Sel_ProveedorByTipoDocumento] 
@IdEmpresa INT,
@IdTipoDocumento INT
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
	WHERE PRO.Flag = 1 AND PRO.FlagBorrador = 0 AND PRO.IdEmpresa = @IdEmpresa
	AND ETD.IdTipoDocumento = @IdTipoDocumento OR ETD.IdTipoDocumento = 1 AND EMP.ID = @IdEmpresa AND PRO.ID NOT IN (SELECT PRO.ID FROM ERP.Empresa EM INNER JOIN ERP.Entidad ENT ON ENT.ID = EM.IdEntidad INNER JOIN ERP.Proveedor PRO ON PRO.IdEntidad = ENT.ID WHERE EM.ID = @IdEmpresa)
END
