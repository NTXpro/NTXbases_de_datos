

CREATE PROC [ERP].[Usp_Del_Entidad]
@IdEntidad			INT
AS
BEGIN
	
	DELETE FROM ERP.Persona WHERE IdEntidad = @IdEntidad
	DELETE FROM ERP.Establecimiento WHERE IdEntidad = @IdEntidad
	DELETE FROM ERP.EntidadTipoDocumento WHERE IdEntidad = @IdEntidad
	DELETE FROM ERP.Entidad WHERE ID = @IdEntidad

END

