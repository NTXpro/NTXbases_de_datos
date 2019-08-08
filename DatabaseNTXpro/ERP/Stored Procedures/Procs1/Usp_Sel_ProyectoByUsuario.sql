
CREATE PROC [ERP].[Usp_Sel_ProyectoByUsuario]
@IdEmpresa INT,
@IdProyecto INT
AS
BEGIN
		
		IF @IdProyecto is not null 
	 


		SELECT  PRO.ID,
			--PRO.Nombre			,
			CASE
				WHEN PRO.IdTipoProyecto = 1 THEN CONCAT(' ', PRO.Nombre)
				WHEN PRO.IdTipoProyecto = 2 THEN CONCAT(P.Nombre, ' - ', PRO.Nombre)
			END Nombre,
			'' AS Numero,
			PRO.FechaInicio,
			PRO.FechaFin,
			PRO.FechaEliminado
	FROM ERP.Proyecto PRO
		INNER JOIN ERP.Empresa EM
		ON EM.ID=PRO.IdEmpresa
		LEFT JOIN ERP.Proyecto P ON P.ID = PRO.IdProyectoPrincipal
		
    WHERE PRO.Flag = 1 AND PRO.FlagBorrador = 0 AND PRO.IdEmpresa =@IdEmpresa
	AND PRO.IdTipoProyecto IN (1, 2) AND PRO.ID = @IdProyecto

	UNION 

	
		SELECT  PRO.ID,
			--PRO.Nombre			,
			CASE
				WHEN PRO.IdTipoProyecto = 1 THEN CONCAT(' ', PRO.Nombre)
				WHEN PRO.IdTipoProyecto = 2 THEN CONCAT(P.Nombre, ' - ', PRO.Nombre)
			END Nombre,
			'' AS Numero,
			PRO.FechaInicio,
			PRO.FechaFin,
			PRO.FechaEliminado
	FROM ERP.Proyecto PRO
		INNER JOIN ERP.Empresa EM
		ON EM.ID=PRO.IdEmpresa
		LEFT JOIN ERP.Proyecto P ON P.ID = PRO.IdProyectoPrincipal
		
    WHERE PRO.Flag = 1 AND PRO.FlagBorrador = 0 AND PRO.IdEmpresa = @IdEmpresa
	AND PRO.IdTipoProyecto IN (1, 2) AND PRO.IdProyectoPrincipal = @IdProyecto

	ELSE

	SELECT  PRO.ID,
			--PRO.Nombre			,
			CASE
				WHEN PRO.IdTipoProyecto = 1 THEN CONCAT(' ', PRO.Nombre)
				WHEN PRO.IdTipoProyecto = 2 THEN CONCAT(P.Nombre, ' - ', PRO.Nombre)
			END Nombre,
			'' AS Numero,
			PRO.FechaInicio,
			PRO.FechaFin,
			PRO.FechaEliminado
	FROM ERP.Proyecto PRO
		INNER JOIN ERP.Empresa EM
		ON EM.ID=PRO.IdEmpresa
		LEFT JOIN ERP.Proyecto P ON P.ID = PRO.IdProyectoPrincipal
	
    WHERE PRO.Flag = 1 AND PRO.FlagBorrador = 0 AND PRO.IdEmpresa =@IdEmpresa
	AND PRO.IdTipoProyecto IN (1, 2) 
END