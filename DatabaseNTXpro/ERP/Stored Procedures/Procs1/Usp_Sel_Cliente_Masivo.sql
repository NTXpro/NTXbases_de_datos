create PROC [ERP].[Usp_Sel_Cliente_Masivo]

AS
BEGIN
	  
SELECT CLI.ID, E.Nombre NombreCompleto, ES.ID IdEstablecimientoCliente, ES.Nombre, CLI.IdVendedor FROM ERP.Cliente CLI 
INNER JOIN  ERP.Entidad E on E.Id = CLI.IdEntidad
INNER JOIN ERP.Establecimiento ES ON ES.IdEntidad = E.ID
where IdTipoRelacion = 6
END