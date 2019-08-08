CREATE PROC [ERP].[Usp_Upd_EstructuraTres]
@ID INT,
@Nombre VARCHAR(200),
@UsuarioModifico varchar(250),
@FechaModificado datetime
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	
	UPDATE [ERP].[EstructuraTres] SET
	Nombre = RTRIM(LTRIM(@Nombre)),
	UsuarioModifico = @UsuarioModifico,
	FechaModificado = @FechaModificado
	WHERE ID = @ID

	SELECT @ID;
END
