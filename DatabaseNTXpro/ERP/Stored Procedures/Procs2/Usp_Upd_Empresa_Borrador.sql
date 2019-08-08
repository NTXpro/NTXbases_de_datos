
create PROC [ERP].[Usp_Upd_Empresa_Borrador]
@IdEntidad			INT,
@Nombre				VARCHAR(250),
@NumeroDocumento	CHAR(11)
AS
BEGIN
	
	UPDATE ERP.Entidad SET Nombre = @Nombre WHERE ID = @IdEntidad

	UPDATE ERP.EntidadTipoDocumento SET NumeroDocumento = @NumeroDocumento WHERE IdEntidad = @IdEntidad AND IdTipoDocumento = 2

END

