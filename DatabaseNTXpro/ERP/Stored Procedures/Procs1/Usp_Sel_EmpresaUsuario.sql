CREATE PROC ERP.Usp_Sel_EmpresaUsuario
@IdUsuario INT
AS
BEGIN
	
	SELECT E.ID,
		   EN.Nombre,
		   EU.IdUsuario,
		   CASE WHEN EU.ID IS NOT NULL THEN
			CAST(1 AS BIT)
		   ELSE 
			CAST(0 AS BIT) END AS IsCheck
	FROM ERP.Empresa E
	LEFT JOIN ERP.EmpresaUsuario EU
		ON EU.IdEmpresa = E.ID AND EU.IdUsuario = @IdUsuario
	INNER JOIN ERP.Entidad EN
		ON EN.ID = E.IdEntidad
	WHERE E.Flag = 1 AND E.FlagBorrador = 0 
	
END