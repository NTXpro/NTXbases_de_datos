CREATE PROC [ERP].[Usp_Ins_EstructuraTres]
@IdEstructuraDos INT,
@Nombre VARCHAR(200),
@UsuarioRegistro varchar(250),
@FechaRegistro datetime
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	
	DECLARE @ID INT;
	DECLARE @ORDEN INT = (SELECT TOP 1 Orden + 1 FROM [ERP].[EstructuraTres] WHERE IdEstructuraDos = @IdEstructuraDos ORDER BY Orden DESC); 

	INSERT INTO [ERP].[EstructuraTres](
		IdEstructuraDos,
		Nombre,
		Orden,
		UsuarioRegistro,
		FechaRegistro,
		Flag)
	VALUES(
		@IdEstructuraDos,
		@Nombre,
		@ORDEN,
		@UsuarioRegistro,
		@FechaRegistro,
		1)

	SET @ID = CAST(SCOPE_IDENTITY() AS INT)

	SELECT CONCAT('#', EBGD.IdEstructuraUno, '-', EBGD.ID, '-', EBGT.ID) FROM [ERP].[EstructuraTres] EBGT
	INNER JOIN [ERP].[EstructuraDos] EBGD ON EBGT.IdEstructuraDos = EBGD.ID
	WHERE EBGT.ID = @ID
END
