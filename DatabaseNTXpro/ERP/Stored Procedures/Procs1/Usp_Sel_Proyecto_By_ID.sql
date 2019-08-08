CREATE PROC [ERP].[Usp_Sel_Proyecto_By_ID]
@ID int
AS
BEGIN
declare @tabla table(ID INT , Nombre varchar(50), IdProyectoPrincipal int)
DECLARE @IdProyectoPrincipal int = (select IdProyectoPrincipal from erp.proyecto where ID=@ID)
insert into @tabla select ID,Nombre,IdProyectoPrincipal from erp.proyecto 


	SELECT	PRO.ID,
			PRO.Nombre,
			PRO.Numero,
			PRO.FechaInicio,
			PRO.FechaFin,
			PRO.UsuarioRegistro,
			PRO.UsuarioModifico,
			PRO.UsuarioElimino,
			PRO.UsuarioActivo,
			PRO.FechaRegistro,
			PRO.FechaModificado,
			PRO.FechaEliminado,
			PRO.FechaActivacion,
			PRO.FlagCierre,
			PRO.IdCliente,
			E.Nombre NombreCliente,
			PRO.IdMoneda,
			PRO.PresupuestoCompra,
			PRO.PresupuestoVenta,
			PRO.IdProyectoPrincipal,
			PRO.IdTipoProyecto,
			MO.Nombre as NombreMoneda,
			TA.Nombre AS NombreProyectoPrincipal
			
		
			
		
	FROM [ERP].[Proyecto] PRO
	LEFT JOIN ERP.Cliente C ON C.ID = PRO.IdCliente
	LEFT JOIN ERP.Entidad E ON E.ID = C.IdEntidad
	LEFT JOIN Maestro.Moneda MO ON MO.ID=PRO.IdMoneda
LEFT JOIN @tabla TA ON TA.ID=@IdProyectoPrincipal
		WHERE PRO.ID = @ID 

	


END